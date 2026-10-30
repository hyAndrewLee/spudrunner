#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/agent-activity-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/agent-activity-lib.sh" "$@"
fi
# shellcheck source=bin/agent-activity-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/agent-activity-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_busy_kimi_verified() { agent_activity_kimi_verified "$@"; }
fm_busy_codex_appserver_observable() { agent_activity_codex_appserver_observable "$@"; }
fm_busy_codex_hooks_verified() { agent_activity_codex_hooks_verified "$@"; }
fm_busy_codex_semantic_source() { agent_activity_codex_semantic_source "$@"; }
fm_busy_record_path() { agent_activity_record_path "$@"; }
fm_busy_gen_path() { agent_activity_gen_path "$@"; }
fm_busy_token_valid() { agent_activity_token_valid "$@"; }
fm_busy_current_gen() { agent_activity_current_gen "$@"; }
fm_busy_sources_for_harness() { agent_activity_sources_for_harness "$@"; }
fm_busy_source_trusted() { agent_activity_source_trusted "$@"; }
fm_busy_record_read() { agent_activity_record_read "$@"; }
fm_busy_muse_binding_path() { agent_activity_muse_binding_path "$@"; }
fm_busy_muse_cache_path() { agent_activity_muse_cache_path "$@"; }
fm_busy_muse_binding_field() { agent_activity_muse_binding_field "$@"; }
fm_busy_muse_matching_logs() { agent_activity_muse_matching_logs "$@"; }
fm_busy_muse_binding_has_prior_log() { agent_activity_muse_binding_has_prior_log "$@"; }
fm_busy_muse_cache_field() { agent_activity_muse_cache_field "$@"; }
fm_busy_muse_main_log_path_valid() { agent_activity_muse_main_log_path_valid "$@"; }
fm_busy_muse_namespace_day() { agent_activity_muse_namespace_day "$@"; }
fm_busy_muse_namespace_signature() { agent_activity_muse_namespace_signature "$@"; }
fm_busy_muse_cached_session_log() { agent_activity_muse_cached_session_log "$@"; }
fm_busy_muse_cache_session_log() { agent_activity_muse_cache_session_log "$@"; }
fm_busy_muse_session_log() { agent_activity_muse_session_log "$@"; }
fm_busy_muse_run_events() { agent_activity_muse_run_events "$@"; }
fm_busy_muse_run_state() { agent_activity_muse_run_state "$@"; }
fm_busy_muse_active_run_id() { agent_activity_muse_active_run_id "$@"; }
fm_busy_muse_run_terminal() { agent_activity_muse_run_terminal "$@"; }
fm_busy_cursor_binding_path() { agent_activity_cursor_binding_path "$@"; }
fm_busy_cursor_binding_field() { agent_activity_cursor_binding_field "$@"; }
fm_busy_cursor_project_dir() { agent_activity_cursor_project_dir "$@"; }
fm_busy_cursor_transcript() { agent_activity_cursor_transcript "$@"; }
fm_busy_cursor_turn_state() { agent_activity_cursor_turn_state "$@"; }
fm_busy_grok_tail_busy() { agent_activity_grok_tail_busy "$@"; }
fm_busy_rovo_tail_busy() { agent_activity_rovo_tail_busy "$@"; }
fm_busy_agy_tail_busy() { agent_activity_agy_tail_busy "$@"; }
fm_busy_claude_launch_prompt_tail() { agent_activity_claude_launch_prompt_tail "$@"; }
fm_busy_pi_launch_prompt_tail() { agent_activity_pi_launch_prompt_tail "$@"; }
fm_busy_gemini_launch_prompt_tail() { agent_activity_gemini_launch_prompt_tail "$@"; }
fm_busy_launch_prompt_parked() { agent_activity_launch_prompt_parked "$@"; }
fm_busy_classify() { agent_activity_classify "$@"; }
fm_busy_classify_live() { agent_activity_classify_live "$@"; }
fm_busy_classify_meta() { agent_activity_classify_meta "$@"; }
fm_busy_is_busy() { agent_activity_is_busy "$@"; }
