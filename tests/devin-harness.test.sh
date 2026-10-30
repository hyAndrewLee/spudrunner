#!/usr/bin/env bash
# Portable Devin worker adapter regression. Vendor facts are refreshed by
# devin-signals-live-e2e.test.sh; this suite needs no Devin credentials.
set -u
# shellcheck source=tests/fixtures.sh
. "$(dirname "${BASH_SOURCE[0]}")/fixtures.sh"
# shellcheck source=bin/agent-control-lib.sh
. "$ROOT/bin/agent-control-lib.sh"
# shellcheck source=bin/agent-activity-lib.sh
. "$ROOT/bin/agent-activity-lib.sh"
# shellcheck source=bin/agent-input-lib.sh
. "$ROOT/bin/agent-input-lib.sh"
# shellcheck source=bin/agent-process-lib.sh
. "$ROOT/bin/agent-process-lib.sh"
TMP_ROOT=$(test_tmproot fm-devin-harness)
HARNESS="$ROOT/bin/agent-runtime.sh"
unset CLAUDECODE PI_CODING_AGENT GROK_AGENT CURSOR_AGENT CURSOR_INVOKED_AS GEMINI_CLI FM_OMP_HARNESS ATLASSIAN_AGENT_TYPE ROVODEV_CLI

mkdir -p "$TMP_ROOT/names"
for name in devin devin-helper; do ln -s /bin/bash "$TMP_ROOT/names/$name"; done
# shellcheck disable=SC2016
out=$(CLAUDECODE=1 "$TMP_ROOT/names/devin" -c '"$1"; :' _ "$HARNESS")
[ "$out" = devin ] || fail "native Devin ancestry must beat foreign CLAUDECODE: $out"
# shellcheck disable=SC2016
out=$("$TMP_ROOT/names/devin-helper" -c '"$1" ancestry "$$"; :' _ "$HARNESS")
[ "$out" != 'comm devin' ] || fail "unrelated devin-helper claimed the adapter"
[ "$(agent_process_classify_name /opt/bin/devin)" = agent ] || fail "liveness lost Devin"
[ "$(agent_process_classify_name devin-helper)" = other ] || fail "liveness claims unrelated executable"
pass "Devin native identity; anchored liveness"

[ "$(agent_control_interrupt_key devin)" = Escape ] || fail 'wrong interrupt key'
[ "$(agent_control_interrupt_repeat devin)" = 2 ] || fail 'Devin needs double Escape'
[ -z "$(agent_control_interrupt_clear_key devin)" ] || fail 'Devin must not erase a composer draft'
[ "$(agent_control_exit_command devin)" = /quit ] || fail 'wrong exit command'
agent_control_harness_supports_kind devin ship || fail 'ship refused'
agent_control_harness_supports_kind devin scout || fail 'scout refused'
! agent_control_harness_supports_kind devin secondmate || fail 'secondmate accepted'
pass "worker-only resolution and lifecycle capabilities"

[ "$(agent_input_classify_content 1 '❭ Ask Devin to build features, fix bugs, or work on your code' "$FM_COMPOSER_IDLE_RE_DEFAULT" sensitive '' 1 0)" = empty ] || fail 'idle placeholder not empty'
[ "$(agent_input_classify_content 1 '❭ unsubmitted draft')" = pending ] || fail 'typed draft not preserved'
[ "$(agent_input_classify_content 0 '❭')" = empty ] || fail 'Devin glyph not recognized'
for signal in 'Thinking · 5s (esc twice to interrupt)' '❭ Guide Devin while it works'; do
  printf '%s\n' "$signal" | agent_activity_lines_match devin || fail "independent delivery signal lost: $signal"
done
! printf '❭ unsubmitted draft\n' | agent_activity_lines_match devin || fail 'draft read busy'
! printf 'esc to cancel\n' | agent_activity_lines_match devin || fail 'borrowed another harness signal'
pass "composer draft safety and independent delivery signals"

state="$TMP_ROOT/hook state"
mkdir -p "$state"
gen=$("$ROOT/bin/agent-activity-event.sh" arm "$state" worker)
printf '%s\n' '{"agent":{"model":"swe-2-high"},"hooks":{"Stop":[{"hooks":[{"type":"command","command":"true"}]}]}}' > "$TMP_ROOT/user.json"
"$ROOT/bin/devin-config.sh" "$state" worker "$gen" "$TMP_ROOT/user.json" || fail 'config writer failed'
config="$state/worker.devin-config.json"
jq -e '.agent.model == "swe-2-high" and (.hooks.Stop | length) == 2' "$config" >/dev/null || fail 'user settings/hooks lost'
run_hook() { bash -c "$(jq -r --arg event "$1" '.hooks[$event][-1].hooks[0].command' "$config")"; }
run_hook UserPromptSubmit
[ "$(agent_activity_classify tmux fake:w devin worker "$state")" = 'busy devin-hook' ] || fail 'submit did not open busy'
run_hook Stop
[ "$(agent_activity_classify tmux fake:w devin worker "$state")" = 'idle devin-hook' ] || fail 'Stop did not settle'
assert_present "$state/worker.turn-ended" 'Stop notification absent'
run_hook UserPromptSubmit
run_hook SessionEnd
[ "$(agent_activity_classify tmux fake:w devin worker "$state")" = 'idle devin-hook' ] || fail 'SessionEnd did not settle'
"$ROOT/bin/agent-activity-event.sh" arm "$state" worker >/dev/null
rm "$state/worker.turn-ended"
run_hook Stop
[ "$(agent_activity_classify tmux fake:w devin worker "$state")" = 'busy fm-spawn' ] || fail 'stale Stop cleared replacement'
assert_absent "$state/worker.turn-ended" 'stale Stop woke replacement'
[ "$(agent_control_harness_wiring_paths devin /unused "$state" worker)" = "$config" ] || fail 'config retirement missing'
printf 'broken' > "$TMP_ROOT/invalid.json"
! "$ROOT/bin/devin-config.sh" "$state" worker "$gen" "$TMP_ROOT/invalid.json" 2>/dev/null || fail 'invalid source accepted'
jq -e . "$config" >/dev/null || fail 'failed write replaced valid config'
pass "private config preserves user hooks; lifecycle and stale-generation rejection"

# A user config that opts into both must still produce a worker config with no
# commit attribution and no imported Claude Code hooks; other import choices
# the user made survive.
printf '%s\n' '{"attribution":true,"read_config_from":{"claude":true,"cursor":false}}' > "$TMP_ROOT/opted-in.json"
"$ROOT/bin/devin-config.sh" "$state" worker "$gen" "$TMP_ROOT/opted-in.json" || fail 'config writer failed'
jq -e '.attribution == false' "$config" >/dev/null \
  || fail 'worker config keeps Devin commit attribution (Co-Authored-By: Devin trailer)'
jq -e '.read_config_from.claude == false and .read_config_from.cursor == false' "$config" >/dev/null \
  || fail 'worker config imports Claude Code hooks or dropped a user import choice'
"$ROOT/bin/devin-config.sh" "$state" worker "$gen" /nonexistent/config.json || fail 'absent source refused'
jq -e '.attribution == false and .read_config_from.claude == false' "$config" >/dev/null \
  || fail 'an absent user config must still disable attribution and Claude hook import'
pass "worker config forces attribution off and Claude Code hook import off"

# With config/keep-ai-trailers, fm-spawn passes FM_KEEP_AI_TRAILERS=1: the
# worker config leaves Devin's attribution as the source had it (absent means
# Devin's default, on) while Claude hook import stays off.
FM_KEEP_AI_TRAILERS=1 "$ROOT/bin/devin-config.sh" "$state" worker "$gen" "$TMP_ROOT/opted-in.json" || fail 'config writer failed'
jq -e '.attribution == true and .read_config_from.claude == false' "$config" >/dev/null \
  || fail 'keep-ai-trailers must leave the source attribution on and still disable Claude hook import'
FM_KEEP_AI_TRAILERS=1 "$ROOT/bin/devin-config.sh" "$state" worker "$gen" /nonexistent/config.json || fail 'absent source refused'
jq -e 'has("attribution") | not' "$config" >/dev/null \
  || fail 'keep-ai-trailers must not write attribution=false for an absent user config'
FM_KEEP_AI_TRAILERS=0 "$ROOT/bin/devin-config.sh" "$state" worker "$gen" "$TMP_ROOT/opted-in.json" || fail 'config writer failed'
jq -e '.attribution == false' "$config" >/dev/null \
  || fail 'FM_KEEP_AI_TRAILERS=0 must still force attribution off'
pass "keep-ai-trailers leaves Devin attribution on"

case_dir="$TMP_ROOT/spawn"
fakebin=$(make_spawn_fakebin "$case_dir/fake" claude)
fake_exit0 "$fakebin" devin
home="$case_dir/home"
proj="$case_dir/project"
wt="$case_dir/wt"
test_spawn_home "$home" devin
git_worktree "$proj" "$wt" devin-test
test_spawn_brief "$home" devin-worker
if ! out=$(FM_FAKE_LAUNCH_LOG="$case_dir/launch" test_run_spawn "$home" "$wt" "$fakebin" devin-worker "$proj" --scout --harness devin --model fusion-claude-fable-5-1-high-sidekick-swe-2-medium --effort xhigh 2>&1)
then fail "spawn failed: $out"; fi
launch=$(cat "$case_dir/launch")
assert_contains "$launch" '--permission-mode dangerous --respect-workspace-trust false' 'autonomy/trust flags missing'
assert_contains "$launch" "--config '$home/state/devin-worker.devin-config.json'" 'private config missing'
assert_contains "$launch" "--model 'fusion-claude-fable-5-1-high-sidekick-swe-2-medium'" 'Fusion model lost'
assert_contains "$launch" 'encode launch-brief' 'typed launch envelope lost'
case "$launch" in *--effort*|*--thinking*) fail 'independent effort reached Devin argv' ;; esac
assert_grep 'effort=xhigh' "$home/state/devin-worker.meta" 'effort not recorded'
assert_present "$home/state/devin-worker.devin-config.json" 'spawn did not wire hooks'
[ "$(agent_activity_classify tmux fake:w devin devin-worker "$home/state")" = 'busy fm-spawn' ] || fail 'launch not armed'
if out=$(test_run_spawn "$home" "$wt" "$fakebin" devin-sm "$proj" --secondmate --harness devin 2>&1)
then fail 'Devin secondmate launch accepted'; fi
assert_contains "$out" 'crewmate/scout adapter only' 'wrong secondmate refusal'
pass "scout launch carries Fusion, autonomy, typed brief and hooks; effort recorded only"
