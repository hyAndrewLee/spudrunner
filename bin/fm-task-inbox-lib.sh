#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/task-inbox-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/task-inbox-lib.sh" "$@"
fi
# shellcheck source=bin/task-inbox-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/task-inbox-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_task_inbox_grace_secs() { task_inbox_grace_secs "$@"; }
fm_task_inbox_ring_max() { task_inbox_ring_max "$@"; }
fm_task_inbox_busy_max() { task_inbox_busy_max "$@"; }
fm_task_inbox_record_busy() { task_inbox_record_busy "$@"; }
fm_task_inbox_clear_busy() { task_inbox_clear_busy "$@"; }
fm_task_inbox_dir() { task_inbox_dir "$@"; }
fm_task_inbox_handled_dir() { task_inbox_handled_dir "$@"; }
fm_task_inbox_seq_of() { task_inbox_seq_of "$@"; }
fm_task_inbox_next_seq() { task_inbox_next_seq "$@"; }
fm_task_inbox_lock_acquire() { task_inbox_lock_acquire "$@"; }
_fm_task_inbox_write_record_locked() { _task_inbox_write_record_locked "$@"; }
fm_task_inbox_write() { task_inbox_write "$@"; }
fm_task_inbox_write_idempotent() { task_inbox_write_idempotent "$@"; }
fm_task_inbox_body() { task_inbox_body "$@"; }
fm_task_inbox_doorbell_line() { task_inbox_doorbell_line "$@"; }
fm_task_inbox_ring() { task_inbox_ring "$@"; }
fm_task_inbox_composer_holds() { task_inbox_composer_holds "$@"; }
fm_task_inbox_is_fire_and_forget() { task_inbox_is_fire_and_forget "$@"; }
fm_task_inbox_oldest_unhandled() { task_inbox_oldest_unhandled "$@"; }
fm_task_inbox_mark_retry() { task_inbox_mark_retry "$@"; }
fm_task_inbox_clear_retry() { task_inbox_clear_retry "$@"; }
fm_task_inbox_due_action() { task_inbox_due_action "$@"; }
fm_task_inbox_record_ring() { task_inbox_record_ring "$@"; }
fm_task_inbox_record_escalated() { task_inbox_record_escalated "$@"; }
