#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/task-events-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/task-events-lib.sh" "$@"
fi
# shellcheck source=bin/task-events-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/task-events-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_utc_iso_to_epoch() { utc_iso_to_epoch "$@"; }
_fm_status_verb_recognized() { _status_verb_recognized "$@"; }
_fm_status_corr_attempt() { _status_corr_attempt "$@"; }
_fm_status_event_scan() { _status_event_scan "$@"; }
_fm_status_line_is_event() { _status_line_is_event "$@"; }
_fm_classify_matches() { _classify_matches "$@"; }
status_is_captain_relevant() { status_is_user_relevant "$@"; }
status_is_captain_held() { status_is_user_held "$@"; }
status_is_paused_or_captain_held() { status_is_paused_or_user_held "$@"; }
_fm_status_declared_wait_scan() { _status_declared_wait_scan "$@"; }
_fm_status_at_epoch() { _status_at_epoch "$@"; }
_fm_status_untimed() { _status_untimed "$@"; }
_fm_status_unstamped() { _status_unstamped "$@"; }
_fm_classify_is_corr_token() { _classify_is_corr_token "$@"; }
_fm_key_before_colon() { _key_before_colon "$@"; }
_fm_key_at_note_head() { _key_at_note_head "$@"; }
_fm_decision_slug_ok() { _decision_slug_ok "$@"; }
_fm_decision_key() { _decision_key "$@"; }
_fm_decision_drop() { _decision_drop "$@"; }
_fm_decision_key_transition_allowed() { _decision_key_transition_allowed "$@"; }
_fm_is_pending_reply_escalation() { _is_pending_reply_escalation "$@"; }
_fm_status_kind() { _status_kind "$@"; }
_fm_decision_fold_line() { _decision_fold_line "$@"; }
_fm_open_set_has() { _open_set_has "$@"; }
_fm_open_set_verb() { _open_set_verb "$@"; }
_fm_open_decisions_cursor_path() { _open_decisions_cursor_path "$@"; }
_fm_open_decisions_file_ident() { _open_decisions_file_ident "$@"; }
_fm_status_file_size() { _status_file_size "$@"; }
_fm_status_file_mtime() { _status_file_mtime "$@"; }
_fm_status_span_scratch() { _status_span_scratch "$@"; }
_fm_status_read_span() { _status_read_span "$@"; }
_fm_activity_publish_keys() { _activity_publish_keys "$@"; }
_fm_status_open_activities_stream() { _status_open_activities_stream "$@"; }
_fm_status_home_appends_merge_locked() { _status_home_appends_merge_locked "$@"; }
_fm_decision_origin_drop() { _decision_origin_drop "$@"; }
_fm_status_open_decision_origins() { _status_open_decision_origins "$@"; }
crew_absorb_class() { worker_absorb_class "$@"; }
crew_is_provably_working() { worker_is_provably_working "$@"; }
crew_is_paused() { worker_is_paused "$@"; }
crew_gate_awaits_human_decision() { worker_gate_awaits_human_decision "$@"; }
crew_run_is_validating() { worker_run_is_validating "$@"; }
crew_worktree_written_since() { worker_worktree_written_since "$@"; }
_fm_secondmate_status_new_lines_routine() { _project_coordinator_status_new_lines_routine "$@"; }
signal_crew_provably_working() { signal_worker_provably_working "$@"; }
