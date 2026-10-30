#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/backlog-transition-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/backlog-transition-lib.sh" "$@"
fi
# shellcheck source=bin/backlog-transition-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/backlog-transition-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_backlog_bytes_of_string() { backlog_bytes_of_string "$@"; }
fm_backlog_bytes_of_file() { backlog_bytes_of_file "$@"; }
fm_backlog_control_bytes_valid() { backlog_control_bytes_valid "$@"; }
fm_backlog_directory_present() { backlog_directory_present "$@"; }
fm_backlog_data_absolute() { backlog_data_absolute "$@"; }
fm_backlog_file() { backlog_file "$@"; }
fm_backlog_root() { backlog_root "$@"; }
fm_backlog_data_relative() { backlog_data_relative "$@"; }
fm_backlog_authorized_root() { backlog_authorized_root "$@"; }
fm_backlog_config_present() { backlog_config_present "$@"; }
fm_backlog_source_present() { backlog_source_present "$@"; }
fm_backlog_tasks_axi_addressing() { backlog_tasks_axi_addressing "$@"; }
fm_backlog_transition_applies() { backlog_transition_applies "$@"; }
fm_tasks_axi_timeout_expired() { tasks_axi_timeout_expired "$@"; }
fm_tasks_axi() { tasks_axi "$@"; }
fm_backlog_row_show() { backlog_row_show "$@"; }
fm_backlog_row_list() { backlog_row_list "$@"; }
fm_backlog_row_probe() { backlog_row_probe "$@"; }
fm_backlog_mutate() { backlog_mutate "$@"; }
fm_backlog_start() { backlog_start "$@"; }
fm_backlog_pr_note_label() { backlog_pr_note_label "$@"; }
fm_backlog_done() { backlog_done "$@"; }
fm_backlog_row_artifact_supported() { backlog_row_artifact_supported "$@"; }
fm_backlog_retain() { backlog_retain "$@"; }
fm_backlog_canonical_existing() { backlog_canonical_existing "$@"; }
fm_backlog_record_parent_authorized() { backlog_record_parent_authorized "$@"; }
fm_backlog_record_present() { backlog_record_present "$@"; }
fm_backlog_record_remove() { backlog_record_remove "$@"; }
fm_backlog_record_publish() { backlog_record_publish "$@"; }
fm_backlog_meta_spawn_gen() { backlog_meta_spawn_gen "$@"; }
fm_backlog_meta_spawn_gen_optional() { backlog_meta_spawn_gen_optional "$@"; }
fm_backlog_row_dispatchable() { backlog_row_dispatchable "$@"; }
fm_backlog_dispatch_transition() { backlog_dispatch_transition "$@"; }
fm_backlog_dispatch_rollback() { backlog_dispatch_rollback "$@"; }
fm_backlog_close_transition() { backlog_close_transition "$@"; }
fm_backlog_retain_transition() { backlog_retain_transition "$@"; }
fm_backlog_atomic_transition() { backlog_atomic_transition "$@"; }
fm_backlog_close_marker_path() { backlog_close_marker_path "$@"; }
fm_backlog_close_marker_validate() { backlog_close_marker_validate "$@"; }
fm_backlog_close_marker_stage() { backlog_close_marker_stage "$@"; }
fm_backlog_close_marker_write() { backlog_close_marker_write "$@"; }
fm_backlog_close_marker_mark_cleanup_incomplete() { backlog_close_marker_mark_cleanup_incomplete "$@"; }
fm_backlog_close_marker_remove() { backlog_close_marker_remove "$@"; }
fm_backlog_close_marker_clear() { backlog_close_marker_clear "$@"; }
fm_backlog_close_marker_replay() { backlog_close_marker_replay "$@"; }
