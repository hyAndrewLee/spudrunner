#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/process-events-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/process-events-lib.sh" "$@"
fi
# shellcheck source=bin/process-events-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/process-events-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_procevent_claim_root() { process_events_claim_root "$@"; }
fm_procevent_registry_dir() { process_events_registry_dir "$@"; }
fm_procevent_inbox_dir() { process_events_inbox_dir "$@"; }
fm_procevent_capture_reservation_dir() { process_events_capture_reservation_dir "$@"; }
fm_procevent_source_id_valid() { process_events_source_id_valid "$@"; }
fm_procevent_adapter_valid() { process_events_adapter_valid "$@"; }
fm_procevent_extension_id_valid() { process_events_extension_id_valid "$@"; }
fm_procevent_extension_version_valid() { process_events_extension_version_valid "$@"; }
fm_procevent_digest_valid() { process_events_digest_valid "$@"; }
fm_procevent_extension_config_ref_valid() { process_events_extension_config_ref_valid "$@"; }
fm_procevent_extension_registration_token_valid() { process_events_extension_registration_token_valid "$@"; }
fm_procevent_any_registered() { process_events_any_registered "$@"; }
fm_procevent_owner_lease_path() { process_events_owner_lease_path "$@"; }
fm_procevent_owner_lease_touch() { process_events_owner_lease_touch "$@"; }
fm_procevent_owner_lease_age() { process_events_owner_lease_age "$@"; }
fm_procevent_owner_lease_seconds() { process_events_owner_lease_seconds "$@"; }
fm_procevent_owner_check_seconds() { process_events_owner_check_seconds "$@"; }
fm_procevent_launch_floor_seconds() { process_events_launch_floor_seconds "$@"; }
fm_procevent_launch_confirm_seconds() { process_events_launch_confirm_seconds "$@"; }
fm_procevent_launch_floor_stamp_path() { process_events_launch_floor_stamp_path "$@"; }
fm_procevent_launch_floor_reset_locked() { process_events_launch_floor_reset_locked "$@"; }
fm_procevent_launch_floor_prune_locked() { process_events_launch_floor_prune_locked "$@"; }
fm_procevent_launch_floor_wait() { process_events_launch_floor_wait "$@"; }
fm_procevent_owner_alive() { process_events_owner_alive "$@"; }
fm_procevent_claim_path() { process_events_claim_path "$@"; }
fm_procevent_source_lock_path() { process_events_source_lock_path "$@"; }
fm_procevent_source_lock_acquire() { process_events_source_lock_acquire "$@"; }
fm_procevent_source_lock_try_acquire() { process_events_source_lock_try_acquire "$@"; }
fm_procevent_source_lock_release() { process_events_source_lock_release "$@"; }
fm_procevent_registration_publish_locked() { process_events_registration_publish_locked "$@"; }
fm_procevent_task_registration_publish_locked() { process_events_task_registration_publish_locked "$@"; }
fm_procevent_extension_registration_publish_locked() { process_events_extension_registration_publish_locked "$@"; }
fm_procevent_extension_registration_load_locked() { process_events_extension_registration_load_locked "$@"; }
fm_procevent_registration_matches_locked() { process_events_registration_matches_locked "$@"; }
fm_procevent_claim_load_locked() { process_events_claim_load_locked "$@"; }
fm_procevent_claim_state_root_field_valid() { process_events_claim_state_root_field_valid "$@"; }
fm_procevent_claim_state_root_identity() { process_events_claim_state_root_identity "$@"; }
fm_procevent_claim_owned_by_state() { process_events_claim_owned_by_state "$@"; }
fm_procevent_claim_recorded_state_root_valid() { process_events_claim_recorded_state_root_valid "$@"; }
fm_procevent_claim_capture_reservation_remove_locked() { process_events_claim_capture_reservation_remove_locked "$@"; }
fm_procevent_claim_generation_gone_locked() { process_events_claim_generation_gone_locked "$@"; }
fm_procevent_claim_undisplaceable_locked() { process_events_claim_undisplaceable_locked "$@"; }
fm_procevent_claim_capture_reservation_reclaim_locked() { process_events_claim_capture_reservation_reclaim_locked "$@"; }
fm_procevent_group_alive() { process_events_group_alive "$@"; }
fm_procevent_pid_state() { process_events_pid_state "$@"; }
fm_procevent_claim_state_locked() { process_events_claim_state_locked "$@"; }
fm_procevent_claim_acquire_locked() { process_events_claim_acquire_locked "$@"; }
fm_procevent_claim_mark_terminal_locked() { process_events_claim_mark_terminal_locked "$@"; }
fm_procevent_claim_adopt_registration_locked() { process_events_claim_adopt_registration_locked "$@"; }
fm_procevent_claim_release_locked() { process_events_claim_release_locked "$@"; }
fm_procevent_claim_release_terminal_self_locked() { process_events_claim_release_terminal_self_locked "$@"; }
fm_procevent_claim_reclaim_locked() { process_events_claim_reclaim_locked "$@"; }
fm_procevent_claim_release_mode_locked() { process_events_claim_release_mode_locked "$@"; }
fm_procevent_path_normalize() { process_events_path_normalize "$@"; }
fm_procevent_directory_owned_by_current_user() { process_events_directory_owned_by_current_user "$@"; }
fm_procevent_state_root_resolve() { process_events_state_root_resolve "$@"; }
fm_procevent_private_directory_valid() { process_events_private_directory_valid "$@"; }
fm_procevent_capture_inbox_prepare() { process_events_capture_inbox_prepare "$@"; }
fm_procevent_extension_staging_prepare() { process_events_extension_staging_prepare "$@"; }
fm_procevent_capture_reservation_prepare() { process_events_capture_reservation_prepare "$@"; }
fm_procevent_capture_reservation_remove_claim() { process_events_capture_reservation_remove_claim "$@"; }
fm_procevent_capture() { process_events_capture "$@"; }
fm_procevent_result_owner_task() { process_events_result_owner_task "$@"; }
fm_procevent_pending() { process_events_pending "$@"; }
fm_procevent_event_line() { process_events_event_line "$@"; }
fm_procevent_handled_marker() { process_events_handled_marker "$@"; }
fm_procevent_is_handled() { process_events_is_handled "$@"; }
fm_procevent_mark_handled() { process_events_mark_handled "$@"; }
fm_procevent_result_source_id() { process_events_result_source_id "$@"; }
fm_procevent_result_sequence() { process_events_result_sequence "$@"; }
fm_procevent_result_adapter() { process_events_result_adapter "$@"; }
fm_procevent_result_extension_load() { process_events_result_extension_load "$@"; }
