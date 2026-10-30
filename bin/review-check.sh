#!/usr/bin/env bash
# Record a review-ready forge=external task: store one validated review=<url>
# and review_head=<worker HEAD> in the task metadata, atomically under the meta
# lock. The external review rail's counterpart of bin/pr-check.sh
# (docs/external-review-forge.md owns the design).
# It arms NO merge poll: firstmate cannot observe the review tool's approval or
# merge, so the review always escalates to the captain whatever the yolo
# setting, and a human relays the outcome. review= is a separate key from pr= so
# teardown's merged-PR lookup and the fm-pr-* scripts never parse it as a forge
# pull request; review_head= lets a later step see that the copy moved after
# the upload.
# Refuses unless the task records forge=external and bin/task-completion-lib.sh accepts
# `done: review <url> uploaded for review` for it: the URL must pass
# bin/external-review-lib.sh's canonical-shape rules and any
# config/external-review-url pattern, and when spawn recorded a personal backup
# remote, the worker copy's HEAD must already be on that remote's backup
# namespace.
# In a secondmate home it publishes the child's review-ready line to the parent
# channel (bin/parent-channel-lib.sh); a main home has no channel and this is
# a silent no-op there.
# Usage: review-check.sh <task-id> <review-url>
set -eu

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FM_ROOT="${FM_ROOT_OVERRIDE:-$(cd "$SCRIPT_DIR/.." && pwd)}"
FM_HOME="${FM_HOME:-${FM_ROOT_OVERRIDE:-$FM_ROOT}}"
STATE="${FM_STATE_OVERRIDE:-$FM_HOME/state}"

# shellcheck source=bin/supervision-events-lib.sh
. "$SCRIPT_DIR/supervision-events-lib.sh"
# shellcheck source=bin/parent-channel-lib.sh
. "$SCRIPT_DIR/parent-channel-lib.sh"
# shellcheck source=bin/task-completion-lib.sh
. "$SCRIPT_DIR/task-completion-lib.sh"

if [ "$#" -ne 2 ]; then
  echo "usage: review-check.sh <task-id> <review-url>" >&2
  exit 2
fi
ID=$1
RAW_URL=$2
if ! pr_task_id_valid "$ID"; then
  echo "error: invalid task id" >&2
  exit 2
fi
if ! external_review_url_parse "$RAW_URL"; then
  echo "error: $RAW_URL is not a canonical https review URL (no whitespace, query, fragment, or forge pull request URL), or does not match config/external-review-url" >&2
  exit 2
fi
URL=$FM_REVIEW_URL

# Task-derived paths are constructed only after the canonical ID validation.
META="$STATE/$ID.meta"
if [ ! -f "$META" ] || [ -L "$META" ] || [ "$(pr_file_link_count "$META")" != 1 ]; then
  echo "error: task metadata is unavailable" >&2
  exit 1
fi
KIND=$(task_completion_meta_value "$META" kind)
if [ "$KIND" = secondmate ]; then
  echo "error: $ID is a secondmate, not a delivery lane - $URL belongs to a task in the mate's own home, which records it there" >&2
  exit 1
fi
if [ "$(task_completion_meta_value "$META" forge)" != external ]; then
  echo "error: $ID does not record forge=external, so it has no external review to record; a pull request is recorded with bin/pr-check.sh" >&2
  exit 1
fi
MODE=$(task_completion_meta_value "$META" mode)
WT=$(task_completion_meta_value "$META" worktree)
PROJECT=$(task_completion_meta_value "$META" project)
DONE_LINE="done: review $URL uploaded for review"
if ! GATE_REASON=$(task_completion_accept_implementation_done "${KIND:-ship}" "$MODE" "$WT" "$PROJECT" "$DONE_LINE" "$STATE" "$ID" "$META"); then
  echo "error: $GATE_REASON" >&2
  exit 1
fi
REVIEW_HEAD=
if [ -n "$WT" ] && [ -d "$WT" ]; then
  REVIEW_HEAD=$(git -C "$WT" rev-parse --verify --quiet HEAD 2>/dev/null) || REVIEW_HEAD=
fi

META_TMP=
META_LOCK=
META_LOCK_HELD=0
review_check_cleanup() {
  [ -z "$META_TMP" ] || rm -f -- "$META_TMP"
  if [ "$META_LOCK_HELD" = 1 ]; then
    lock_release "$META_LOCK" || true
    META_LOCK_HELD=0
  fi
}
trap review_check_cleanup EXIT
trap 'exit 1' HUP INT TERM

META_LOCK=$(task_metadata_lock_path "$META") || exit 1
lock_acquire_wait "$META_LOCK"
META_LOCK_HELD=1
[ -f "$META" ] && [ ! -L "$META" ] && [ "$(pr_file_link_count "$META")" = 1 ] \
  || { echo "error: task metadata is unavailable" >&2; exit 1; }
STATE_DEVICE=$(pr_file_device "$STATE") || exit 1
[ "$(pr_file_device "$META")" = "$STATE_DEVICE" ] || { echo "error: task metadata is unavailable" >&2; exit 1; }
META_TMP=$(mktemp "$STATE/.fm-review-meta.XXXXXX") || exit 1
while IFS= read -r line || [ -n "$line" ]; do
  case "$line" in
    review=*|review_head=*) ;;
    *) printf '%s\n' "$line" >> "$META_TMP" || exit 1 ;;
  esac
done < "$META"
printf 'review=%s\n' "$URL" >> "$META_TMP" || exit 1
[ -z "$REVIEW_HEAD" ] || printf 'review_head=%s\n' "$REVIEW_HEAD" >> "$META_TMP" || exit 1
chmod 0600 "$META_TMP" || exit 1
mv -f -- "$META_TMP" "$META" || exit 1
META_TMP=
lock_release "$META_LOCK"
META_LOCK_HELD=0

READY_LINE="done [key=child-review-$ID]: child $ID review ready: $URL"
[ -z "$MODE" ] || READY_LINE="$READY_LINE mode=$(parent_channel_clean_note "$MODE")"
READY_RC=0
parent_channel_report "$FM_HOME" "$STATE" "$READY_LINE" || READY_RC=$?
case "$READY_RC" in
  0|1) ;;
  *) printf 'actionable: review %s is recorded but its ready line did not reach the parent channel (rc=%s)\n' "$URL" "$READY_RC" >&2 ;;
esac
printf 'recorded: review=%s (no merge watch: a human approves and merges the review; escalate it to the captain)\n' "$URL"
