#!/usr/bin/env bash
set -eu
ROOT=$PWD
EVID=/home/andrew/.no-mistakes-spudrunner-validation/evidence/01M69EX8VRHH9KGGPKA552E2B1
SCRATCH=$ROOT/.test-current-models
REAL_CODEX=$(command -v codex)
REAL_PI=$(command -v pi)
LAB=$(mktemp -d "${TMPDIR:-/tmp}/fm-lab.XXXXXX")
cleanup() { TMUX_TMPDIR="$LAB/tmux" tmux -L fm-lab kill-server 2>/dev/null || true; chmod -R u+w "$LAB"; rm -rf "$LAB"; }
trap cleanup EXIT
bin/lab-home.sh create "$LAB"
mkdir -p "$LAB/tmux" "$SCRATCH/bin" "$SCRATCH/user/.codex" "$SCRATCH/other/.codex" "$SCRATCH/account"
printf 'model = "spudrunner-stale-inherited-default"\nmodel_reasoning_effort = "low"\n' > "$SCRATCH/user/.codex/config.toml"
cp "$SCRATCH/user/.codex/config.toml" "$SCRATCH/account/config.toml"
export REAL_CODEX
cat > "$SCRATCH/bin/codex" <<'SH'
#!/usr/bin/env bash
CAPTURE=$(< "$(dirname "$0")/capture-path")
for arg in "$@"; do
  if [ "$arg" = app-server ]; then
    printf 'native catalog: CODEX_HOME=%s cwd=%s\n' "$CODEX_HOME" "$PWD" >> "$CAPTURE.catalog"
    exec "$REAL_CODEX" "$@"
  fi
done
python3 - "$CAPTURE" "$@" <<'PY'
import json,sys,os
with open(sys.argv[1], 'w') as f: json.dump(dict(argv=sys.argv[2:], cwd=os.getcwd(), HOME=os.getenv('HOME'),CODEX_HOME=os.getenv('CODEX_HOME')),f,indent=2)
PY
printf 'TOKEN-FREE LAUNCH BOUNDARY: argv recorded, no worker started\n'
SH
chmod +x "$SCRATCH/bin/codex"
cp "$SCRATCH/bin/codex" "$SCRATCH/bin/pi"
# The real Pi CLI handles capability/help probes; inference launch is capture-only.
python3 - "$SCRATCH/bin/pi" "$REAL_PI" <<'PY'
import sys
p=sys.argv[1]; s=open(p).read(); s=s.replace('CAPTURE=$(<', 'if [ "${1:-}" = --help ] || [ "${1:-}" = --version ]; then exec '+repr(sys.argv[2])+' "$@"; fi\nCAPTURE=$(<')
open(p,'w').write(s)
PY
# Entire terminal and allocator are real, with isolated fixture HOME/config.
env -u TMUX -u FM_ROOT_OVERRIDE -u FM_STATE_OVERRIDE -u FM_DATA_OVERRIDE -u FM_CONFIG_OVERRIDE -u FM_PROJECTS_OVERRIDE TMUX_TMPDIR="$LAB/tmux" tmux -L fm-lab -f /dev/null new-session -d -x 140 -y 40 -s primary -c "$ROOT" /bin/bash --noprofile --norc
export TMUX_TMPDIR="$LAB/tmux"
SOCKET=$(tmux -L fm-lab display-message -p -t primary '#{socket_path}')
export TMUX="$SOCKET,$(tmux -L fm-lab display-message -p -t primary '#{pid}'),0"
# Plain tmux calls made by the public launcher inherit this private socket.
tmux set-option -g default-shell /bin/bash
export PATH="$SCRATCH/bin:$PATH"
run_case() {
  name=$1; desthome=$2; destroot=$3; supervisorroot=$4; filtering=$5; shift 5
  printf 'model = "spudrunner-stale-inherited-default"\nmodel_reasoning_effort = "low"\n' > "$SCRATCH/user/.codex/config.toml"
  case "$name" in
    refuse-provider) printf 'model_provider="private-provider"\n[model_providers.private-provider]\nname="Disposable private provider"\nbase_url="http://127.0.0.1:1/v1"\nwire_api="responses"\n' > "$SCRATCH/user/.codex/config.toml" ;;
    refuse-effort) printf 'model_reasoning_effort="minimal"\n' > "$SCRATCH/user/.codex/config.toml" ;;
    refuse-unavailable) printf 'invalid = [\n' > "$SCRATCH/user/.codex/config.toml" ;;
  esac
  proj="$SCRATCH/project-$name"
  mkdir -p "$proj"
  git -C "$proj" init -q -b main
  printf 'disposable fixture\n' > "$proj/readme"
  printf 'max_trees = 1\nroot = "%s"\n' "$SCRATCH/pool-$name" > "$proj/treehouse.toml"
  git -C "$proj" add .
  git -C "$proj" -c user.name='Validation Fixture' -c user.email='validation@example.invalid' commit -qm fixture
  mkdir -p "$LAB/data/$name"
  printf '# Task\n## Captain\x27s intent\nValidate launch boundary only.\n\n## Firstmate spec\nNo model prompt may be submitted.\n' > "$LAB/data/$name/brief.md"
  printf 'manual\n' > "$LAB/config/backlog-backend"
  printf 'codex\n' > "$LAB/config/crew-harness"
  rm -f "$LAB/config/launch-env-allowlist" "$LAB/config/crew-dispatch.json"
  if [ "$name" = configured-pin ]; then
    printf '%s\n' '{"default":{"harness":"codex","model":"configured-pin","effort":"high"}}' > "$LAB/config/crew-dispatch.json"
  fi
  case "$filtering" in empty) : > "$LAB/config/launch-env-allowlist" ;; allowed) printf 'CODEX_HOME\n' > "$LAB/config/launch-env-allowlist" ;; esac
  CAPTURE="$EVID/$name.argv.json"; export CAPTURE
  printf '%s\n' "$CAPTURE" > "$SCRATCH/bin/capture-path"
  rm -f "$CAPTURE" "$CAPTURE.catalog"
  # Avoid any user's shell startup files and pin all destination values.
  printf -v cmd 'env HOME=%q CODEX_HOME=%q PATH=%q SHELL=/bin/bash REAL_CODEX=%q CAPTURE=%q /bin/bash --noprofile --norc' "$desthome" "$destroot" "$PATH" "$REAL_CODEX" "$CAPTURE"
  tmux set-option -g default-command "$cmd"
  echo "=== $name ==="
  set +e
  (unset FM_ROOT_OVERRIDE FM_STATE_OVERRIDE FM_DATA_OVERRIDE FM_CONFIG_OVERRIDE FM_PROJECTS_OVERRIDE FM_GATE_REFUSE_BYPASS FM_TASK_ID CODEX_HOME
    if [ "$supervisorroot" != unset ]; then export CODEX_HOME="$supervisorroot"; fi
    export HOME="$SCRATCH/user" FM_HOME="$LAB" FM_SPAWN_NO_GUARD=1 SHELL=/bin/bash
    "$ROOT/bin/task-launch.sh" "$name" "$proj" --mode local-only --yolo off --backend tmux "$@"
  ) > "$EVID/$name.launch.log" 2>&1
  rc=$?
  set -e
  printf 'parent_exit=%s\n' "$rc"
  # Capture real product output and its public persisted record.
  python3 - "$EVID/$name.launch.log" <<'PY'
import sys
print(open(sys.argv[1]).read())
PY
  if [ -f "$LAB/state/$name.meta" ]; then cp "$LAB/state/$name.meta" "$EVID/$name.meta"; fi
  if [ -f "$LAB/state/$name.status" ]; then cp "$LAB/state/$name.status" "$EVID/$name.status"; fi
  tmux capture-pane -p -t "primary:fm-$name" -S -120 > "$EVID/$name.pane.txt" 2>/dev/null || true
  case "$name" in refuse-*)
    [ "$rc" -ne 0 ]; ! grep -q "spawned $name" "$EVID/$name.launch.log"
    [ ! -e "$LAB/state/$name.meta" ]; [ ! -e "$CAPTURE" ]
    grep -q 'no inherited-model fallback' "$EVID/$name.launch.log"
    echo 'Observed: real native configuration/catalog refusal; no selected-model record or worker invocation.' ;;
    conflict-*)
    [ "$rc" -ne 0 ]; ! grep -q "spawned $name" "$EVID/$name.launch.log"
    [ ! -e "$LAB/state/$name.meta" ]; [ ! -e "$LAB/state/$name.busy-gen" ]; [ ! -e "$LAB/state/$name.busy-state" ]
    [ ! -e "$CAPTURE" ]; [ ! -e "$CAPTURE.catalog" ]; [ ! -e "$LAB/data/backlog.md" ]
    grep -q 'failed' "$LAB/state/$name.status"
    echo 'Observed: parent refusal; no worker argv, catalog request, active metadata, busy state or backlog transition.' ;;
    *)
    [ "$rc" -eq 0 ]; [ -f "$LAB/state/$name.meta" ]
    # Wait boundedly for real terminal execution of the argv-only safety capture.
    for ((i=0;i<100;i++)); do [ ! -s "$CAPTURE" ] || break; sleep .1; done
    [ -s "$CAPTURE" ]
    python3 - "$CAPTURE" "$EVID/$name.meta" <<'PY'
import json,sys
v=json.load(open(sys.argv[1])); m=dict(x.rstrip('\n').split('=',1) for x in open(sys.argv[2]) if '=' in x)
print('Observed record:', {k:m.get(k) for k in ['harness','model','effort','model_source','model_provider']})
print('Captured execution:',json.dumps(v))
if m['model']!='default': assert v['argv'][v['argv'].index('--model')+1]==m['model']
else: assert '--model' not in v['argv']
assert v['cwd']==m['worktree']
PY
    ;;
  esac
  tmux kill-window -t "primary:fm-$name" 2>/dev/null || true
}
run_case conflict-codex-home "$SCRATCH/user" "$SCRATCH/other/.codex" unset none
run_case conflict-home "$SCRATCH/other" '' unset none
run_case compatible-default "$SCRATCH/user" '' unset none
run_case filtered-conflict "$SCRATCH/user" "$SCRATCH/other/.codex" "$SCRATCH/account" empty
run_case compatible-explicit "$SCRATCH/user" "$SCRATCH/account" "$SCRATCH/account" allowed
run_case explicit-pin "$SCRATCH/other" "$SCRATCH/other/.codex" unset none --harness codex --model deliberately-pinned --effort high
run_case intentional-default "$SCRATCH/other" "$SCRATCH/other/.codex" unset none --harness codex --model default
run_case configured-pin "$SCRATCH/other" "$SCRATCH/other/.codex" unset none --harness codex --model configured-pin --effort high
run_case other-runtime "$SCRATCH/other" "$SCRATCH/other/.codex" unset none --harness pi --model xai/provider-pin --effort high
run_case refuse-provider "$SCRATCH/user" '' unset none
run_case refuse-effort "$SCRATCH/user" '' unset none
run_case refuse-unavailable "$SCRATCH/user" '' unset none
printf 'ALL LIVE LAUNCH-BOUNDARY CASES COMPLETED; no inference execution attempted.\n'
