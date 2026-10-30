#!/usr/bin/env bash
# bin/backends/rex.sh - the Rex session-provider adapter (EXPERIMENTAL).
#
# Rex (https://www.superlogical.com/rex) is a terminal multiplexer whose
# hierarchy is server > session > window (a tab) > block (a pane). Rex is a
# session provider ONLY: the worktree provider stays treehouse. Modeled on
# bin/backends/paseo.sh for CLI mechanics and home-scoped names, with the
# Herdr adapter's recovery-grade control plane. Sourced only through
# bin/runtime-backend.sh's runtime_backend_source in normal operation; the unit tests
# source it directly. docs/rex-backend.md owns the user-facing contract and
# docs/verification/runtime-backends.md#rex the live evidence.
#
# Container shape: ONE window (tab) PER TASK, created focus-safe with
# `window new --focus=false`. When Firstmate itself runs directly inside a Rex
# block (TERM_PROGRAM=rex with REX_SESSION and REX_BLOCK, and the server
# confirms that block lives in that session), every task tab goes into that
# launcher session. Otherwise, and for a secondmate's own home, the tab goes
# into ONE session per home labeled with the home tag
# (bin/runtime-backend-hometag-lib.sh), adopted when exactly one session carries
# that label, created once when none does, and refused when several do. A
# created session's first window becomes the first task's tab, and cleanup
# kills that per-home session once its last window closes. `rex window new`
# rather than `rex run` opens the tab because `rex run` requires a command
# and a task tab is an ordinary login shell that spawn then drives.
#
# Target string shape: "<session-uuid>:<block-uuid>". Rex ids carry their own
# colon (`session:<uuid>`, `block:<uuid>`), so the recorded target strips both
# prefixes and the adapter re-adds them for every CLI call. The prefixed ids
# are also recorded as rex_session_id/rex_window_id/rex_block_id, plus the
# server endpoint as rex_server (bin/task-launch.sh writes them; bin/runtime-backend.sh
# validates them).
#
# ROUTING AUTHORITY: the immutable block id. Rex never reuses an id, so the
# recorded id names exactly one block for its whole life and nothing else
# afterwards; labels are mutable and non-unique and are used only for the
# human (`fm-<id>` window labels), for duplicate refusal, and for list_live
# discovery (the home-scoped block label). Every call passes an explicit
# `-s <session-id>` and `-b <block-id>`: without -s the CLI defaults to the
# caller's own REX_SESSION, which is the captain's session.
#
# Exit codes (verified live, docs/rex-backend.md): 0 ok, 2 invalid command
# line, 3 target not found (or an ambiguous label, which full ids never are),
# 4 server unreachable. Passive reads pass --autostart=false so a probe never
# starts a server; spawn, cleanup, and the control plane's absence recheck let
# the CLI start a missing personal server, because a stopped server ends every
# session on it and a started one then answers "not found" with authority.
#
# Viewport: Rex has no viewport-only read, so the visible viewport is DERIVED
# as the last `size.rows` lines of the styled `format` read, which always ends
# with the full screen grid (blank rows included); an alternate-screen
# program's grid is the screen alone, so the derivation holds on both screens;
# a resize landing between the two reads can skew it by the size difference.
# The same read carries the cursor position (runtime_backend_rex_screen_read).
#
# Requires: rex (the CLI shipped inside the Rex server bundle, which Rex puts
# on REX_BIN_DIR rather than PATH; see runtime_backend_rex_bin) and jq. Bootstrap
# checks them through runtime_backend_required_tools only when rex is the resolved
# backend; this adapter gates them again, plus the server API revision,
# before spawning.

FM_BACKEND_REX_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
FM_ROOT="${FM_ROOT_OVERRIDE:-${FM_ROOT:-$FM_BACKEND_REX_ROOT}}"
FM_HOME="${FM_HOME:-${FM_ROOT_OVERRIDE:-$FM_ROOT}}"

# shellcheck source=bin/runtime-backend-hometag-lib.sh
. "$FM_BACKEND_REX_ROOT/bin/runtime-backend-hometag-lib.sh"
# shellcheck source=bin/agent-input-lib.sh
. "$FM_BACKEND_REX_ROOT/bin/agent-input-lib.sh"
# shellcheck source=bin/agent-process-lib.sh
. "$FM_BACKEND_REX_ROOT/bin/agent-process-lib.sh"
# shellcheck source=bin/agent-transition-lib.sh
. "$FM_BACKEND_REX_ROOT/bin/agent-transition-lib.sh"

# Verified floor: the API revision the live verification ran against.
FM_BACKEND_REX_MIN_API=5
# An unviewed block is 80x24, which wraps harness TUIs far more than any real
# viewer; every task block is resized to this right after it is created. A
# client that later views the block takes ownership and applies its own size.
FM_BACKEND_REX_COLUMNS=${FM_BACKEND_REX_COLUMNS:-200}
FM_BACKEND_REX_ROWS=${FM_BACKEND_REX_ROWS:-50}
FM_BACKEND_REX_BUNDLE_BIN="${FM_BACKEND_REX_BUNDLE_BIN:-$HOME/Library/Application Support/com.superlogical.rex/RexServer/Versions/Current/Rex Server.app/Contents/MacOS/rex}"

# runtime_backend_rex_bin: the running server's own CLI first. Rex exports
# REX_BIN_DIR into every block and prepends it only for --shell=none commands,
# because shell startup files commonly reset PATH; then PATH, then the server
# bundle path.
runtime_backend_rex_bin() {
  local found
  if [ -n "${REX_BIN_DIR:-}" ] && [ -x "$REX_BIN_DIR/rex" ]; then
    printf '%s' "$REX_BIN_DIR/rex"
    return 0
  fi
  if found=$(command -v rex 2>/dev/null) && [ -n "$found" ]; then
    printf '%s' "$found"
    return 0
  fi
  if [ -x "$FM_BACKEND_REX_BUNDLE_BIN" ]; then
    printf '%s' "$FM_BACKEND_REX_BUNDLE_BIN"
    return 0
  fi
  return 1
}

runtime_backend_rex_tool_check() {
  runtime_backend_rex_bin >/dev/null 2>&1 || {
    echo "error: backend=rex selected but the 'rex' CLI was not found at \$REX_BIN_DIR/rex, on PATH, or at $FM_BACKEND_REX_BUNDLE_BIN (https://www.superlogical.com/rex)" >&2
    return 1
  }
  command -v jq >/dev/null 2>&1 || {
    echo "error: backend=rex selected but 'jq' is not installed (required to parse rex's JSON output)" >&2
    return 1
  }
  return 0
}

# runtime_backend_rex_cli: one CLI call that may start a missing personal server.
runtime_backend_rex_cli() {  # <rex-args...>
  local bin
  bin=$(runtime_backend_rex_bin) || return 1
  "$bin" "$@"
}

# runtime_backend_rex_read: one CLI call that never starts a server; an unreachable
# server exits 4 instead.
runtime_backend_rex_read() {  # <rex-args...>
  runtime_backend_rex_cli --autostart=false "$@"
}

# runtime_backend_rex_failure_class: classify a failed call from its exit status
# and stderr. `missing` is a structured not-found; an ambiguous match (also
# exit 3) cannot happen for a full id and reads as an error.
runtime_backend_rex_failure_class() {  # <rc> <stderr> -> missing|unreachable|error
  case "$1" in
    3)
      case "$2" in
        *"not found"*) printf 'missing' ;;
        *) printf 'error' ;;
      esac
      ;;
    4) printf 'unreachable' ;;
    *) printf 'error' ;;
  esac
}

# runtime_backend_rex_version_check: refuse a missing CLI, or a CLI or server below
# the verified API revision. With `start` (the default, spawn path only) the
# server read may start a missing personal server; with `read` it never does.
runtime_backend_rex_version_check() {  # [start|read]
  local raw client_api status server_api call=runtime_backend_rex_cli
  [ "${1:-start}" != read ] || call=runtime_backend_rex_read
  runtime_backend_rex_tool_check || return 1
  raw=$("$call" version 2>/dev/null) || {
    echo "error: 'rex version' failed; is Rex installed correctly?" >&2
    return 1
  }
  client_api=$(printf '%s\n' "$raw" | sed -n 's/^api: revision \([0-9][0-9]*\).*/\1/p' | head -1)
  case "$client_api" in
    ''|*[!0-9]*)
      echo "error: could not parse an API revision from 'rex version'; refusing to use an unverified rex build" >&2
      return 1
      ;;
  esac
  if [ "$client_api" -lt "$FM_BACKEND_REX_MIN_API" ]; then
    echo "error: the rex CLI speaks API revision $client_api, older than the verified minimum $FM_BACKEND_REX_MIN_API; update Rex before using backend=rex" >&2
    return 1
  fi
  status=$("$call" api call server.status 2>/dev/null) || {
    echo "error: the Rex server could not be reached or started ('rex api call server.status' failed); see docs/rex-backend.md 'Setup'" >&2
    return 1
  }
  server_api=$(printf '%s' "$status" | jq -r '.api_revision // empty' 2>/dev/null)
  case "$server_api" in
    ''|*[!0-9]*)
      echo "error: could not read the Rex server's API revision; refusing to use an unverified rex server" >&2
      return 1
      ;;
  esac
  if [ "$server_api" -lt "$FM_BACKEND_REX_MIN_API" ]; then
    echo "error: the Rex server speaks API revision $server_api, older than the verified minimum $FM_BACKEND_REX_MIN_API; update Rex before using backend=rex" >&2
    return 1
  fi
  return 0
}

# runtime_backend_rex_local_server_ensure: Rex's process and cwd views are only
# authoritative on the machine running Firstmate. A Unix socket endpoint is
# local to this machine; other endpoint transports do not prove locality and
# are refused conservatively before spawn leases a worktree or opens a tab.
runtime_backend_rex_local_server_ensure() {
  local endpoint
  endpoint=$(runtime_backend_rex_server_endpoint) || {
    echo "error: could not determine the Rex server endpoint; Rex workers need a Rex server on this machine. For work on another host, use remote second mates (docs/remote-project-coordinators.md)" >&2
    return 1
  }
  case "$endpoint" in
    unix://*) return 0 ;;
  esac
  echo "error: Rex server endpoint '$endpoint' is not proven to be on this machine; Rex workers need a Rex server on this machine. For work on another host, use remote second mates (docs/remote-project-coordinators.md)" >&2
  return 1
}

# runtime_backend_rex_container_ensure: the spawn-time gate (tool, CLI, server).
# The container itself is chosen inside runtime_backend_rex_create_task, under the
# session lock.
runtime_backend_rex_container_ensure() {
  runtime_backend_rex_version_check
}

# runtime_backend_rex_server_endpoint: the server address the CLI resolves from this
# process, as `rex whoami` reports it. Recorded at spawn as rex_server so the
# control plane can refuse an absence claim read from a different server.
runtime_backend_rex_server_endpoint() {
  local out endpoint
  out=$(runtime_backend_rex_cli whoami --json 2>/dev/null) || return 1
  endpoint=$(printf '%s' "$out" | jq -r '.endpoint // empty' 2>/dev/null)
  case "$endpoint" in
    ''|*[[:space:]]*) return 1 ;;
  esac
  printf '%s' "$endpoint"
}

runtime_backend_rex_uuid_valid() {  # <uuid>
  case "$1" in
    ''|*[!0-9a-f-]*) return 1 ;;
  esac
}

# runtime_backend_rex_id_valid: a full prefixed Rex id of the given kind.
runtime_backend_rex_id_valid() {  # <kind> <id>
  case "$2" in
    "$1":*) runtime_backend_rex_uuid_valid "${2#"$1":}" ;;
    *) return 1 ;;
  esac
}

# runtime_backend_rex_parse_target: split "<session-uuid>:<block-uuid>" and restore
# the prefixes. Sets FM_BACKEND_REX_SESSION and FM_BACKEND_REX_BLOCK.
runtime_backend_rex_parse_target() {  # <target>
  local target=$1 left right
  FM_BACKEND_REX_SESSION=
  FM_BACKEND_REX_BLOCK=
  case "$target" in
    *:*:*|'') return 1 ;;
    *:*) ;;
    *) return 1 ;;
  esac
  left=${target%%:*}
  right=${target#*:}
  runtime_backend_rex_uuid_valid "$left" && runtime_backend_rex_uuid_valid "$right" || return 1
  FM_BACKEND_REX_SESSION="session:$left"
  FM_BACKEND_REX_BLOCK="block:$right"
}

# runtime_backend_rex_target: the recorded target string for a session and block id.
runtime_backend_rex_target() {  # <session-id> <block-id>
  printf '%s:%s' "${1#session:}" "${2#block:}"
}

# runtime_backend_rex_home_label: the per-home session label, home-scoped so two
# Firstmate homes sharing one Rex server never adopt each other's session.
runtime_backend_rex_home_label() {
  runtime_backend_hometag
}

# runtime_backend_rex_scoped_name: the home-scoped BLOCK label for an fm-<id> task
# label, used for duplicate refusal and list_live; never for routing.
runtime_backend_rex_scoped_name() {  # <fm-task-label>
  local label=$1 rest
  case "$label" in
    fm-*) rest=${label#fm-} ;;
    *) rest=$label ;;
  esac
  printf 'fm-%s-%s' "$(runtime_backend_rex_home_label)" "$rest"
}

# runtime_backend_rex_session_view: one session's structured view (windows, their
# layers, and blocks with labels).
runtime_backend_rex_session_view() {  # <session-id>
  runtime_backend_rex_read api call -s "$1" session.view 2>/dev/null
}

# runtime_backend_rex_launcher_session: the Rex session this process runs directly
# inside. Returns 0 and prints it when TERM_PROGRAM=rex, REX_SESSION and
# REX_BLOCK are set, and the server confirms that block lives in that
# session; 2 when this process is not directly inside Rex (a tmux or Herdr
# nested in a Rex block rewrites TERM_PROGRAM and is not); 1 when the claim
# cannot be confirmed, which the caller refuses rather than guessing a
# placement.
runtime_backend_rex_launcher_session() {
  local view
  [ "${TERM_PROGRAM:-}" = rex ] && [ -n "${REX_SESSION:-}" ] && [ -n "${REX_BLOCK:-}" ] || return 2
  if ! runtime_backend_rex_id_valid session "$REX_SESSION" || ! runtime_backend_rex_id_valid block "$REX_BLOCK"; then
    echo "error: this process claims Rex session '$REX_SESSION' block '$REX_BLOCK', which are not valid Rex ids; refusing to guess where task tabs belong" >&2
    return 1
  fi
  view=$(runtime_backend_rex_session_view "$REX_SESSION") || {
    echo "error: this process claims Rex session $REX_SESSION, but the Rex server could not show it; refusing to guess where task tabs belong" >&2
    return 1
  }
  printf '%s' "$view" | jq -e --arg b "$REX_BLOCK" \
    '[.windows[]?.layers[]?.blocks[]? | select(.block_id == $b)] | length == 1' >/dev/null 2>&1 || {
    echo "error: this process claims Rex block $REX_BLOCK in session $REX_SESSION, but that session does not hold it; refusing to guess where task tabs belong" >&2
    return 1
  }
  printf '%s' "$REX_SESSION"
}

# runtime_backend_rex_session_lock / _unlock: one home-wide lock (the shared
# stale-owner lock from bin/supervision-events-lib.sh, loaded on demand) that serializes
# choosing or creating the per-home session plus opening a tab against killing
# an emptied per-home session, so cleanup can never kill a session a
# concurrent spawn has just opened a tab in, and two spawns never both create
# the per-home session. Bounded: a spawn that cannot get it refuses, cleanup
# skips the session retirement.
FM_BACKEND_REX_LOCK_ATTEMPTS="${FM_BACKEND_REX_LOCK_ATTEMPTS:-300}"
runtime_backend_rex_session_lock_path() {
  printf '%s/.rex-session.lock' "${STATE:-$FM_HOME/state}"
}
runtime_backend_rex_session_lock() {
  local attempt=0 lock
  if ! declare -F lock_try_acquire >/dev/null 2>&1; then
    # shellcheck source=bin/supervision-events-lib.sh
    . "$FM_BACKEND_REX_ROOT/bin/supervision-events-lib.sh"
  fi
  lock=$(runtime_backend_rex_session_lock_path)
  mkdir -p "${lock%/*}" 2>/dev/null || return 1
  while [ "$attempt" -lt "$FM_BACKEND_REX_LOCK_ATTEMPTS" ]; do
    lock_try_acquire "$lock" && return 0
    sleep 0.1
    attempt=$((attempt + 1))
  done
  return 1
}
runtime_backend_rex_session_unlock() {
  lock_release "$(runtime_backend_rex_session_lock_path)" || true
}

# runtime_backend_rex_home_sessions: ids of the live sessions labeled <label>, one
# per line. Fails when the inventory cannot be read, so a caller about to
# create a session never mistakes an unreadable list for "none".
runtime_backend_rex_home_sessions() {  # <label>
  local list
  list=$(runtime_backend_rex_cli ls --json 2>/dev/null) || return 1
  printf '%s' "$list" | jq -e '.sessions | type == "array"' >/dev/null 2>&1 || return 1
  printf '%s' "$list" | jq -r --arg want "$1" '.sessions[] | select(.label == $want) | .session_id'
}

# runtime_backend_rex_create_task: open the task's tab and print
# "<session-id> <window-id> <block-id>". <relationship> is launcher-home for a
# crewmate or scout of THIS home (the launcher's own Rex session when there is
# one) and other-home for a --secondmate launch, which always uses that other
# home's own per-home session (the caller shadows FM_HOME, FM_ROOT, and STATE).
# The window label
# is the task label the captain reads in the tab bar; the block label is the
# home-scoped name. <mode> is spawn or reclaim and decides what a block
# already carrying that name in the chosen session means
# (runtime_backend_rex_open_tab_locked).
runtime_backend_rex_create_task() {  # <label> <cwd> [launcher-home|other-home] [spawn|reclaim]
  local label=$1 cwd=$2 relationship=${3:-launcher-home} mode=${4:-spawn} home_label sid wid bid
  local sessions count out launcher_rc=2
  home_label=$(runtime_backend_rex_home_label)
  runtime_backend_rex_session_lock || {
    echo "error: could not take the rex session lock; refusing to create '$label'" >&2
    return 1
  }
  sid=
  if [ "$relationship" = launcher-home ]; then
    sid=$(runtime_backend_rex_launcher_session) || launcher_rc=$?
    [ -z "$sid" ] || launcher_rc=0
    if [ "$launcher_rc" -eq 1 ]; then
      runtime_backend_rex_session_unlock
      return 1
    fi
  fi
  wid=
  bid=
  if [ -z "$sid" ]; then
    if ! sessions=$(runtime_backend_rex_home_sessions "$home_label"); then
      runtime_backend_rex_session_unlock
      echo "error: could not read the rex session inventory; refusing to create '$label'" >&2
      return 1
    fi
    count=$(printf '%s' "$sessions" | grep -c . || true)
    case "$count" in
      0)
        if ! out=$(runtime_backend_rex_cli new "$home_label" --window "$label" --cwd "$cwd" --json); then
          runtime_backend_rex_session_unlock
          echo "error: rex could not create the '$home_label' session for '$label'" >&2
          return 1
        fi
        sid=$(printf '%s' "$out" | jq -r '.session_id // empty' 2>/dev/null)
        wid=$(printf '%s' "$out" | jq -r '.initial_windows[0].window_id // empty' 2>/dev/null)
        bid=$(printf '%s' "$out" | jq -r '.initial_windows[0].block_ids[0] // empty' 2>/dev/null)
        if [ "$relationship" = other-home ] && [ -n "${REX_SESSION:-}" ]; then
          runtime_backend_rex_cli session move "$sid" --after "$REX_SESSION" >/dev/null 2>&1 \
            || echo "warning: could not place Rex secondmate session $sid after its launcher session" >&2
        fi
        ;;
      1) sid=$sessions ;;
      *)
        runtime_backend_rex_session_unlock
        echo "error: $count rex sessions are labeled '$home_label'; refusing to guess which one belongs to this home" >&2
        return 1
        ;;
    esac
  fi
  if [ -z "$bid" ]; then
    runtime_backend_rex_open_tab_locked "$sid" "$label" "$cwd" "$mode" || {
      [ "$?" -ne 2 ] || echo "error: rex session $sid disappeared before a tab for '$label' could be opened" >&2
      runtime_backend_rex_session_unlock
      return 1
    }
    wid=$FM_BACKEND_REX_NEW_WINDOW
    bid=$FM_BACKEND_REX_NEW_BLOCK
    if [ "$relationship" = other-home ] && [ "$count" -ne 0 ]; then
      runtime_backend_rex_cli window move -s "$sid" "$wid" --index 1 >/dev/null 2>&1 \
        || echo "warning: could not move the respawned Rex secondmate tab $wid to the first position" >&2
    fi
  fi
  runtime_backend_rex_session_unlock
  runtime_backend_rex_finish_tab "$sid" "$wid" "$bid" "$label"
}

# runtime_backend_rex_create_task_in_session: open a fresh tab for a task in an
# EXACT existing session, the relaunch reclaim path for a task whose recorded
# block is proven gone. Prints the same triple. Returns 2, creating nothing,
# when that session is itself gone (a structured not-found), and 1 on any
# other failure.
runtime_backend_rex_create_task_in_session() {  # <session-id> <label> <cwd>
  local sid=$1 label=$2 cwd=$3 rc=0
  runtime_backend_rex_id_valid session "$sid" || return 1
  runtime_backend_rex_session_lock || {
    echo "error: could not take the rex session lock; refusing to reclaim '$label'" >&2
    return 1
  }
  runtime_backend_rex_open_tab_locked "$sid" "$label" "$cwd" reclaim || rc=$?
  runtime_backend_rex_session_unlock
  [ "$rc" -eq 0 ] || return "$rc"
  runtime_backend_rex_finish_tab "$sid" "$FM_BACKEND_REX_NEW_WINDOW" "$FM_BACKEND_REX_NEW_BLOCK" "$label"
}

# runtime_backend_rex_open_tab_locked: the one tab-opening boundary, run under the
# session lock. Opens the task's tab focus-safe in EXACT session <sid> and sets
# FM_BACKEND_REX_NEW_WINDOW and FM_BACKEND_REX_NEW_BLOCK. Returns 2, creating
# nothing, when that session is gone (a structured not-found), and 1 on any
# other failure. A block already carrying the task's scoped label refuses a
# spawn. On reclaim it is the husk of an earlier reclaim that refused before
# its record was republished, wherever that reclaim placed it: a bare shell
# there is closed first, and anything else refuses. Call it directly, not in a
# command substitution, so the globals reach the caller.
runtime_backend_rex_open_tab_locked() {  # <session-id> <label> <cwd> <spawn|reclaim>
  local sid=$1 label=$2 cwd=$3 mode=$4 name view err rc husk state out
  FM_BACKEND_REX_NEW_WINDOW=
  FM_BACKEND_REX_NEW_BLOCK=
  name=$(runtime_backend_rex_scoped_name "$label")
  err=$(mktemp "${TMPDIR:-/tmp}/fm-rex-err.XXXXXX") || return 1
  view=$(runtime_backend_rex_cli api call -s "$sid" session.view 2>"$err")
  rc=$?
  if [ "$rc" -ne 0 ]; then
    if [ "$(runtime_backend_rex_failure_class "$rc" "$(cat "$err" 2>/dev/null)")" = missing ]; then
      rm -f "$err"
      return 2
    fi
    rm -f "$err"
    echo "error: could not read rex session $sid" >&2
    return 1
  fi
  rm -f "$err"
  printf '%s' "$view" | jq -e '.session_id != null and .label != null' >/dev/null 2>&1 || {
    echo "error: could not read rex session $sid" >&2
    return 1
  }
  while IFS= read -r husk; do
    [ -n "$husk" ] || continue
    if [ "$mode" != reclaim ]; then
      echo "error: rex block '$name' already exists in session $sid" >&2
      return 1
    fi
    state=$(runtime_backend_rex_agent_state "$(runtime_backend_rex_target "$sid" "$husk")")
    case "$state" in
      missing) continue ;;
      dead) ;;
      *)
        echo "error: rex block $husk already carries '$name' and is not a bare shell ($state); refusing to open a second tab for it" >&2
        return 1
        ;;
    esac
    runtime_backend_rex_cli block close -s "$sid" "$husk" >/dev/null 2>&1 || true
    if [ "$(runtime_backend_rex_block_presence "$(runtime_backend_rex_target "$sid" "$husk")")" != missing ]; then
      echo "error: could not close the leftover rex block $husk carrying '$name'" >&2
      return 1
    fi
  done <<EOF
$(printf '%s' "$view" | jq -r --arg n "$name" '(.windows // [])[]?.layers[]?.blocks[]? | select(.label == $n) | .block_id' 2>/dev/null)
EOF
  out=$(runtime_backend_rex_cli window new -s "$sid" "$label" --focus=false --cwd "$cwd" --json) || {
    echo "error: rex could not open a tab for '$label' in session $sid" >&2
    return 1
  }
  FM_BACKEND_REX_NEW_WINDOW=$(printf '%s' "$out" | jq -r '.window_id // empty' 2>/dev/null)
  FM_BACKEND_REX_NEW_BLOCK=$(printf '%s' "$out" | jq -r '.block_ids[0] // empty' 2>/dev/null)
}

# runtime_backend_rex_finish_tab: validate a freshly opened tab's ids, label its
# block with the home-scoped name, size it, and print
# "<session-id> <window-id> <block-id>".
runtime_backend_rex_finish_tab() {  # <session-id> <window-id> <block-id> <label>
  local sid=$1 wid=$2 bid=$3 label=$4 name
  if ! runtime_backend_rex_id_valid session "$sid" || ! runtime_backend_rex_id_valid window "$wid" \
    || ! runtime_backend_rex_id_valid block "$bid"; then
    echo "error: rex did not return session, window, and block ids for '$label'" >&2
    return 1
  fi
  name=$(runtime_backend_rex_scoped_name "$label")
  runtime_backend_rex_cli block rename -s "$sid" "$bid" "$name" >/dev/null 2>&1 \
    || echo "warning: could not label rex block $bid '$name'; routing uses its id, but duplicate detection cannot see it" >&2
  runtime_backend_rex_cli block call -s "$sid" -b "$bid" resize \
    "{\"columns\":$FM_BACKEND_REX_COLUMNS,\"rows\":$FM_BACKEND_REX_ROWS}" >/dev/null 2>&1 \
    || echo "warning: could not resize rex block $bid to ${FM_BACKEND_REX_COLUMNS}x$FM_BACKEND_REX_ROWS; harness screens may wrap" >&2
  printf '%s %s %s' "$sid" "$wid" "$bid"
}

# runtime_backend_rex_block_call: one read-only block method on the target.
runtime_backend_rex_block_call() {  # <target> <method>
  runtime_backend_rex_parse_target "$1" || return 1
  runtime_backend_rex_read block call -s "$FM_BACKEND_REX_SESSION" -b "$FM_BACKEND_REX_BLOCK" "$2" 2>/dev/null
}

# runtime_backend_rex_target_ready: the recorded block exists. The id is the routing
# authority (never reused), so an optional expected label adds nothing a live
# id does not already prove; it is accepted for the shared call shape.
runtime_backend_rex_target_ready() {  # <target> [expected-label]
  runtime_backend_rex_block_call "$1" size >/dev/null
}

# runtime_backend_rex_current_path: the block's foreground process cwd, which
# follows a nested subshell such as `treehouse get` (verified live). Empty on
# any error.
runtime_backend_rex_current_path() {  # <target> [expected-label]
  local out
  out=$(runtime_backend_rex_block_call "$1" process) || return 0
  printf '%s' "$out" | jq -r '.foreground.cwd // empty' 2>/dev/null
}

# runtime_backend_rex_send_literal: literal, UNSUBMITTED input. `--` guards an
# option-shaped payload; Rex refuses empty input, which has nothing to send.
runtime_backend_rex_send_literal() {  # <target> <text> [expected-label]
  runtime_backend_rex_parse_target "$1" || return 1
  [ -n "$2" ] || return 0
  runtime_backend_rex_read send -s "$FM_BACKEND_REX_SESSION" -b "$FM_BACKEND_REX_BLOCK" -- "$2" >/dev/null 2>&1
}

# runtime_backend_rex_key_name: Firstmate's key vocabulary in Rex's binding syntax
# (each verified live). Anything else is refused rather than guessed.
runtime_backend_rex_key_name() {  # <key>
  case "$1" in
    Enter) printf 'enter' ;;
    Escape) printf 'escape' ;;
    Tab) printf 'tab' ;;
    C-c) printf 'ctrl+c' ;;
    C-u) printf 'ctrl+u' ;;
    *) return 1 ;;
  esac
}

runtime_backend_rex_send_key() {  # <target> <key> [expected-label]
  local key
  key=$(runtime_backend_rex_key_name "$2") || {
    echo "error: unsupported rex key '$2'" >&2
    return 1
  }
  runtime_backend_rex_parse_target "$1" || return 1
  runtime_backend_rex_read send-key -s "$FM_BACKEND_REX_SESSION" -b "$FM_BACKEND_REX_BLOCK" "$key" >/dev/null 2>&1
}

# runtime_backend_rex_send_text_line: send one line then submit it.
runtime_backend_rex_send_text_line() {  # <target> <text> [expected-label]
  runtime_backend_rex_send_literal "$1" "$2" || return 1
  runtime_backend_rex_send_key "$1" Enter && return 0
  runtime_backend_rex_send_key "$1" C-c >/dev/null 2>&1 && return 1
  return 2
}

# runtime_backend_rex_screen_read: one styled read of the block's screen and its
# cursor, from the `format` block method (vt with extra_cursor), which returns
# the scrollback plus the full screen grid with rows joined by CRLF and then
# the cursor position as one trailing `ESC[<row>;<col>H` (verified live). An
# empty bottom row leaves the content ending in CRLF with that row implicit,
# so a final newline restores it. Sets FM_BACKEND_REX_SCREEN to the derived
# viewport (the last size.rows rows, SGR kept, carriage returns stripped) and
# FM_BACKEND_REX_CURSOR_Y to the cursor's 0-based viewport row, empty when the
# position is absent or outside the viewport. Call it directly, not in a
# command substitution, so the globals reach the caller.
runtime_backend_rex_screen_read() {  # <target>
  local rows out cup row
  FM_BACKEND_REX_SCREEN=
  FM_BACKEND_REX_CURSOR_Y=
  rows=$(runtime_backend_rex_rows "$1") || return 1
  runtime_backend_rex_parse_target "$1" || return 1
  out=$(runtime_backend_rex_read block call -s "$FM_BACKEND_REX_SESSION" -b "$FM_BACKEND_REX_BLOCK" \
    format '{"format":"vt","extra_cursor":true}' 2>/dev/null | jq -j '.content // empty' 2>/dev/null && printf x) || return 1
  out=${out%x}
  [ -n "$out" ] || return 1
  cup=$(printf '%s' "$out" | LC_ALL=C sed -n '$s/.*\(\[[0-9][0-9]*;[0-9][0-9]*H\)$/\1/p')
  if [ -n "$cup" ]; then
    out=${out%$'\033'"$cup"}
    row=${cup#[}
    row=${row%%;*}
    if [ "$row" -ge 1 ] && [ "$row" -le "$rows" ]; then
      FM_BACKEND_REX_CURSOR_Y=$((row - 1))
    fi
  fi
  FM_BACKEND_REX_SCREEN=$(printf '%s\n' "$out" | tr -d '\r' | tail -n "$rows" && printf x)
  FM_BACKEND_REX_SCREEN=${FM_BACKEND_REX_SCREEN%x}
}

# runtime_backend_rex_capture: bounded plain-text capture. Rex returns scrollback
# plus the screen, so trailing blank rows are trimmed by --trim and the tail is
# taken locally.
runtime_backend_rex_capture() {  # <target> <lines> [expected-label]
  local lines=${2:-200} out
  case "$lines" in ''|*[!0-9]*) lines=200 ;; esac
  runtime_backend_rex_parse_target "$1" || return 1
  out=$(runtime_backend_rex_read capture -s "$FM_BACKEND_REX_SESSION" -b "$FM_BACKEND_REX_BLOCK" \
    --trim 2>/dev/null) || return 1
  printf '%s\n' "$out" | tr -d '\r' | tail -n "$lines"
}

# runtime_backend_rex_rows: the block's current row count.
runtime_backend_rex_rows() {  # <target>
  local out rows
  out=$(runtime_backend_rex_block_call "$1" size) || return 1
  rows=$(printf '%s' "$out" | jq -r '.rows // empty' 2>/dev/null)
  case "$rows" in ''|0|*[!0-9]*) return 1 ;; esac
  printf '%s' "$rows"
}

# runtime_backend_rex_visible_capture_vt: the derived viewport (see the header) with
# SGR styling preserved, so the composer classifier can strip ghost text.
runtime_backend_rex_visible_capture_vt() {  # <target>
  runtime_backend_rex_screen_read "$1" || return 1
  printf '%s' "$FM_BACKEND_REX_SCREEN"
}

# runtime_backend_rex_visible_capture: the same derived viewport as plain text.
runtime_backend_rex_visible_capture() {  # <target> [expected-label]
  local screen
  screen=$(runtime_backend_rex_visible_capture_vt "$1" && printf x) || return 1
  printf '%s' "${screen%x}" | agent_input_strip_ansi
}

# runtime_backend_rex_process_chain: read the block's process view into
# FM_BACKEND_REX_CHAIN, one "<role>\t<pid>\t<name>\t<path>\t<argv0>" line per
# process, foreground first then each ancestor; empty for a block with no
# foreground process. FM_BACKEND_REX_LAST_EXIT is `exited` once the terminal
# child has exited. Fails, with FM_BACKEND_REX_READ_CLASS set to
# missing|unreachable|error, when the block cannot be read. Call it directly,
# not in a command substitution, so the globals reach the caller.
runtime_backend_rex_process_chain() {  # <target>
  local out err rc
  FM_BACKEND_REX_CHAIN=
  FM_BACKEND_REX_READ_CLASS=
  FM_BACKEND_REX_LAST_EXIT=
  runtime_backend_rex_parse_target "$1" || { FM_BACKEND_REX_READ_CLASS=error; return 1; }
  err=$(mktemp "${TMPDIR:-/tmp}/fm-rex-err.XXXXXX") || { FM_BACKEND_REX_READ_CLASS=error; return 1; }
  out=$(runtime_backend_rex_read block call -s "$FM_BACKEND_REX_SESSION" -b "$FM_BACKEND_REX_BLOCK" process 2>"$err")
  rc=$?
  if [ "$rc" -ne 0 ]; then
    FM_BACKEND_REX_READ_CLASS=$(runtime_backend_rex_failure_class "$rc" "$(cat "$err" 2>/dev/null)")
    rm -f "$err"
    return 1
  fi
  rm -f "$err"
  printf '%s' "$out" | jq -e 'type == "object"' >/dev/null 2>&1 || { FM_BACKEND_REX_READ_CLASS=error; return 1; }
  FM_BACKEND_REX_LAST_EXIT=$(printf '%s' "$out" | jq -r 'if .last_exit == null then "" else "exited" end' 2>/dev/null)
  FM_BACKEND_REX_CHAIN=$(printf '%s' "$out" | jq -r '
    def row($role): [$role, ((.pid // "") | tostring), (.name // ""), (.path // ""), (.argv0 // "")] | join("\t");
    (if .foreground then (.foreground | row("foreground")) else empty end),
    (.ancestors[]? | row("ancestor"))' 2>/dev/null) || { FM_BACKEND_REX_READ_CLASS=error; return 1; }
}

# runtime_backend_rex_process_kind: agent|shell|other for one process, from its
# name, install path, argv[0], and live pid through the shared classifier.
runtime_backend_rex_process_kind() {  # <pid> <name> <path> <argv0>
  local pid=$1 name=$2 path=$3 argv0=$4 kind
  kind=$(agent_process_classify "$name" "$argv0" '' "$pid")
  [ "$kind" != agent ] || { printf 'agent'; return 0; }
  if [ -n "$path" ] && [ "$(agent_process_classify_name "$path" "$argv0")" = agent ]; then
    printf 'agent'
    return 0
  fi
  printf '%s' "$kind"
}

# runtime_backend_rex_descendant_harness_pids: the pids of <pid>'s live
# descendants that the shared classifier names a verified harness, one per
# line, from the local process table; fails when the table cannot be read.
# Rex reports a block's foreground process and its ancestors only, so a
# harness a login shell launched through a wrapper in the shell's own process
# group (a fish function, a bash shim) sits below a shell foreground.
runtime_backend_rex_descendant_harness_pids() {  # <pid>
  local root=$1 comms args pid name line
  comms=$(LC_ALL=C ps -axo pid=,ppid=,comm= 2>/dev/null) && [ -n "$comms" ] || return 1
  args=$(LC_ALL=C ps -axo pid=,args= 2>/dev/null) || return 1
  while IFS=$'\t' read -r pid name line; do
    [ -n "$pid" ] || continue
    [ "$(agent_process_classify "$name" "${line%%[[:space:]]*}" "$line" "$pid")" != agent ] || printf '%s\n' "$pid"
  done <<EOF
$({ printf '%s\n--\n' "$comms"; printf '%s\n' "$args"; } | awk -v root="$root" '
  $0 == "--" { phase = 2; next }
  {
    line = $0
    gsub(/\t/, " ", line)
    if (phase != 2) {
      n++; pid[n] = $1; ppid[n] = $2
      sub(/^[ ]*[0-9]+[ ]+[0-9]+[ ]+/, "", line)
      comm[n] = line
    } else {
      p = $1
      sub(/^[ ]*[0-9]+[ ]*/, "", line)
      argv[p] = line
    }
  }
  END {
    want[root] = 1
    changed = 1
    while (changed) {
      changed = 0
      for (i = 1; i <= n; i++) {
        if ((ppid[i] in want) && !(pid[i] in want)) { want[pid[i]] = 1; changed = 1 }
      }
    }
    for (i = 1; i <= n; i++) {
      if ((pid[i] in want) && pid[i] != root) printf "%s\t%s\t%s\n", pid[i], comm[i], argv[pid[i]]
    }
  }')
EOF
}

# runtime_backend_rex_shell_harness_pids: after runtime_backend_rex_process_chain, the
# harness pids running below a shell foreground (see
# runtime_backend_rex_descendant_harness_pids); nothing for any other foreground.
# Fails when the foreground is a shell and the process table cannot be read.
runtime_backend_rex_shell_harness_pids() {
  local role pid name path argv0
  while IFS=$'\t' read -r role pid name path argv0; do
    [ "$role" = foreground ] || continue
    case "$pid" in ''|*[!0-9]*) return 0 ;; esac
    [ "$(runtime_backend_rex_process_kind "$pid" "$name" "$path" "$argv0")" = shell ] || return 0
    runtime_backend_rex_descendant_harness_pids "$pid"
    return
  done <<EOF
$FM_BACKEND_REX_CHAIN
EOF
}

# runtime_backend_rex_agent_state: the recovery-grade agent/endpoint state (the
# vocabulary is owned by bin/runtime-backend.sh's runtime_backend_agent_state), from
# Rex's structured process view. A verified harness anywhere in the
# foreground process or its ancestors is `alive` (a harness running a pager
# or an interactive shell escape is still there), and so is one running below
# a shell foreground; a shell foreground with no harness above or below it is
# `dead`; anything else is `ambiguous`. A structured not-found is `missing`;
# an unreachable server or a bad read is `unreadable`. Read-only: it never
# starts a server.
runtime_backend_rex_agent_state() {  # <target>
  local role pid name path argv0 kind fg_kind='' seen=0 below
  if ! runtime_backend_rex_process_chain "$1"; then
    case "$FM_BACKEND_REX_READ_CLASS" in
      missing) printf 'missing' ;;
      *) printf 'unreadable' ;;
    esac
    return 0
  fi
  while IFS=$'\t' read -r role pid name path argv0; do
    [ -n "$role" ] || continue
    seen=1
    kind=$(runtime_backend_rex_process_kind "$pid" "$name" "$path" "$argv0")
    if [ "$kind" = agent ]; then
      printf 'alive'
      return 0
    fi
    [ "$role" != foreground ] || fg_kind=$kind
  done <<EOF
$FM_BACKEND_REX_CHAIN
EOF
  if [ "$seen" -eq 0 ]; then
    # No foreground process: the terminal child exited (a kept-open block) or
    # the block is still starting.
    if [ "$FM_BACKEND_REX_LAST_EXIT" = exited ]; then
      printf 'dead'
    else
      printf 'ambiguous'
    fi
    return 0
  fi
  [ "$fg_kind" = shell ] || { printf 'ambiguous'; return 0; }
  below=$(runtime_backend_rex_shell_harness_pids) || { printf 'ambiguous'; return 0; }
  if [ -n "$below" ]; then
    printf 'alive'
  else
    printf 'dead'
  fi
}

# runtime_backend_rex_live_pids: the block's foreground pid, its ancestors' pids,
# and any harness pids below a shell foreground, as a JSON array, from the
# process view; fails when the block cannot be read.
runtime_backend_rex_live_pids() {  # <target>
  local below
  runtime_backend_rex_process_chain "$1" || return 1
  below=$(runtime_backend_rex_shell_harness_pids) || below=
  { printf '%s\n' "$FM_BACKEND_REX_CHAIN" | cut -f2; printf '%s\n' "$below"; } \
    | jq -Rsc 'split("\n") | map(select(test("^[0-9]+$")) | tonumber)' 2>/dev/null
}

# runtime_backend_rex_owner_trusted: THE trust rule for an OSC 7501 record. A record
# counts only while its reporting process is the block's foreground process,
# one of its ancestors, or a harness running below a shell foreground: without
# shell integration a `working` record outlives the command that reported it
# (verified live), so no self-report outranks the process view.
runtime_backend_rex_owner_trusted() {  # <target> <owner-pid>
  local live
  case "$2" in ''|*[!0-9]*) return 1 ;; esac
  live=$(runtime_backend_rex_live_pids "$1") || return 1
  jq -en --argjson live "$live" --argjson pid "$2" '$live | index($pid) != null' >/dev/null 2>&1
}

# runtime_backend_rex_trusted_record: the block's governing trusted OSC 7501 record
# as "<state>\t<kind>\t<app>\t<msg>" (working, then blocked, error, done,
# idle), or nothing when no record passes runtime_backend_rex_owner_trusted.
runtime_backend_rex_trusted_record() {  # <target>
  local status live
  status=$(runtime_backend_rex_block_call "$1" program_status) || return 0
  live=$(runtime_backend_rex_live_pids "$1") || return 0
  jq -rn --argjson s "$status" --argjson live "$live" --arg mark "$FM_BACKEND_REX_MARK_APP" '
    def clean: tostring | gsub("[\t\r\n]"; " ");
    [$s.records[]? | select((.app // "") != $mark
      and (.owner.pid as $p | $p != null and ($live | index($p)) != null))] as $trusted
    | first(("working", "blocked", "error", "done", "idle") as $want
        | $trusted[] | select(.state == $want)
        | [.state, (.kind // ""), (.app // ""), (.msg // "")] | map(clean) | join("\t"))
    // empty' 2>/dev/null || true
}

# runtime_backend_rex_native_state: the state of the block's trusted OSC 7501 record
# (working|blocked|idle|done|error), or empty when none can be trusted.
runtime_backend_rex_native_state() {  # <target>
  runtime_backend_rex_trusted_record "$1" | cut -f1
}

# runtime_backend_rex_busy_state: busy|idle|unknown from the trusted native state.
# Only harnesses that report OSC 7501 ever read busy; callers treat a native
# busy as positive activity evidence only (bin/agent-activity-lib.sh).
runtime_backend_rex_busy_state() {  # <target>
  case "$(runtime_backend_rex_native_state "$1")" in
    working) printf 'busy' ;;
    idle|done|blocked|error) printf 'idle' ;;
    *) printf 'unknown' ;;
  esac
}

# runtime_backend_rex_rendered_busy_state: busy|idle|unknown from the rendered busy
# footer, the same delivery-only signal the herdr adapter reads, for harnesses
# that do not report OSC 7501.
runtime_backend_rex_rendered_busy_state() {  # <target> [harness]
  local cap visible
  cap=$(runtime_backend_rex_capture "$1" 40) || { printf 'unknown'; return 0; }
  visible=$(printf '%s' "$cap" | grep -v '^[[:space:]]*$' | tail -12)
  [ -n "$visible" ] || { printf 'unknown'; return 0; }
  if printf '%s' "$visible" | agent_activity_lines_match "${2:-}"; then
    printf 'busy'
  else
    printf 'idle'
  fi
}

# runtime_backend_rex_composer_identity: the identity probe behind the separated
# (pi, polytoken) composer shape and Command Code's placeholder ceiling.
# Prints "<owner>\t<status>" when the foreground process is one of those
# owners; status is the trusted native state, else the owner's own rendered
# busy footer.
runtime_backend_rex_composer_identity() {  # <target>
  local role pid name path argv0 owner='' base native rendered
  runtime_backend_rex_process_chain "$1" || return 1
  while IFS=$'\t' read -r role pid name path argv0; do
    [ "$role" = foreground ] || continue
    for base in "${name##*/}" "${argv0##*/}" "${path##*/}"; do
      case "${base#-}" in
        pi|pi-signed|pi-launcher|Pi) owner=pi ;;
        polytoken) owner=polytoken ;;
        command-code) owner=commandcode ;;
      esac
      [ -z "$owner" ] || break
    done
  done <<EOF
$FM_BACKEND_REX_CHAIN
EOF
  [ -n "$owner" ] || return 1
  native=$(runtime_backend_rex_native_state "$1")
  case "$native" in
    working|blocked|idle|done) printf '%s\t%s' "$owner" "$native"; return 0 ;;
  esac
  rendered=$(runtime_backend_rex_rendered_busy_state "$1" "$owner")
  case "$rendered" in
    busy) printf '%s\tworking' "$owner" ;;
    idle) printf '%s\tidle' "$owner" ;;
    *) return 1 ;;
  esac
}

# runtime_backend_rex_composer_caps: capability facts for the shared classifier
# (bin/agent-input-lib.sh); the cursor is declared only when the read
# reported one.
runtime_backend_rex_composer_caps() {  # <rows> [cursor]
  printf 'styled=1\ncursor=%s\nidentity=1\nrows=%s\n' "${2:-0}" "${1:-0}"
}

# runtime_backend_rex_composer_classify: one shared-classifier verdict for the
# screen and cursor row (empty for a cursorless read), fetching identity
# lazily, only when the verdict depends on it.
runtime_backend_rex_composer_classify() {  # <target> <screen> <cursor-row>
  local target=$1 screen=$2 cy=$3 caps verdict identity
  caps=$(runtime_backend_rex_composer_caps "$(printf '%s\n' "$screen" | wc -l | tr -d '[:space:]')" "${cy:+1}")
  verdict=$(agent_input_classify_screen "$caps" "$screen" "$cy")
  if [ "$verdict" = need-identity ]; then
    if ! identity=$(runtime_backend_rex_composer_identity "$target" 2>/dev/null) || [ -z "$identity" ]; then
      identity='probe-absent'
    fi
    verdict=$(agent_input_classify_screen "$caps" "$screen" "$cy" "$identity")
    [ "$verdict" != need-identity ] || verdict=unknown
  fi
  printf '%s' "$verdict"
}

# runtime_backend_rex_composer_state: thin adapter - the styled derived viewport
# and the cursor row in, the shared verdict out. The whole viewport is read,
# never a bounded tail, so an overlay drawn below the composer cannot push it
# out of view. The cursor-anchored read is tmux's: the shape holding the
# cursor is the composer, so furniture a harness draws below its composer
# (OpenCode 1.19's status line) cannot decide the verdict. Where that read is
# `unknown` - a harness that parks its cursor outside its composer, such as
# Cursor Agent or Command Code, or no cursor at all - the cursorless read
# that picks the bottom-most shape decides, exactly as Rex classified every
# screen before it read the cursor.
runtime_backend_rex_composer_state() {  # <target> [expected-label] -> empty|pending|pending-unproven|unknown
  local target=$1 verdict=unknown
  runtime_backend_rex_screen_read "$target" 2>/dev/null || { printf 'unknown'; return 0; }
  if [ -n "$FM_BACKEND_REX_CURSOR_Y" ]; then
    verdict=$(runtime_backend_rex_composer_classify "$target" "$FM_BACKEND_REX_SCREEN" "$FM_BACKEND_REX_CURSOR_Y")
  fi
  if [ "$verdict" = unknown ]; then
    verdict=$(runtime_backend_rex_composer_classify "$target" "$FM_BACKEND_REX_SCREEN" '')
  fi
  printf '%s' "$verdict"
}

# runtime_backend_rex_delivery_busy: busy|idle|unknown for the queued-Enter
# conversion: a trusted native working state, else the rendered busy footer.
runtime_backend_rex_delivery_busy() {  # <target>
  [ "$(runtime_backend_rex_busy_state "$1")" != busy ] || { printf 'busy'; return 0; }
  runtime_backend_rex_rendered_busy_state "$1"
}

# runtime_backend_rex_send_text_submit: type <text> once, then drive the shared
# verify-and-retry-Enter loop (agent_input_submit_retry_core) against the
# shared composer verdict, and convert a still-pending composer whose agent is
# visibly busy into a queued delivery (agent_input_queued_enter_verdict).
# Echoes empty|pending|pending-unproven|unknown|send-failed.
runtime_backend_rex_send_text_submit() {  # <target> <text> <retries> <enter-sleep> <settle> [expected-label]
  local target=$1 text=$2 retries=$3 sleep_s=$4 settle=$5 expected_label=${6:-} verdict
  runtime_backend_rex_parse_target "$target" || { printf 'unknown'; return 0; }
  runtime_backend_rex_send_literal "$target" "$text" "$expected_label" || {
    printf 'send-failed'
    return 0
  }
  sleep "$settle"
  verdict=$(agent_input_submit_retry_core runtime_backend_rex_send_key runtime_backend_rex_composer_state \
    "$target" "$retries" "$sleep_s" "$expected_label")
  if [ "$verdict" = pending ]; then
    verdict=$(agent_input_queued_enter_verdict "$verdict" "$(runtime_backend_rex_delivery_busy "$target")")
  fi
  printf '%s' "$verdict"
}

# runtime_backend_rex_block_presence: present|missing|unknown for the target block,
# read through a call that may start a missing personal server, so a stopped
# server resolves to the authoritative not-found its fresh start returns.
runtime_backend_rex_block_presence() {  # <target>
  local err rc
  runtime_backend_rex_parse_target "$1" || { printf 'unknown'; return 0; }
  err=$(mktemp "${TMPDIR:-/tmp}/fm-rex-err.XXXXXX") || { printf 'unknown'; return 0; }
  runtime_backend_rex_cli block call -s "$FM_BACKEND_REX_SESSION" -b "$FM_BACKEND_REX_BLOCK" size >/dev/null 2>"$err"
  rc=$?
  if [ "$rc" -eq 0 ]; then
    rm -f "$err"
    printf 'present'
    return 0
  fi
  if [ "$(runtime_backend_rex_failure_class "$rc" "$(cat "$err" 2>/dev/null)")" = missing ]; then
    printf 'missing'
  else
    printf 'unknown'
  fi
  rm -f "$err"
}

# runtime_backend_rex_kill: close the task's block (its tab closes with its last
# block) and PROVE it gone: an exact not-found after the close is the proof,
# so a close that failed or left the block alive returns nonzero and the
# caller keeps its records. An already-gone block is success. A per-home
# session left with no windows is then retired.
runtime_backend_rex_kill() {  # <target> [unused] [expected-label]
  local sid
  runtime_backend_rex_parse_target "$1" || {
    echo "error: malformed rex target '$1'; cannot close it" >&2
    return 1
  }
  sid=$FM_BACKEND_REX_SESSION
  runtime_backend_rex_cli block close -s "$sid" "$FM_BACKEND_REX_BLOCK" >/dev/null 2>&1 || true
  case "$(runtime_backend_rex_block_presence "$1")" in
    missing) ;;
    present)
      echo "error: rex block $FM_BACKEND_REX_BLOCK is still open after its close" >&2
      return 1
      ;;
    *)
      echo "error: could not confirm rex block $FM_BACKEND_REX_BLOCK closed" >&2
      return 1
      ;;
  esac
  runtime_backend_rex_retire_session "$sid"
  return 0
}

# runtime_backend_rex_retire_session: kill a per-home session once it holds no
# window. Only a session labeled with THIS home's label is ever killed, never
# the launcher's own session, and an unreadable view skips the cleanup. Runs
# under the session lock so a concurrent spawn cannot open a tab between the
# empty check and the kill.
runtime_backend_rex_retire_session() {  # <session-id>
  local sid=$1 view
  [ -n "$sid" ] || return 0
  [ "$sid" != "${REX_SESSION:-}" ] || return 0
  runtime_backend_rex_session_lock || return 0
  if view=$(runtime_backend_rex_session_view "$sid") \
    && printf '%s' "$view" | jq -e --arg want "$(runtime_backend_rex_home_label)" \
      '.label == $want and ((.windows // []) | type == "array" and length == 0)' >/dev/null 2>&1; then
    runtime_backend_rex_cli kill "$sid" >/dev/null 2>&1 || true
  fi
  runtime_backend_rex_session_unlock
  return 0
}

# runtime_backend_rex_endpoint_absence_recheck: the control plane's absence proof
# (bin/agent-control-lib.sh's agent_control_endpoint_absence_verdict owns the
# argument). Rex ids are never reused and a session never survives its
# server, so a structured not-found from the server the task was created on
# proves the block is gone. The proof therefore requires the endpoint this
# process reaches (starting a stopped personal server) to equal the recorded
# one. Prints missing|dead|alive|unproven.
runtime_backend_rex_endpoint_absence_recheck() {  # <target> <recorded-server>
  local target=$1 recorded=${2:-} now state
  [ -n "$recorded" ] || { printf 'unproven'; return 0; }
  now=$(runtime_backend_rex_server_endpoint) || { printf 'unproven'; return 0; }
  [ "$now" = "$recorded" ] || { printf 'unproven'; return 0; }
  case "$(runtime_backend_rex_block_presence "$target")" in
    missing) printf 'missing' ;;
    present)
      state=$(runtime_backend_rex_agent_state "$target")
      case "$state" in
        dead|alive) printf '%s' "$state" ;;
        *) printf 'unproven' ;;
      esac
      ;;
    *) printf 'unproven' ;;
  esac
}

# runtime_backend_rex_list_live: recovery/orphan discovery. One
# "<session-uuid>:<block-uuid>\tfm-<id>" line per live block whose label is
# scoped to this home, read from the live inventory. Read-only: an
# unreachable server lists nothing.
runtime_backend_rex_list_live() {
  local list sid prefix view
  prefix="fm-$(runtime_backend_rex_home_label)-"
  list=$(runtime_backend_rex_read ls --json 2>/dev/null) || return 0
  while IFS= read -r sid; do
    [ -n "$sid" ] || continue
    view=$(runtime_backend_rex_session_view "$sid") || continue
    printf '%s' "$view" | jq -r --arg prefix "$prefix" '
      .session_id as $s
      | .windows[]?.layers[]?.blocks[]?
      | select((.label // "") | startswith($prefix))
      | "\($s | sub("^session:"; "")):\(.block_id | sub("^block:"; ""))\tfm-\(.label | ltrimstr($prefix))"' 2>/dev/null
  done <<EOF
$(printf '%s' "$list" | jq -r '.sessions[]?.session_id' 2>/dev/null)
EOF
}

# --- native event push: program_status_changed reader ------------------------
#
# The Rex half of the immediate blocked-state escalation, mirroring the herdr
# subscriber. runtime_backend_rex_wait_transition replaces the watcher's blind sleep
# with a bounded `rex do` Lua reader (bin/backends/rex-eventwait.lua) that
# streams program_status_changed, child_exited, and block_closed for the
# watched blocks. Every edge is normalized through transition_record and
# routed through the shared policy and dedupe (bin/agent-transition-lib.sh); a
# status edge counts only when runtime_backend_rex_owner_trusted accepts its owner.
# Polling stays the permanent fallback: an incapable Rex, a reader that cannot
# start, or one that ends early all return 2 and the caller sleeps the budget.

# Per-pane escalation dedupe marker prefix, under the state dir
# (bin/agent-transition-lib.sh owns the dedupe contract).
FM_BACKEND_REX_ESCALATED_PREFIX=".rex-escalated-"
# Longest OSC 7501 message carried into a wake reason; the rest is cut.
FM_BACKEND_REX_DETAIL_MAX=${FM_BACKEND_REX_DETAIL_MAX:-160}

# runtime_backend_rex_events_capable: the push path's gate - the CLI and jq present
# and both the CLI and the running server at the verified API revision, read
# without starting a server. FM_BACKEND_REX_EVENTS_FORCE overrides the verdict
# for tests (1 = capable, 0 = incapable).
runtime_backend_rex_events_capable() {  # <session>
  case "${FM_BACKEND_REX_EVENTS_FORCE:-}" in
    1) return 0 ;;
    0) return 1 ;;
  esac
  runtime_backend_rex_version_check read >/dev/null 2>&1
}

# runtime_backend_rex_event_reader: run the bounded Lua reader for <session-id> and
# the watched <block-id...> until <timeout> seconds pass. Exits 0 at the
# deadline; nonzero when the reader cannot start. FM_BACKEND_REX_EVENT_READER
# substitutes a whitespace-split command taking the same arguments, so tests
# can replay canned stream lines.
runtime_backend_rex_event_reader() {  # <session-id> <timeout> <block-id...>
  local sid=$1 timeout=$2 word blocks
  shift 2
  if [ -n "${FM_BACKEND_REX_EVENT_READER:-}" ]; then
    local cmd=()
    for word in $FM_BACKEND_REX_EVENT_READER; do
      cmd+=("$word")
    done
    "${cmd[@]}" "$sid" "$timeout" "$@"
    return
  fi
  blocks=$(printf '%s\n' "$@" | jq -Rsc '{blocks: split("\n") | map(select(length > 0))}') || return 1
  runtime_backend_rex_read 'do' -s "$sid" --for "${timeout}s" \
    "$FM_BACKEND_REX_ROOT/bin/backends/rex-eventwait.lua" --args "$blocks"
}

# runtime_backend_rex_edge_detail: the human-readable cause of a blocked edge, from
# Rex's blocked kind (permission|question|auth) and the program's message.
runtime_backend_rex_edge_detail() {  # <kind> <msg>
  local kind=$1 msg=$2
  if [ "${#msg}" -gt "$FM_BACKEND_REX_DETAIL_MAX" ]; then
    msg="${msg:0:$FM_BACKEND_REX_DETAIL_MAX}..."
  fi
  if [ -n "$kind" ] && [ -n "$msg" ]; then
    printf '%s: %s' "$kind" "$msg"
  else
    printf '%s' "$kind$msg"
  fi
}

runtime_backend_rex_commit_transition() {  # <state_dir> <session> <record>
  transition_commit "$1" "$FM_BACKEND_REX_ESCALATED_PREFIX" "$2" "$3"
}

runtime_backend_rex_clear_transition() {  # <state_dir> <window>
  transition_clear "$1" "$FM_BACKEND_REX_ESCALATED_PREFIX" "$2"
}

# runtime_backend_rex_wait_transition: the bounded event wait. <session> is the
# recorded session uuid and each <window> a recorded
# "<session-uuid>:<block-uuid>" target. Blocks up to <timeout_secs> for a fresh
# trusted `blocked` edge on a watched block, then prints its normalized record
# (the block uuid as pane_id, Rex's app as agent, kind and message as detail)
# and returns 0. Returns 1 on a clean full-budget wait, and also at once when a
# watched block's program exits or the block closes, so the watcher's poll
# cycle reconciles that task now. Returns 2 when the event path is unusable or
# the reader ended early (the caller sleeps the budget itself).
runtime_backend_rex_wait_transition() {  # <session> <timeout_secs> <state_dir> <window...>
  local session=$1 timeout=$2 state=$3
  shift 3
  local w sid='' blocks=() windows=()
  case "$timeout" in ''|*[!0-9]*|0) return 2 ;; esac
  for w in "$@"; do
    runtime_backend_rex_parse_target "$w" || continue
    [ "${FM_BACKEND_REX_SESSION#session:}" = "$session" ] || continue
    sid=$FM_BACKEND_REX_SESSION
    blocks+=("$FM_BACKEND_REX_BLOCK")
    windows+=("$w")
  done
  [ "${#blocks[@]}" -gt 0 ] || return 2
  if [ "${FM_BACKEND_EVENTS_CAPABILITY_CONFIRMED:-0}" != 1 ]; then
    runtime_backend_rex_events_capable "$session" || return 2
  fi

  local fifo_dir fifo reader_pid line block to kind app owner msg record hit apply_rc
  local rc=1 reader_rc=0 started=$SECONDS level
  fifo_dir=$(mktemp -d "${TMPDIR:-/tmp}/fm-rex-eventwait.XXXXXX") || return 2
  fifo="$fifo_dir/events"
  if ! mkfifo "$fifo" 2>/dev/null; then
    rm -rf "$fifo_dir" 2>/dev/null || true
    return 2
  fi
  runtime_backend_rex_event_reader "$sid" "$timeout" "${blocks[@]}" > "$fifo" 2>/dev/null &
  reader_pid=$!
  if ! exec 9< "$fifo"; then
    kill "$reader_pid" 2>/dev/null || true
    wait "$reader_pid" 2>/dev/null || true
    rm -rf "$fifo_dir" 2>/dev/null || true
    return 2
  fi
  if ! IFS= read -r -t "$((timeout + 15))" -u 9 line || [ "$line" != "@subscribed" ]; then
    rc=2
  fi

  # Level reconcile once the reader is listening: a block already blocked
  # since the last wait is returned now, once, and a working one clears its
  # marker, while newer edges queue in the live stream.
  if [ "$rc" -eq 1 ]; then
    for w in "${windows[@]}"; do
      level=$(runtime_backend_rex_trusted_record "$w")
      [ -n "$level" ] || continue
      to=$(printf '%s' "$level" | cut -f1)
      kind=$(printf '%s' "$level" | cut -f2)
      app=$(printf '%s' "$level" | cut -f3)
      msg=$(printf '%s' "$level" | cut -f4)
      record=$(transition_record "${w#*:}" "" "" "$to" "$app" "$(runtime_backend_rex_edge_detail "$kind" "$msg")")
      if hit=$(transition_apply "$state" "$FM_BACKEND_REX_ESCALATED_PREFIX" "$session" "$record"); then
        printf '%s' "$hit"
        rc=0
        break
      fi
    done
  fi

  # Drain stream edges until a fresh blocked edge, an endpoint-gone edge, or
  # the deadline. Fields are split with cut, not `IFS=$'\t' read`, which would
  # collapse an empty middle field.
  while [ "$rc" -eq 1 ] && IFS= read -r line <&9; do
    [ -n "$line" ] || continue
    block=$(printf '%s' "$line" | cut -f1)
    to=$(printf '%s' "$line" | cut -f2)
    kind=$(printf '%s' "$line" | cut -f3)
    app=$(printf '%s' "$line" | cut -f4)
    owner=$(printf '%s' "$line" | cut -f5)
    msg=$(printf '%s' "$line" | cut -f6)
    runtime_backend_rex_id_valid block "$block" || continue
    # Firstmate's own records (bin/rex-marks.sh, the wedge alarm) are never
    # the worker's state; rex-eventwait.lua drops them too.
    [ "$app" != "$FM_BACKEND_REX_MARK_APP" ] || continue
    case "$(transition_policy "$to")" in
      actionable|absorb)
        runtime_backend_rex_owner_trusted "$session:${block#block:}" "$owner" || continue
        ;;
    esac
    record=$(transition_record "${block#block:}" "" "" "$to" "$app" "$(runtime_backend_rex_edge_detail "$kind" "$msg")")
    apply_rc=0
    hit=$(transition_apply "$state" "$FM_BACKEND_REX_ESCALATED_PREFIX" "$session" "$record") || apply_rc=$?
    case "$apply_rc" in
      0) printf '%s' "$hit"; rc=0 ;;
      3) rc=3 ;;
    esac
  done
  [ "$rc" -eq 1 ] || kill "$reader_pid" 2>/dev/null || true
  wait "$reader_pid" 2>/dev/null || reader_rc=$?
  exec 9<&-
  rm -rf "$fifo_dir" 2>/dev/null || true
  case "$rc" in
    0) return 0 ;;
    2) return 2 ;;
    3) return 1 ;;
  esac
  # No edge: a reader that ran the whole budget is a clean wait; one that
  # failed or ended early (its session destroyed) is not, so the caller
  # sleeps rather than spinning.
  [ "$reader_rc" -eq 0 ] && [ $((SECONDS - started)) -ge $((timeout - 1)) ] && return 1
  return 2
}

# --- program status: attention records -----------------------------------------
# Rex shows program status (OSC 7501) as tab spinners and blocked symbols,
# session-picker indicators, the Activity sidebar, the Dock badge, sounds, and
# notifications, and streams every change as `program_status_changed`. A
# record is `ESC ] 7501 ; state=<s>[:kind=<k>][:app=<a>][:id=<i>][:msg=<b64>]
# ESC \`; a record with an id is independent of the pane's root record, so
# Firstmate's own records (app=firstmate, id=fm and its validation-progress
# child id=fm/validate on a worker pane, id=fm-wedge on the supervisor pane)
# never overwrite a harness's report and a harness never overwrites them.
# Clearing id=fm also removes id=fm/validate. A worker record's title is the
# task's tab label, which Rex shows as the record's label. Rex drops a `working` or `blocked` record when its
# owning process exits or at the next OSC 133 prompt mark, while `done` and
# `error` persist, so bin/rex-marks.sh re-reads and repairs rather than
# writing once. Since Rex preview.16 the app's sounds and notifications follow
# a pane's main (root) program status only, so a child record badges the tab
# and the Activity sidebar but does not notify; a new mark therefore carries
# an OSC 777 desktop notification in the same write, which Rex streams as
# `desktop_notification` and the app shows as a notification that returns to
# the pane. No API sets a record: it is written to the pane's tty as one small
# write, so it cannot split inside the program's own output.
FM_BACKEND_REX_MARK_APP=firstmate
FM_BACKEND_REX_MARK_ID=fm
FM_BACKEND_REX_PROGRESS_ID=fm/validate
FM_BACKEND_REX_ALERT_ID=fm-wedge
FM_BACKEND_REX_MSG_MAX=120
FM_BACKEND_REX_TITLE_MAX=64
FM_BACKEND_REX_DEV_DIR=${FM_BACKEND_REX_DEV_DIR:-/dev}

# runtime_backend_rex_tty: the device path of <target>'s terminal, from its
# foreground process (else its child); fails when it cannot be named.
runtime_backend_rex_tty() { # <target>
  local out pid tty
  out=$(runtime_backend_rex_block_call "$1" process) || return 1
  pid=$(printf '%s' "$out" | jq -r '.foreground.pid // .child.pid // empty' 2>/dev/null)
  case "$pid" in '' | *[!0-9]*) return 1 ;; esac
  tty=$(ps -o tty= -p "$pid" 2>/dev/null | tr -d '[:space:]')
  case "$tty" in '' | '?' | '??') return 1 ;; esac
  printf '%s/%s' "$FM_BACKEND_REX_DEV_DIR" "${tty#/dev/}"
}

# runtime_backend_rex_status_text: <text> as one record line: control characters
# become spaces and the result is clipped to <max> characters.
runtime_backend_rex_status_text() { # <text> <max>
  local text
  text=$(printf '%s' "$1" | tr '\000-\037\177' ' ')
  printf '%s' "${text:0:$2}"
}

# runtime_backend_rex_status_sequence: one OSC 7501 report. <msg> and <title> are
# clipped to FM_BACKEND_REX_MSG_MAX and FM_BACKEND_REX_TITLE_MAX characters
# and base64-encoded on one line; <progress> (0-100) is kept only for
# working and blocked.
runtime_backend_rex_status_sequence() { # <state> <id> [kind] [msg] [title] [progress]
  local fields="state=$1" msg=${4:-} title=${5:-} progress=${6:-}
  [ -z "${3:-}" ] || fields="$fields:kind=$3"
  fields="$fields:app=$FM_BACKEND_REX_MARK_APP:id=$2"
  if [ "$1" != clear ]; then
    case "$1:$progress" in
      working:[0-9] | working:[1-9][0-9] | working:100 | blocked:[0-9] | blocked:[1-9][0-9] | blocked:100)
        fields="$fields:progress=$progress"
        ;;
    esac
    if [ -n "$title" ]; then
      title=$(runtime_backend_rex_status_text "$title" "$FM_BACKEND_REX_TITLE_MAX")
      fields="$fields:title=$(printf '%s' "$title" | base64 | tr -d '\n')"
    fi
    if [ -n "$msg" ]; then
      msg=$(runtime_backend_rex_status_text "$msg" "$FM_BACKEND_REX_MSG_MAX")
      fields="$fields:msg=$(printf '%s' "$msg" | base64 | tr -d '\n')"
    fi
  fi
  printf '\033]7501;%s\033\134' "$fields"
}

# runtime_backend_rex_notify_sequence: one OSC 777 desktop notification. The
# sequence's own separators and control characters are removed from both
# fields.
runtime_backend_rex_notify_sequence() { # <title> <body>
  local title body
  title=$(printf '%s' "$1" | tr ';\a\033\r\n' ',    ')
  body=$(printf '%s' "$2" | tr ';\a\033\r\n' ',    ')
  body=${body:0:$FM_BACKEND_REX_MSG_MAX}
  printf '\033]777;notify;%s;%s\a' "$title" "$body"
}

# runtime_backend_rex_tty_write: write <bytes> to <target>'s tty in one write. The
# device is opened for append, which a tty ignores, so a regular file standing
# in for it keeps every write.
runtime_backend_rex_tty_write() { # <target> <bytes>
  local dev
  dev=$(runtime_backend_rex_tty "$1") || return 1
  [ -w "$dev" ] || return 1
  { printf '%s' "$2" >>"$dev"; } 2>/dev/null
}

# runtime_backend_rex_mark: set (or with state `clear`, remove) Firstmate's own
# attention record on a task pane. <state> is blocked|error|done|clear; <kind>
# is permission|question|auth for blocked; <title> is the record's label (the
# task's tab label). Refuses a block that does not carry the task's scoped
# label, so a mark can never land on another pane. With <notify-title>, the
# same write raises a desktop notification whose body is <msg>.
runtime_backend_rex_mark() { # <target> <state> [kind] [msg] [expected-label] [notify-title] [title]
  local bytes
  runtime_backend_rex_target_ready "$1" "${5:-}" || return 1
  bytes=$(runtime_backend_rex_status_sequence "$2" "$FM_BACKEND_REX_MARK_ID" "${3:-}" "${4:-}" "${7:-}")
  [ -z "${6:-}" ] || bytes="$bytes$(runtime_backend_rex_notify_sequence "$6" "${4:-}")"
  runtime_backend_rex_tty_write "$1" "$bytes"
}

# runtime_backend_rex_progress: set Firstmate's validation-progress record
# (id=fm/validate, state working) on a task pane, or with <percent> `clear`
# remove it. An empty <percent> is indeterminate. Rex shows the record's
# progress and message in the tab and pane hover cards. Same label check as
# runtime_backend_rex_mark.
runtime_backend_rex_progress() { # <target> <percent|clear> [msg] [expected-label] [title]
  local bytes
  runtime_backend_rex_target_ready "$1" "${4:-}" || return 1
  if [ "$2" = clear ]; then
    bytes=$(runtime_backend_rex_status_sequence clear "$FM_BACKEND_REX_PROGRESS_ID")
  else
    bytes=$(runtime_backend_rex_status_sequence working "$FM_BACKEND_REX_PROGRESS_ID" "" "${3:-}" "${5:-}" "$2")
  fi
  runtime_backend_rex_tty_write "$1" "$bytes"
}

# --- state tint -----------------------------------------------------------------
# Rex's set_theme is not applied while a client owns the pane, and the app owns
# every pane it shows, so the only tint that works is in-band: OSC 11 sets the
# pane's default background and OSC 111 restores the theme's. The tint only
# changes cells the program leaves at the default background, a harness that
# chose its theme from the background at startup keeps that theme, and it
# persists until reset. Firstmate never sends an OSC 11 query: the terminal
# answers it on the pane's input, which the harness would read as typed text.

# runtime_backend_rex_tint_sequence: OSC 11 for <#rrggbb>, or OSC 111 for `reset`.
runtime_backend_rex_tint_sequence() { # <#rrggbb|reset>
  case "$1" in
    reset) printf '\033]111\033\134' ;;
    \#[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]) printf '\033]11;%s\033\134' "$1" ;;
    *) return 1 ;;
  esac
}

# runtime_backend_rex_tint: tint a task pane's background, or with `reset` restore
# it. Same label check as runtime_backend_rex_mark.
runtime_backend_rex_tint() { # <target> <#rrggbb|reset> [expected-label]
  local bytes
  bytes=$(runtime_backend_rex_tint_sequence "$2") || return 1
  runtime_backend_rex_target_ready "$1" "${3:-}" || return 1
  runtime_backend_rex_tty_write "$1" "$bytes"
}

# runtime_backend_rex_status_records: the pane's program-status records as one JSON
# array; fails when the pane cannot be read.
runtime_backend_rex_status_records() { # <target>
  local out
  out=$(runtime_backend_rex_block_call "$1" program_status) || return 1
  printf '%s' "$out" | jq -ce '.records | if type == "array" then . else error("no records") end' 2>/dev/null
}

# runtime_backend_rex_mark_read: "<state>\t<kind>\t<msg>\t<title>\t<progress>" of
# Firstmate's own record <id> (default the attention mark, id=fm) on the pane
# (empty fields when it has none, which reads as `clear`); fails when the pane
# cannot be read.
runtime_backend_rex_mark_read() { # <target> [id]
  local records
  records=$(runtime_backend_rex_status_records "$1") || return 1
  printf '%s' "$records" | jq -r --arg app "$FM_BACKEND_REX_MARK_APP" --arg id "${2:-$FM_BACKEND_REX_MARK_ID}" '
    ([.[] | select(.id == $id and .app == $app)] | first) as $r
    | if $r == null then "clear\t\t\t\t"
      else "\($r.state // "")\t\($r.kind // "")\t\($r.msg // "")\t\($r.title // "")\t\($r.progress // "")" end' 2>/dev/null
}

# runtime_backend_rex_alert: the away daemon's wedge alarm on Firstmate's own pane:
# a blocked record (id=fm-wedge, kind permission) plus an OSC 777 desktop
# notification, in one write. runtime_backend_rex_alert_clear removes the record.
runtime_backend_rex_alert() { # <target> <title> <body>
  runtime_backend_rex_parse_target "$1" || return 1
  runtime_backend_rex_tty_write "$1" \
    "$(runtime_backend_rex_status_sequence blocked "$FM_BACKEND_REX_ALERT_ID" permission "$3")$(runtime_backend_rex_notify_sequence "$2" "$3")"
}
runtime_backend_rex_alert_clear() { # <target>
  runtime_backend_rex_parse_target "$1" || return 1
  runtime_backend_rex_tty_write "$1" "$(runtime_backend_rex_status_sequence clear "$FM_BACKEND_REX_ALERT_ID")"
}
