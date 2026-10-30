#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/config-inherit-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/config-inherit-lib.sh" "$@"
fi
# shellcheck source=bin/config-inherit-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/config-inherit-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_config_inherit_item_session_scoped() { config_inherit_item_session_scoped "$@"; }
fm_config_inherit_items() { config_inherit_items "$@"; }
fm_config_source_present() { config_source_present "$@"; }
fm_inherit_file_mode() { inherit_file_mode "$@"; }
fm_inherit_file_device() { inherit_file_device "$@"; }
fm_inherit_file_link_count() { inherit_file_link_count "$@"; }
fm_inherit_sha256() { inherit_sha256 "$@"; }
fm_inherit_role_receipt_commit() { inherit_role_receipt_commit "$@"; }
shared_captain_header_valid() { shared_user_header_valid "$@"; }
shared_captain_dir_safe() { shared_user_dir_safe "$@"; }
shared_captain_file_safe_existing() { shared_user_file_safe_existing "$@"; }
restore_shared_captain_readonly() { restore_shared_user_readonly "$@"; }
shared_captain_inherited_receipt_path() { shared_user_inherited_receipt_path "$@"; }
shared_captain_read_inherited_hash() { shared_user_read_inherited_hash "$@"; }
shared_captain_write_inherited_hash() { shared_user_write_inherited_hash "$@"; }
shared_captain_remove_inherited_receipt() { shared_user_remove_inherited_receipt "$@"; }
shared_captain_record_inherited_hash() { shared_user_record_inherited_hash "$@"; }
shared_captain_quarantine_existing_for_hash() { shared_user_quarantine_existing_for_hash "$@"; }
shared_captain_quarantine_name() { shared_user_quarantine_name "$@"; }
quarantine_shared_captain_dest() { quarantine_shared_user_dest "$@"; }
copy_shared_captain_file() { copy_shared_user_file "$@"; }
propagate_shared_captain_preferences() { propagate_shared_user_preferences "$@"; }
propagate_secondmate_inheritance() { propagate_project_coordinator_inheritance "$@"; }
fm_config_reread_is_allowlisted_item() { config_reread_is_allowlisted_item "$@"; }
fm_config_reread_changed_items() { config_reread_changed_items "$@"; }
fm_config_inherit_lock_path() { config_inherit_lock_path "$@"; }
fm_config_reread_retry_dir() { config_reread_retry_dir "$@"; }
fm_config_reread_pending_stages() { config_reread_pending_stages "$@"; }
fm_config_reread_pending_reports() { config_reread_pending_reports "$@"; }
fm_config_reread_has_staged() { config_reread_has_staged "$@"; }
fm_config_reread_retry_queue_is_full() { config_reread_retry_queue_is_full "$@"; }
fm_config_reread_retry_pending() { config_reread_retry_pending "$@"; }
fm_config_reread_new_retry_stage_path() { config_reread_new_retry_stage_path "$@"; }
fm_config_reread_save_retry_report() { config_reread_save_retry_report "$@"; }
fm_config_write_reread_instruction() { config_write_reread_instruction "$@"; }
fm_config_reread_adopt_exact_temp() { config_reread_adopt_exact_temp "$@"; }
fm_config_reread_pending_instructions() { config_reread_pending_instructions "$@"; }
fm_config_reread_has_pending() { config_reread_has_pending "$@"; }
fm_config_reread_cleanup_sent() { config_reread_cleanup_sent "$@"; }
fm_config_reread_mark_pending() { config_reread_mark_pending "$@"; }
fm_config_reread_publish_stage() { config_reread_publish_stage "$@"; }
fm_config_reread_send_failure() { config_reread_send_failure "$@"; }
fm_config_reread_send_pointer() { config_reread_send_pointer "$@"; }
fm_config_reread_discard_pending() { config_reread_discard_pending "$@"; }
fm_config_reread_quarantine_prune() { config_reread_quarantine_prune "$@"; }
fm_config_reread_quarantine_dir() { config_reread_quarantine_dir "$@"; }
fm_config_reread_quarantine_pending() { config_reread_quarantine_pending "$@"; }
fm_config_send_reread_nudge() { config_send_reread_nudge "$@"; }
