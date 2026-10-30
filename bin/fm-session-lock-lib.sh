#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/session-lock-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/session-lock-lib.sh" "$@"
fi
# shellcheck source=bin/session-lock-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/session-lock-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_harness_path_name() { harness_path_name "$@"; }
fm_ps_comm() { process_table_comm "$@"; }
fm_ps_args() { process_table_args "$@"; }
fm_ps_ppid() { process_table_ppid "$@"; }
fm_harness_process_matches() { harness_process_matches "$@"; }
fm_win_boundary_applies() { windows_process_boundary_applies "$@"; }
fm_win_untag_pid() { windows_process_untag_pid "$@"; }
fm_session_pid_valid() { session_pid_valid "$@"; }
fm_win_normalize_command() { windows_process_normalize_command "$@"; }
fm_win_command() { windows_process_command "$@"; }
fm_win_harness_ancestry_pids() { windows_process_harness_ancestry_pids "$@"; }
fm_harness_ancestry_pids() { harness_ancestry_pids "$@"; }
fm_harness_ancestry_pid() { harness_ancestry_pid "$@"; }
_fm_harness_outermost_pid() { _harness_outermost_pid "$@"; }
fm_harness_pid_listed() { harness_pid_listed "$@"; }
fm_harness_pid_alive() { harness_pid_alive "$@"; }
fm_session_pid_alive() { session_pid_alive "$@"; }
fm_session_pid_identity() { session_pid_identity "$@"; }
fm_session_lock_trusted_session_id() { session_lock_trusted_session_id "$@"; }
fm_session_lock_recorded_session_id() { session_lock_recorded_session_id "$@"; }
fm_session_lock_same_session() { session_lock_same_session "$@"; }
fm_session_lock_anchor_pid() { session_lock_anchor_pid "$@"; }
fm_session_lock_owned_by_self() { session_lock_owned_by_self "$@"; }
fm_session_lock_foreign_owner_live() { session_lock_foreign_owner_live "$@"; }
fm_session_lock_inspect() { session_lock_inspect "$@"; }
