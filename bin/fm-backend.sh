#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/runtime-backend.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/runtime-backend.sh" "$@"
fi
# shellcheck source=bin/runtime-backend.sh
. "$(dirname "${BASH_SOURCE[0]}")/runtime-backend.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_backend_list_contains() { runtime_backend_list_contains "$@"; }
fm_backend_is_known() { runtime_backend_is_known "$@"; }
fm_backend_detect() { runtime_backend_detect "$@"; }
fm_backend_detect_cmux_fallback() { runtime_backend_detect_cmux_fallback "$@"; }
fm_backend_detect_cmux_app_pid() { runtime_backend_detect_cmux_app_pid "$@"; }
fm_backend_detect_cmux_app_is_ancestor() { runtime_backend_detect_cmux_app_is_ancestor "$@"; }
fm_backend_explicit_name() { runtime_backend_explicit_name "$@"; }
fm_backend_name() { runtime_backend_name "$@"; }
fm_backend_validate() { runtime_backend_validate "$@"; }
fm_backend_validate_spawn() { runtime_backend_validate_spawn "$@"; }
fm_backend_required_tools() { runtime_backend_required_tools "$@"; }
fm_backend_required_tool_available() { runtime_backend_required_tool_available "$@"; }
fm_meta_get() { task_metadata_get "$@"; }
fm_backend_of_meta() { runtime_backend_of_meta "$@"; }
fm_backend_target_of_meta() { runtime_backend_target_of_meta "$@"; }
fm_backend_meta_exact_value() { runtime_backend_meta_exact_value "$@"; }
fm_backend_endpoint_atom_valid() { runtime_backend_endpoint_atom_valid "$@"; }
fm_backend_orca_worktree_id_valid() { runtime_backend_orca_worktree_id_valid "$@"; }
fm_backend_endpoint_u64_valid() { runtime_backend_endpoint_u64_valid "$@"; }
fm_backend_validate_task_endpoint() { runtime_backend_validate_task_endpoint "$@"; }
fm_backend_rex_id_atom_valid() { runtime_backend_rex_id_atom_valid "$@"; }
fm_backend_meta_for_window() { runtime_backend_meta_for_window "$@"; }
fm_backend_task_id_for_selector() { runtime_backend_task_id_for_selector "$@"; }
fm_backend_meta_for_selector() { runtime_backend_meta_for_selector "$@"; }
fm_backend_of_selector() { runtime_backend_of_selector "$@"; }
fm_backend_expected_label_of_selector() { runtime_backend_expected_label_of_selector "$@"; }
fm_backend_source_readable() { runtime_backend_source_readable "$@"; }
fm_backend_source() { runtime_backend_source "$@"; }
fm_backend_resolve_selector() { runtime_backend_resolve_selector "$@"; }
fm_backend_capture() { runtime_backend_capture "$@"; }
fm_backend_visible_capture_supported() { runtime_backend_visible_capture_supported "$@"; }
fm_backend_visible_capture() { runtime_backend_visible_capture "$@"; }
fm_backend_send_key() { runtime_backend_send_key "$@"; }
fm_backend_send_text_submit() { runtime_backend_send_text_submit "$@"; }
fm_backend_kill() { runtime_backend_kill "$@"; }
fm_backend_remove_worktree() { runtime_backend_remove_worktree "$@"; }
fm_backend_worktree_path() { runtime_backend_worktree_path "$@"; }
fm_backend_busy_state() { runtime_backend_busy_state "$@"; }
fm_backend_composer_state() { runtime_backend_composer_state "$@"; }
fm_backend_target_exists() { runtime_backend_target_exists "$@"; }
fm_backend_agent_state() { runtime_backend_agent_state "$@"; }
fm_backend_agent_alive() { runtime_backend_agent_alive "$@"; }
fm_backend_has_push() { runtime_backend_has_push "$@"; }
fm_backend_events_capable() { runtime_backend_events_capable "$@"; }
fm_backend_wait_transition() { runtime_backend_wait_transition "$@"; }
fm_backend_commit_transition() { runtime_backend_commit_transition "$@"; }
fm_backend_clear_transition() { runtime_backend_clear_transition "$@"; }
fm_backend_event_session() { runtime_backend_event_session "$@"; }
fm_backend_transition_target() { runtime_backend_transition_target "$@"; }
fm_backend_transition_note() { runtime_backend_transition_note "$@"; }
fm_backend_runtime_check() { runtime_backend_runtime_check "$@"; }
fm_backend_validate_harness() { runtime_backend_validate_harness "$@"; }
