#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/pending-reply-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/pending-reply-lib.sh" "$@"
fi
# shellcheck source=bin/pending-reply-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/pending-reply-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_pending_reply_now() { pending_reply_now "$@"; }
fm_pending_reply_grace_secs() { pending_reply_grace_secs "$@"; }
fm_pending_reply_dir() { pending_reply_dir "$@"; }
fm_pending_reply_path() { pending_reply_path "$@"; }
fm_pending_reply_new_id() { pending_reply_new_id "$@"; }
fm_pending_reply_corr_token() { pending_reply_corr_token "$@"; }
fm_pending_reply_extract_corr() { pending_reply_extract_corr "$@"; }
fm_pending_reply_text_has_corr() { pending_reply_text_has_corr "$@"; }
fm_pending_reply_char_cut() { pending_reply_char_cut "$@"; }
fm_pending_reply_summarize() { pending_reply_summarize "$@"; }
fm_pending_reply_get() { pending_reply_get "$@"; }
fm_pending_reply_sighting_encode() { pending_reply_sighting_encode "$@"; }
fm_pending_reply_sighting_display() { pending_reply_sighting_display "$@"; }
fm_pending_reply_corr_reusable() { pending_reply_corr_reusable "$@"; }
fm_pending_reply_set() { pending_reply_set "$@"; }
fm_pending_reply_embed_corr() { pending_reply_embed_corr "$@"; }
fm_pending_reply_create() { pending_reply_create "$@"; }
fm_pending_reply_mark_delivered() { pending_reply_mark_delivered "$@"; }
fm_pending_reply_delivery_confirmation_path() { pending_reply_delivery_confirmation_path "$@"; }
fm_pending_reply_write_delivery_confirmation() { pending_reply_write_delivery_confirmation "$@"; }
fm_pending_reply_prepare_delivery() { pending_reply_prepare_delivery "$@"; }
fm_pending_reply_confirm_delivery() { pending_reply_confirm_delivery "$@"; }
_fm_pending_reply_confirm_delivery_locked() { _pending_reply_confirm_delivery_locked "$@"; }
fm_pending_reply_mark_delivery_unknown() { pending_reply_mark_delivery_unknown "$@"; }
_fm_pending_reply_reconcile_delivery_locked() { _pending_reply_reconcile_delivery_locked "$@"; }
fm_pending_reply_reconcile_delivery() { pending_reply_reconcile_delivery "$@"; }
fm_pending_reply_delivery_attempt_unresolved() { pending_reply_delivery_attempt_unresolved "$@"; }
fm_pending_reply_reset_known_undelivered() { pending_reply_reset_known_undelivered "$@"; }
_fm_pending_reply_reset_known_undelivered_locked() { _pending_reply_reset_known_undelivered_locked "$@"; }
fm_pending_reply_discard_undelivered() { pending_reply_discard_undelivered "$@"; }
fm_pending_reply_line_resolves() { pending_reply_line_resolves "$@"; }
fm_pending_reply_find_resolve_line() { pending_reply_find_resolve_line "$@"; }
fm_pending_reply_file_signature() { pending_reply_file_signature "$@"; }
fm_pending_reply_status_set_signature() { pending_reply_status_set_signature "$@"; }
fm_pending_reply_resolve_via_of_line() { pending_reply_resolve_via_of_line "$@"; }
fm_pending_reply_try_resolve() { pending_reply_try_resolve "$@"; }
_fm_pending_reply_try_resolve_locked() { _pending_reply_try_resolve_locked "$@"; }
fm_pending_reply_observe_busy() { pending_reply_observe_busy "$@"; }
fm_pending_reply_fallback_idle_eligible() { pending_reply_fallback_idle_eligible "$@"; }
fm_pending_reply_backend_observation() { pending_reply_backend_observation "$@"; }
fm_pending_reply_busy_state_from_observation() { pending_reply_busy_state_from_observation "$@"; }
fm_pending_reply_mark_turn_completed() { pending_reply_mark_turn_completed "$@"; }
fm_pending_reply_remote_channel_watermark_path() { pending_reply_remote_channel_watermark_path "$@"; }
fm_pending_reply_note_remote_channel_caught_up() { pending_reply_note_remote_channel_caught_up "$@"; }
fm_pending_reply_remote_channel_epoch() { pending_reply_remote_channel_epoch "$@"; }
fm_pending_reply_target_is_remote() { pending_reply_target_is_remote "$@"; }
fm_pending_reply_missing_report_is_evidence() { pending_reply_missing_report_is_evidence "$@"; }
fm_pending_reply_recovery_message() { pending_reply_recovery_message "$@"; }
fm_pending_reply_send_recovery() { pending_reply_send_recovery "$@"; }
fm_pending_reply_pid_identity() { pending_reply_pid_identity "$@"; }
fm_pending_reply_sender_alive() { pending_reply_sender_alive "$@"; }
fm_pending_reply_finish_recovery() { pending_reply_finish_recovery "$@"; }
fm_pending_reply_reconcile_recovery() { pending_reply_reconcile_recovery "$@"; }
fm_pending_reply_escalation_key() { pending_reply_escalation_key "$@"; }
fm_pending_reply_resolved_note() { pending_reply_resolved_note "$@"; }
fm_pending_reply_close_note_for_key() { pending_reply_close_note_for_key "$@"; }
fm_pending_reply_escalation_payload() { pending_reply_escalation_payload "$@"; }
fm_pending_reply_escalation_line() { pending_reply_escalation_line "$@"; }
fm_pending_reply_close_escalation() { pending_reply_close_escalation "$@"; }
_fm_pending_reply_close_escalation_locked() { _pending_reply_close_escalation_locked "$@"; }
fm_pending_reply_maybe_escalate() { pending_reply_maybe_escalate "$@"; }
_fm_pending_reply_maybe_escalate_locked() { _pending_reply_maybe_escalate_locked "$@"; }
fm_pending_reply_detect_wrong_home() { pending_reply_detect_wrong_home "$@"; }
fm_pending_reply_restatement_copy_same_basename() { pending_reply_restatement_copy_same_basename "$@"; }
fm_pending_reply_tick_one() { pending_reply_tick_one "$@"; }
_fm_pending_reply_select_needing_work() { _pending_reply_select_needing_work "$@"; }
fm_pending_reply_tick() { pending_reply_tick "$@"; }
fm_pending_reply_task_has_open() { pending_reply_task_has_open "$@"; }
