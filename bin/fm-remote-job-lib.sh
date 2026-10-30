#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/remote-job-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/remote-job-lib.sh" "$@"
fi
# shellcheck source=bin/remote-job-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/remote-job-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_remote_job_die() { remote_job_die "$@"; }
fm_remote_job_safe_id() { remote_job_safe_id "$@"; }
fm_remote_job_command_preemptible() { remote_job_command_preemptible "$@"; }
fm_remote_job_validate_settings() { remote_job_validate_settings "$@"; }
fm_remote_job_platform() { remote_job_platform "$@"; }
fm_remote_job_path_append() { remote_job_path_append "$@"; }
fm_remote_job_path_append_if_dir() { remote_job_path_append_if_dir "$@"; }
fm_remote_job_path_append_resolved_dir() { remote_job_path_append_resolved_dir "$@"; }
fm_remote_job_append_dirs() { remote_job_append_dirs "$@"; }
fm_remote_job_nvm_default_selector() { remote_job_nvm_default_selector "$@"; }
fm_remote_job_nvm_selected_bin() { remote_job_nvm_selected_bin "$@"; }
fm_remote_job_compose_operator_path() { remote_job_compose_operator_path "$@"; }
fm_remote_job_build_child_path() { remote_job_build_child_path "$@"; }
fm_remote_job_operator_tool() { remote_job_operator_tool "$@"; }
fm_remote_job_manager_tool() { remote_job_manager_tool "$@"; }
fm_remote_job_has_forbidden_text_bytes() { remote_job_has_forbidden_text_bytes "$@"; }
fm_remote_job_normalize_absolute_path() { remote_job_normalize_absolute_path "$@"; }
fm_remote_job_canonical_existing_dir() { remote_job_canonical_existing_dir "$@"; }
fm_remote_job_canonical_home() { remote_job_canonical_home "$@"; }
fm_remote_job_safe_child_dir() { remote_job_safe_child_dir "$@"; }
fm_remote_job_prepare_state() { remote_job_prepare_state "$@"; }
fm_remote_job_job_dir() { remote_job_job_dir "$@"; }
fm_remote_job_regular_bounded() { remote_job_regular_bounded "$@"; }
fm_remote_job_remove_claim_records() { remote_job_remove_claim_records "$@"; }
fm_remote_job_write_state() { remote_job_write_state "$@"; }
fm_remote_job_read_line() { remote_job_read_line "$@"; }
fm_remote_job_read_state() { remote_job_read_state "$@"; }
fm_remote_job_read_number() { remote_job_read_number "$@"; }
fm_remote_job_write_number() { remote_job_write_number "$@"; }
fm_remote_job_read_deadline() { remote_job_read_deadline "$@"; }
fm_remote_job_advance_seq_hint() { remote_job_advance_seq_hint "$@"; }
fm_remote_job_next_seq() { remote_job_next_seq "$@"; }
fm_remote_job_cancelled() { remote_job_cancelled "$@"; }
fm_remote_job_cancel() { remote_job_cancel "$@"; }
fm_remote_job_stage() { remote_job_stage "$@"; }
fm_remote_job_wait() { remote_job_wait "$@"; }
fm_remote_job_reap() { remote_job_reap "$@"; }
fm_remote_job_path_mtime() { remote_job_path_mtime "$@"; }
fm_remote_job_stage_owner_alive() { remote_job_stage_owner_alive "$@"; }
fm_remote_job_reap_stale() { remote_job_reap_stale "$@"; }
fm_remote_job_launchagent_paths() { remote_job_launchagent_paths "$@"; }
fm_remote_job_plist_safe_path() { remote_job_plist_safe_path "$@"; }
fm_remote_job_render_launchagent() { remote_job_render_launchagent "$@"; }
fm_remote_job_launchagent_contract_matches() { remote_job_launchagent_contract_matches "$@"; }
fm_remote_job_gui_available() { remote_job_gui_available "$@"; }
fm_remote_job_launchagent_loaded() { remote_job_launchagent_loaded "$@"; }
fm_remote_job_worker_pid_path() { remote_job_worker_pid_path "$@"; }
fm_remote_job_worker_ready_path() { remote_job_worker_ready_path "$@"; }
fm_remote_job_worker_identity_path() { remote_job_worker_identity_path "$@"; }
fm_remote_job_worker_lock_path() { remote_job_worker_lock_path "$@"; }
fm_remote_job_process_start() { remote_job_process_start "$@"; }
fm_remote_job_start_matches() { remote_job_start_matches "$@"; }
fm_remote_job_process_command() { remote_job_process_command "$@"; }
fm_remote_job_process_pgid() { remote_job_process_pgid "$@"; }
fm_remote_job_root_is_live() { remote_job_root_is_live "$@"; }
fm_remote_job_worker_process_group() { remote_job_worker_process_group "$@"; }
fm_remote_job_stop_worker_tree() { remote_job_stop_worker_tree "$@"; }
fm_remote_job_read_single_line() { remote_job_read_single_line "$@"; }
fm_remote_job_recorded_owner_alive() { remote_job_recorded_owner_alive "$@"; }
fm_remote_job_lock_owner_matches_process() { remote_job_lock_owner_matches_process "$@"; }
fm_remote_job_worker_owned_alive() { remote_job_worker_owned_alive "$@"; }
fm_remote_job_code_identity() { remote_job_code_identity "$@"; }
fm_remote_job_worker_identity_matches() { remote_job_worker_identity_matches "$@"; }
fm_remote_job_worker_alive() { remote_job_worker_alive "$@"; }
fm_remote_job_probe() { remote_job_probe "$@"; }
fm_remote_job_wait_for_probe() { remote_job_wait_for_probe "$@"; }
fm_remote_job_write_launchagent() { remote_job_write_launchagent "$@"; }
fm_remote_job_reload_lock_take() { remote_job_reload_lock_take "$@"; }
fm_remote_job_reload_lock_acquire() { remote_job_reload_lock_acquire "$@"; }
fm_remote_job_reload_lock_release() { remote_job_reload_lock_release "$@"; }
fm_remote_job_launchagent_pid() { remote_job_launchagent_pid "$@"; }
fm_remote_job_launchagent_tracks() { remote_job_launchagent_tracks "$@"; }
fm_remote_job_launchagent_owner_current() { remote_job_launchagent_owner_current "$@"; }
fm_remote_job_reload_launchagent() { remote_job_reload_launchagent "$@"; }
fm_remote_job_stale_heartbeat_owner() { remote_job_stale_heartbeat_owner "$@"; }
fm_remote_job_repair_launchagent() { remote_job_repair_launchagent "$@"; }
fm_remote_job_ensure_launchagent() { remote_job_ensure_launchagent "$@"; }
fm_remote_job_start_linux_worker() { remote_job_start_linux_worker "$@"; }
fm_remote_job_ensure_worker() { remote_job_ensure_worker "$@"; }
