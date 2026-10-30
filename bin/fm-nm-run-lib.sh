#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/validation-run-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/validation-run-lib.sh" "$@"
fi
# shellcheck source=bin/validation-run-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/validation-run-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_nm_bounded() { validation_bounded "$@"; }
fm_nm_home_resolver_home() { validation_home_resolver_home "$@"; }
fm_nm_home_resolver_applies() { validation_home_resolver_applies "$@"; }
fm_nm_run_bounded() { validation_run_bounded "$@"; }
fm_nm_run_checked() { validation_run_checked "$@"; }
fm_nm_run() { validation_run "$@"; }
fm_nm_trim() { validation_trim "$@"; }
fm_nm_strip_quotes() { validation_strip_quotes "$@"; }
fm_nm_state_db() { validation_state_db "$@"; }
fm_nm_field() { validation_field "$@"; }
fm_nm_resolve_commit() { validation_resolve_commit "$@"; }
fm_nm_head_matches_worktree() { validation_head_matches_worktree "$@"; }
fm_nm_run_status_class() { validation_run_status_class "$@"; }
fm_nm_run_is_newer_than() { validation_run_is_newer_than "$@"; }
fm_nm_select_run() { validation_select_run "$@"; }
fm_nm_branch_sync_state() { validation_branch_sync_state "$@"; }
fm_nm_branch_sync_nested() { validation_branch_sync_nested "$@"; }
fm_nm_run_is_active() { validation_run_is_active "$@"; }
fm_nm_run_is_pipeline_owned_active() { validation_run_is_pipeline_owned_active "$@"; }
fm_nm_run_is_parked() { validation_run_is_parked "$@"; }
fm_nm_run_is_executing() { validation_run_is_executing "$@"; }
fm_nm_runs_status_for_worktree() { validation_runs_status_for_worktree "$@"; }
fm_nm_table_column() { validation_table_column "$@"; }
fm_nm_run_progress() { validation_run_progress "$@"; }
