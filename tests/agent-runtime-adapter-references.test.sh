#!/usr/bin/env bash
# Portable structural validation for the harness-adapters routing artifact.
set -u

# shellcheck source=tests/lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

ROUTER="$ROOT/.agents/skills/harness-adapters/SKILL.md"
TMP_ROOT=$(test_tmproot fm-harness-adapter-references)
ROUTING_JSON="$TMP_ROOT/routing.json"

awk '
  /^```json harness-adapter-routing-v1$/ { capture = 1; next }
  capture && /^```$/ { exit }
  capture { print }
' "$ROUTER" > "$ROUTING_JSON"

jq -e '
  (.operations | type == "object") and
  (.harnesses | type == "object") and
  ([.operations[][] | select(type != "array")] | length == 0) and
  ([.operations[][][] | select(type != "string")] | length == 0) and
  ([.harnesses[] | select(type != "string")] | length == 0)
' "$ROUTING_JSON" >/dev/null || fail "harness adapter routing artifact is not a normalized operation and harness map"

jq -r '.operations[][][], .harnesses[]' "$ROUTING_JSON" | sort -u | while IFS= read -r path; do
  [ -r "$ROOT/.agents/skills/harness-adapters/$path" ] \
    || fail "harness adapter routing target is unreadable: $path"
done
pass "harness adapter routing artifact is normalized and every target is readable"

# Exercise Pi's real resource loader without starting a session or spending tokens.
package_dir=${FM_PI_PACKAGE_DIR:-"$(npm root -g 2>/dev/null)/@earendil-works/pi-coding-agent"}
if command -v node >/dev/null 2>&1 && [ -f "$package_dir/dist/core/skills.js" ]; then
  ROOT="$ROOT" PI_PACKAGE_DIR="$package_dir" node --input-type=module <<'JS' \
    || fail "semantic skills did not load through Pi's resource loader"
import assert from "node:assert/strict";
import { pathToFileURL } from "node:url";
const { loadSkillsFromDir, formatSkillsForPrompt } = await import(
  pathToFileURL(`${process.env.PI_PACKAGE_DIR}/dist/core/skills.js`).href,
);
const result = loadSkillsFromDir({ dir: `${process.env.ROOT}/.agents/skills`, source: "project" });
assert.deepEqual(result.diagnostics, []);
const byName = new Map(result.skills.map((skill) => [skill.name, skill]));
for (const name of ["coding-guidelines", "self-repository-authority", "project-coordinator-provisioning", "investigation-completion", "task-landing", "worker-recovery", "work-summary", "session-summary", "memory-curation", "self-update"]) {
  const skill = byName.get(name);
  assert.ok(skill, `missing canonical skill ${name}`);
  assert.ok(skill.filePath.endsWith(`/${name}/SKILL.md`), `wrong canonical location for ${name}`);
  assert.equal(skill.disableModelInvocation, false);
}
for (const name of ["bearings", "ahoy", "stow", "firstmate-coding-guidelines", "secondmate-provisioning"]) {
  assert.equal(byName.get(name)?.disableModelInvocation, true, `legacy command ${name} lost its redirect`);
}
const prompt = formatSkillsForPrompt(result.skills);
assert.ok(prompt.includes("<name>work-summary</name>"));
assert.ok(!prompt.includes("<name>bearings</name>"));
JS
  pass "canonical skills load through Pi while installed command aliases stay explicit-only"
else
  printf 'skip: Pi package not installed (real semantic skill-loader check)\n'
fi
