#!/usr/bin/env bash
# End-to-end remote reply relay through fm-on and the process-event runner.
set -u

# shellcheck source=tests/lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)
TMP_ROOT=$(test_tmproot fm-remote-reply)
mkdir -p "$TMP_ROOT"
TMP_ROOT=$(cd "$TMP_ROOT" && pwd -P)
PARENT="$TMP_ROOT/parent"
REMOTE="$TMP_ROOT/remote"
FAKEBIN=$(fakebin "$TMP_ROOT/fake")
CLAIMS="$TMP_ROOT/claims"
mkdir -p "$PARENT/data" "$PARENT/state" "$REMOTE/state" "$REMOTE/data/reply" "$CLAIMS"
# shellcheck source=bin/remote-job-lib.sh
. "$ROOT/bin/remote-job-lib.sh"
# The recorded worker pid is the serving child, not its restart supervisor, so
# stopping that pid alone leaves the supervisor to respawn - the leak
# tests/remote-job-orphan-reap.test.sh pins. Stop the whole worker tree.
cleanup() {
  local worker_pid=''
  FM_HOME="$PARENT" FM_PROCEVENT_CLAIM_ROOT="$CLAIMS" \
    "$ROOT/bin/process-events.sh" sweep-home >/dev/null 2>&1 || true
  if [ -f "$TMP_ROOT/remote-jobs/worker.pid" ]; then
    worker_pid=$(cat "$TMP_ROOT/remote-jobs/worker.pid")
    remote_job_stop_worker_tree "$worker_pid" || true
  fi
  rm -rf -- "$TMP_ROOT"
}
trap cleanup EXIT

cat > "$PARENT/data/secondmates.md" <<EOF
- ios - iOS delivery (host: remote-mac; root: $ROOT; home: $REMOTE; scope: iOS work; projects: alpha; added 2026-08-02)
EOF
printf '# Detailed remote answer\n\nThe build is green.\n' > "$REMOTE/data/reply/report.md"
printf '# Mentioned but never offered\n' > "$REMOTE/data/reply/prose-only.md"
: > "$REMOTE/state/parent-replies.status"
SOURCE_BEFORE="$TMP_ROOT/source-before"
cp "$REMOTE/state/parent-replies.status" "$SOURCE_BEFORE"

cat > "$FAKEBIN/fake-ssh" <<'SH'
#!/usr/bin/env bash
while [ "$#" -gt 0 ]; do
  case "$1" in
    -o) shift 2 ;;
    --) shift; break ;;
    *) exit 90 ;;
  esac
done
if [ -n "${FM_REMOTE_REPLY_POLL_LOG:-}" ]; then
  printf 'x\n' >> "$FM_REMOTE_REPLY_POLL_LOG"
fi
[ "${FM_REMOTE_REPLY_TRANSPORT_ERROR:-}" != 1 ] || {
  printf 'A\000 connection attempt failed because the connected party did not properly respond\000 Error code: Bash/Service/WSAETIMEDOUT\000\n'
  exit 255
}
[ "${FM_REMOTE_REPLY_FAIL_READ:-}" != 1 ] || exit 255
host=$1
entry=$2
shift 2
[ "$host" = remote-mac ] || exit 91
[ "$entry" = fm-remote-entrypoint.sh ] || exit 92
exec "$FM_FAKE_REMOTE_ENTRYPOINT" "$@"
SH
chmod +x "$FAKEBIN/fake-ssh"

# Pause only the real isolated runner, immediately before launch-floor entry.
# The FIFO is a scheduling barrier, not a replacement for any production code:
# publication and ownership validation still run through their public commands.
HANDOFF="$TMP_ROOT/handoff"
mkdir -p "$HANDOFF"
mkfifo "$HANDOFF/release"
cat > "$HANDOFF/bash-env" <<'SH'
if [ "${1:-}" = _start ]; then
  handoff_barrier() {
    case "$1" in
      'process_events_launch_floor_wait '* )
        local sequence release
        [ -f "$FM_TEST_HANDOFF/sequence" ] || return 0
        IFS= read -r sequence < "$FM_TEST_HANDOFF/sequence"
        if [ "$sequence" != initial ]; then
          [ -f "$FM_HOME/state/procevent-inbox/$id.$sequence.handled" ] || return 0
        fi
        [ ! -e "$FM_TEST_HANDOFF/$sequence.ready" ] || return 0
        exec 3<> "$FM_TEST_HANDOFF/release"
        printf '%s\n%s\n%s\n' "$CLAIM_PID" "$CLAIM_TOKEN" "$CLAIM_REG_IDENTITY" \
          > "$FM_TEST_HANDOFF/$sequence.ready.tmp"
        mv "$FM_TEST_HANDOFF/$sequence.ready.tmp" "$FM_TEST_HANDOFF/$sequence.ready"
        IFS= read -r -t 30 release <&3 || exit 97
        exec 3>&-
        ;;
    esac
    return 0
  }
  set -T
  trap 'handoff_barrier "$BASH_COMMAND"' DEBUG
fi
SH

remote_env() {
  BASH_ENV="$HANDOFF/bash-env" FM_TEST_HANDOFF="$HANDOFF" \
  FM_HOME="$PARENT" \
  FM_ROOT_OVERRIDE="$ROOT" \
  FM_PROCEVENT_CLAIM_ROOT="$CLAIMS" \
  FM_SSH_BIN="$FAKEBIN/fake-ssh" \
  FM_FAKE_REMOTE_ENTRYPOINT="$ROOT/bin/remote-entrypoint.sh" \
  FM_REMOTE_JOB_PLATFORM_OVERRIDE=Linux \
  FM_REMOTE_JOB_STATE_ROOT="$TMP_ROOT/remote-jobs" \
  FM_REMOTE_REPLY_WAIT_SECONDS="${FM_REMOTE_REPLY_WAIT_SECONDS:-10}" \
  "$@"
}

wait_for() {
  local path=$1
  for _ in $(seq 1 100); do
    [ -e "$path" ] && return 0
    sleep 0.05
  done
  return 1
}

reply_owner() {
  remote_env "$ROOT/bin/process-events.sh" list 2>/dev/null \
    | awk -v id="$SID" 'NR > 1 && $1 == id { print $3; exit }'
}

stop_reply_listener() {
  local pid _
  pid=$(sed -n '2p' "$CLAIMS/$SID.claim" 2>/dev/null || true)
  case "$pid" in ''|*[!0-9]*) return 0 ;; esac
  kill -TERM -- -"$pid" 2>/dev/null || kill -TERM "$pid" 2>/dev/null || true
  for _ in $(seq 1 80); do
    kill -0 "$pid" 2>/dev/null || return 0
    sleep 0.05
  done
  return 1
}

reply_diagnostics() {
  local path
  printf 'remote reply timeout diagnostics:\n' >&2
  for path in "$CLAIMS/$SID.claim" "$PARENT/state/procevent/$SID.source" \
    "$PARENT/state/remote-replies/ios.cursor" "$TMP_ROOT/start-one.out"; do
    printf '\n%s:\n' "$path" >&2
    tail -c 4096 "$path" >&2 2>/dev/null || true
  done
  find "$PARENT/state/procevent-inbox" -maxdepth 1 -type f -name "$SID.*" \
    -print 2>/dev/null | head -40 >&2
}

# Block until this generation's capture has been applied. A live listener keeps
# its claim across polls, so start is only launched when nothing owns the source.
await_reply_result() { # <result-path> [existing-owner-only]
  local result=$1 handled=${1%.result}.handled _
  if [ "${2:-}" != existing-owner-only ] && [ "$(reply_owner)" != live ]; then
    remote_env "$ROOT/bin/process-events.sh" start "$SID" >/dev/null 2>&1 &
  fi
  for _ in $(seq 1 800); do
    [ -s "$result" ] && [ -f "$handled" ] && return 0
    sleep 0.05
  done
  reply_diagnostics
  return 1
}

# Rearm only after adoption has completed and before the floor validates the
# adopted inode. The next payload must be collected by this exact owner, without
# the helper's usual fallback start or a reconcile hiding a stranded source.
replace_at_handoff() { # <handled-sequence> <result-file>
  local sequence=$1 before after
  wait_for "$HANDOFF/$sequence.ready" || fail "listener never reached handoff $sequence"
  before=$(sed -n '3p' "$HANDOFF/$sequence.ready")
  remote_env "$ADAPTER" handle ios "$sequence" "$2" >/dev/null 2>&1 \
    || fail "handoff $sequence replay failed"
  # shellcheck disable=SC2016 # Positional parameters expand in the child shell.
  after=$(remote_env bash -c '. "$1/bin/pr-lib.sh"; pr_file_identity "$2"' \
    _ "$ROOT" "$PARENT/state/procevent/$SID.source")
  [ "$before" != "$after" ] || fail "handoff $sequence did not replace the adopted registration"
}

release_handoff() {
  exec 3<> "$HANDOFF/release"
  printf 'release\n' >&3
  exec 3>&-
}

sha256_file() {
  if command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$1" | awk '{print $1}'
  else
    sha256sum "$1" | awk '{print $1}'
  fi
}

# Drive the real delta-reader executable across its unchanged-file wait.
# The recording sleep appends a complete line after the initial empty snapshot,
# so the next snapshot must deliver it without consuming or modifying the log.
delta_cadence_case() {
  local label=$1 override=$2 expected=$3 dir log empty_hash
  dir="$TMP_ROOT/delta-$label"
  mkdir -p "$dir/bin" "$dir/home/state"
  log="$dir/home/state/replies.status"
  : > "$log"
  empty_hash=$(sha256_file "$log")
  cat > "$dir/bin/sleep" <<'SH'
#!/bin/bash
printf '%s\n' "$1" >> "$FM_DELTA_SLEEP_LOG"
printf 'cadence-delivered\n' >> "$FM_DELTA_APPEND_LOG"
exec /bin/sleep "$@"
SH
  chmod +x "$dir/bin/sleep"
  FM_HOME="$dir/home" PATH="$dir/bin:$PATH" FM_REMOTE_DELTA_POLL_SECONDS="$override" \
    FM_DELTA_SLEEP_LOG="$dir/sleeps" FM_DELTA_APPEND_LOG="$log" \
    "$BASH" "$ROOT/bin/remote-delta-read.sh" state/replies.status 0 "$empty_hash" 30 \
    > "$dir/result" || fail "$label delta reader failed"
  [ "$(cat "$dir/sleeps")" = "$expected" ] || fail "$label delta reader did not wait $expected seconds"
  assert_grep 'status=delta' "$dir/result" "$label delta reader did not publish a delta"
  assert_grep 'cadence-delivered' "$dir/result" "$label delta reader lost the appended complete line"
  [ "$(cat "$log")" = cadence-delivered ] || fail "$label delta reader changed its source log"
  pass "$label delta reader waits $expected seconds then delivers a non-destructive complete-line delta"
}
handoff_refusal_case() (
  local kind=$1 adapter=remote-reply start_pid claim before line
  PARENT="$TMP_ROOT/refusal-$kind"
  SID="refusal-$kind"
  HANDOFF="$PARENT/handoff"
  mkdir -p "$PARENT/state" "$HANDOFF"
  trap '
    if [ -f "$HANDOFF/original.claim" ] && [ -e "$CLAIMS/$SID.claim" ]; then
      cp "$HANDOFF/original.claim" "$CLAIMS/$SID.claim"
    fi
    remote_env "$ROOT/bin/process-events.sh" sweep-home >/dev/null 2>&1 || true
  ' EXIT
  mkfifo "$HANDOFF/release"
  cp "$TMP_ROOT/handoff/bash-env" "$HANDOFF/bash-env"
  printf 'initial\n' > "$HANDOFF/sequence"
  [ "$kind" != one-shot ] || adapter=lavish
  remote_env "$ROOT/bin/process-events.sh" register "$adapter" "$SID" -- \
    /bin/sh -c 'echo unexpected >> "$1"; exit 75' sh "$HANDOFF/launched" >/dev/null
  (remote_env "$ROOT/bin/process-events.sh" start "$SID" > "$HANDOFF/runner.out" 2>&1
    printf '%s\n' "$?" > "$HANDOFF/finished") &
  start_pid=$!
  wait_for "$HANDOFF/initial.ready" || fail "$kind never reached its launch boundary"
  claim="$CLAIMS/$SID.claim"
  cp "$claim" "$HANDOFF/original.claim"
  remote_env "$ROOT/bin/process-events.sh" register "$adapter" "$SID" -- \
    /bin/sh -c 'echo unexpected >> "$1"; exit 75' sh "$HANDOFF/launched" >/dev/null
  case "$kind" in
    command)
      remote_env "$ROOT/bin/process-events.sh" register "$adapter" "$SID" -- \
        /bin/sh -c 'echo changed >> "$1"' sh "$HANDOFF/launched" >/dev/null ;;
    adapter)
      remote_env "$ROOT/bin/process-events.sh" register lavish "$SID" -- \
        /bin/sh -c 'echo unexpected >> "$1"; exit 75' sh "$HANDOFF/launched" >/dev/null ;;
    missing) rm -f "$PARENT/state/procevent/$SID.source" ;;
    home|pid|token|terminal)
      case "$kind" in home) line=1 ;; pid) line=2 ;; token) line=3 ;; terminal) line=7 ;; esac
      awk -v line="$line" -v kind="$kind" 'NR == line { print kind == "terminal" ? "terminal" : "999999"; next } { print }' \
        "$claim" > "$HANDOFF/changed.claim"
      chmod 0600 "$HANDOFF/changed.claim"
      mv "$HANDOFF/changed.claim" "$claim"
      ;;
  esac
  before=$(cat "$claim")
  release_handoff
  wait_for "$HANDOFF/finished" || fail "$kind did not leave the superseded generation"
  wait "$start_pid" || fail "$kind start wrapper failed"
  [ "$(cat "$HANDOFF/finished")" = 0 ] || fail "$kind runner did not exit cleanly"
  assert_absent "$HANDOFF/launched" "$kind launched through an invalid adoption"
  assert_absent "$PARENT/state/procevent/$SID.runner" "$kind left a stale runner marker"
  case "$kind" in
    home|pid|token|terminal)
      [ "$(cat "$claim")" = "$before" ] || fail "$kind displaced another claim"
      cp "$HANDOFF/original.claim" "$claim" ;; # Restore only this fixture for cleanup.
  esac
  remote_env "$ROOT/bin/process-events.sh" sweep-home >/dev/null \
    || fail "$kind fixture could not sweep after refusal"
  {
    printf '\nRefusal case: %s\nRunner exit: ' "$kind"; cat "$HANDOFF/finished"
    printf 'Command side effect exists: '; if [ -e "$HANDOFF/launched" ]; then echo yes; else echo no; fi
    printf 'Runner marker exists: '; if [ -e "$PARENT/state/procevent/$SID.runner" ]; then echo yes; else echo no; fi
    printf 'Original protected claim at barrier:\n'; cat "$HANDOFF/original.claim"
    printf 'Claim tested for preservation (before release):\n%s\n' "$before"
  } >> "/home/andrew/.no-mistakes-spudrunner-validation/evidence/01M686RRNB95JSFM1P5TBWQ3YY/round5-terminal-refusal-product-records.log"
  pass "$kind replacement cannot hijack the old listener claim"
)
for refusal in terminal; do
  handoff_refusal_case "$refusal"
done

echo "ALL TESTS PASSED"
