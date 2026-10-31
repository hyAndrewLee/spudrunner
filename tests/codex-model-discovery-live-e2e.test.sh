#!/usr/bin/env bash
# Token-free live guard for Codex config/read and model/list recommendation.
set -eu
# shellcheck source=tests/lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
live_gate default-on FM_LIVE_CODEX_MODEL_DISCOVERY codex node
TMP_ROOT=$(test_tmproot codex-model-discovery-live)
version=$(codex --version)
# A per-process override reproduces stale inheritance without changing any
# user configuration, credential, account pin, or existing Codex process.
printf '#!/usr/bin/env bash\nexec %q -c %q "$@"\n' "$(command -v codex)" 'model="spudrunner-stale-inherited-default"' > "$TMP_ROOT/codex"
chmod +x "$TMP_ROOT/codex"
if ! result=$(node "$ROOT/bin/codex-model-resolve.mjs" "$TMP_ROOT/codex" "$ROOT"); then
  fail "Codex model discovery incompatible with $version"
fi
printf '%s' "$result" | node -e '
const d = JSON.parse(require("fs").readFileSync(0,"utf8"));
if (d.inheritedModel !== "spudrunner-stale-inherited-default" ||
    d.model === d.inheritedModel || !d.model || d.provider !== "openai") process.exit(1);
console.log(JSON.stringify(d));
' || fail "Codex recommendation did not override stale inheritance on $version"
pass "Codex $version supports token-free catalog selection without inherited model fallback"
