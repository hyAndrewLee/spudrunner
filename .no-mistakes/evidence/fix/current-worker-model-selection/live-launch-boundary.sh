#!/usr/bin/env bash
set -euo pipefail
ROOT=$PWD
EVIDENCE=/home/andrew/.no-mistakes-spudrunner-validation/evidence/01M69EX8VRHH9KGGPKA552E2B1
mkdir -p "$EVIDENCE"
LAB=$(mktemp -d "${TMPDIR:-/tmp}/fm-lab.XXXXXX")
cleanup() { TMUX_TMPDIR="$LAB/tmux" tmux -L fm-lab kill-server 2>/dev/null || :; chmod -R u+w "$LAB"; rm -rf "$LAB"; }
trap cleanup EXIT
bash bin/lab-home.sh create "$LAB"
mkdir -p "$LAB/tmux" "$LAB/bin" "$LAB/project"
REAL_CODEX=$(command -v codex)
REAL_HOME=$HOME
REAL_ROOT=${CODEX_HOME:-$HOME/.codex}
export LAB REAL_CODEX
printf '%s' "$REAL_CODEX" > "$LAB/real-codex"
unset NO_MISTAKES_GATE FM_GATE_REFUSE_BYPASS FM_ROOT_OVERRIDE FM_STATE_OVERRIDE FM_DATA_OVERRIDE FM_CONFIG_OVERRIDE FM_PROJECTS_OVERRIDE FM_TASK_ID HERDR_ENV HERDR_SESSION HERDR_PANE_ID REX_SESSION REX_BLOCK TASKS_AXI_FILE TASKS_AXI_BACKEND
export FM_HOME="$LAB" TMUX_TMPDIR="$LAB/tmux"
# Disposable project; no operator repository, credential or account is changed.
git -C "$LAB/project" init -q -b main
git -C "$LAB/project" -c user.name=Fixture -c user.email=fixture@example.invalid commit -q --allow-empty -m fixture
git -C "$LAB/project" worktree add -q -b worker "$LAB/wt"
printf 'codex\n' > "$LAB/config/crew-harness"
touch "$LAB/state/.last-watcher-beat"
cat > "$LAB/bin/codex" <<'SH'
#!/usr/bin/env bash
set -eu
LAB=$(dirname "$(dirname "$0")")
REAL_CODEX=$(cat "$LAB/real-codex")
if [[ " $* " == *' app-server '* ]]; then
  printf 'native app-server CODEX_HOME=%s\n' "${CODEX_HOME:-}" >> "$LAB/discovery.log"
  exec "$REAL_CODEX" "$@"
fi
node - "$LAB/capture.jsonl" "$@" <<'JS'
const fs=require('fs');
fs.appendFileSync(process.argv[2],JSON.stringify({runtime:'codex',home:process.env.CODEX_HOME,userHome:process.env.HOME,secret:process.env.LAB_SECRET??null,args:process.argv.slice(3)})+'\n');
JS
SH
cat > "$LAB/bin/pi" <<'SH'
#!/usr/bin/env bash
set -eu
LAB=$(dirname "$(dirname "$0")")
if [ "${1:-}" = --help ]; then printf 'Pi 0.84.0 --tui-mode --approve\n'; exit; fi
node - "$LAB/capture.jsonl" "$@" <<'JS'
require('fs').appendFileSync(process.argv[2],JSON.stringify({runtime:'pi',args:process.argv.slice(3)})+'\n');
JS
SH
# No shell startup files from the real HOME are sourced; this shell belongs only to the lab.
cat > "$LAB/rc" <<'SH'
export HISTFILE=/dev/null
export HOME="$(cat "$LAB/dest-home")"
if [ -s "$LAB/dest-root" ]; then export CODEX_HOME="$(cat "$LAB/dest-root")"; else unset CODEX_HOME; fi
export LAB_SECRET=must-be-filtered
export PATH="$LAB/bin:$PATH"
treehouse() { cd "$LAB/wt"; }
SH
cat > "$LAB/shell" <<'SH'
#!/usr/bin/env bash
exec /bin/bash --noprofile --rcfile "$LAB/rc" -i
SH
chmod +x "$LAB/bin/"* "$LAB/shell"
printf '%s' "$REAL_HOME" > "$LAB/dest-home"
: > "$LAB/dest-root"
tmux -L fm-lab -f /dev/null new-session -d -s primary -x 160 -y 50 -c "$ROOT" '/bin/bash --noprofile --norc'
tmux -L fm-lab set-option -g default-command "$LAB/shell"
export TMUX="$(tmux -L fm-lab display-message -p -t primary '#{socket_path}'),$(tmux -L fm-lab display-message -p -t primary '#{pid}'),0"
export PATH="$LAB/bin:$PATH"
run_case() {
 local id=$1 expectation=$2; shift 2
 mkdir -p "$LAB/data/$id"
 printf '# Task\n## User intent\nToken-free launch-boundary capture only.\n## Implementation requirements\nNever submit an inference request.\n' > "$LAB/data/$id/brief.md"
 : > "$LAB/capture.jsonl"; : > "$LAB/discovery.log"
 local rc=0
 env HOME="$REAL_HOME" CODEX_HOME="${SUP_ROOT:-}" FM_SPAWN_NO_GUARD=1 bash "$ROOT/bin/task-launch.sh" "$id" "$LAB/project" --mode no-mistakes --yolo off --backend tmux "$@" > "$EVIDENCE/$id.log" 2>&1 || rc=$?
 printf '\nCASE %s exit=%s expected=%s\n' "$id" "$rc" "$expectation"
 cat "$EVIDENCE/$id.log"
 if [ "$expectation" = refuse ]; then
   [ "$rc" -ne 0 ]; ! grep -q "spawned $id" "$EVIDENCE/$id.log"
   grep -q 'explicit supported --model' "$EVIDENCE/$id.log"
   grep -q 'failed \[at=' "$LAB/state/$id.status"
   for suffix in meta busy-gen busy-state; do [ ! -e "$LAB/state/$id.$suffix" ]; done
   [ ! -s "$LAB/capture.jsonl" ]; [ ! -s "$LAB/discovery.log" ]
   [ ! -e "$LAB/data/backlog.md" ]
   cp "$LAB/state/$id.status" "$EVIDENCE/$id.status.txt"
 else
   [ "$rc" -eq 0 ]; grep -q "spawned $id" "$EVIDENCE/$id.log"
   # Bounded wait for a shell to execute the delivered argv-capture command, not an LLM turn.
   for ((i=0;i<40;i++)); do [ ! -s "$LAB/capture.jsonl" ] || break; sleep .1; done
   [ -s "$LAB/capture.jsonl" ]
   cp "$LAB/capture.jsonl" "$EVIDENCE/$id.argv.jsonl"
   grep -E '^(harness|model|model_source|model_provider|effort)=' "$LAB/state/$id.meta" | tee "$EVIDENCE/$id.meta.txt"
   node - "$LAB/capture.jsonl" <<'JS'
const c=JSON.parse(require('fs').readFileSync(process.argv[2],'utf8'));c.args=c.args.filter(x=>!x.includes('FIRSTMATE_OP:'));console.log(JSON.stringify(c));
JS
 fi
 cp "$LAB/discovery.log" "$EVIDENCE/$id.discovery.log"
 echo "PASS $id"
}
# Reproduce the previously blocked real terminal check first.
SUP_ROOT=
printf '%s' "$LAB/conflicting-account" > "$LAB/dest-root"
run_case live-root-conflict refuse
: > "$LAB/dest-root"; printf '%s' "$LAB/other-home" > "$LAB/dest-home"
run_case live-home-conflict refuse
printf '%s' "$REAL_HOME" > "$LAB/dest-home"
# Native catalog from the normal local account; wrapper captures argv instead of submitting a prompt.
SUP_ROOT=$REAL_ROOT; printf '%s' "$REAL_ROOT" > "$LAB/dest-root"
: > "$LAB/config/launch-env-allowlist"
# Empty filter drops destination CODEX_HOME; native default root must agree.
SUP_ROOT=
run_case live-compatible-filtered success
node - "$EVIDENCE/live-compatible-filtered.argv.jsonl" "$LAB/state/live-compatible-filtered.meta" "$REAL_HOME/.codex" <<'JS'
const fs=require('fs');const c=JSON.parse(fs.readFileSync(process.argv[2],'utf8'));const m=Object.fromEntries(fs.readFileSync(process.argv[3],'utf8').trim().split('\n').map(x=>x.split(/=(.*)/s).slice(0,2)));
if(c.home!==process.argv[4]||c.secret!==null||!m.model||m.model==='default'||!c.args.includes(m.model)||m.model_source!=='codex-model-list')process.exit(1);
JS
[ -s "$LAB/discovery.log" ]
# Pin paths must not consult discovery, even with a destination config conflict.
rm "$LAB/config/launch-env-allowlist"
printf '%s' "$LAB/conflicting-account" > "$LAB/dest-root"
run_case live-explicit-pin success --harness codex --model deliberate-test-pin --effort high
[ ! -s "$LAB/discovery.log" ]; grep -q '^model=deliberate-test-pin$' "$LAB/state/live-explicit-pin.meta"
run_case live-inherit-pin success --harness codex --model default
[ ! -s "$LAB/discovery.log" ]
node - "$LAB/capture.jsonl" <<'JS'
if(JSON.parse(require('fs').readFileSync(process.argv[2],'utf8')).args.includes('--model'))process.exit(1);
JS
printf '%s\n' '{"default":{"harness":"codex","model":"configured-test-pin","effort":"high"}}' > "$LAB/config/crew-dispatch.json"
# Dispatch profiles are handed to task-launch as concrete flags, not a profile name.
read -r pin_harness pin_model pin_effort < <(jq -r '.default | [.harness,.model,.effort] | @tsv' "$LAB/config/crew-dispatch.json")
run_case live-configured-pin success --harness "$pin_harness" --model "$pin_model" --effort "$pin_effort"
[ ! -s "$LAB/discovery.log" ]; grep -q '^model=configured-test-pin$' "$LAB/state/live-configured-pin.meta"
rm "$LAB/config/crew-dispatch.json"
run_case live-other-runtime success --harness pi --model xai/provider-pin --effort high
[ ! -s "$LAB/discovery.log" ]; grep -q '^harness=pi$' "$LAB/state/live-other-runtime.meta"
echo 'ALL LIVE LAUNCH-BOUNDARY SCENARIOS PASSED; native catalog only; argv captures are not inference/entitlement proof.'
