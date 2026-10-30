#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/project-coordinator-liveness-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/project-coordinator-liveness-lib.sh" "$@"
fi
# shellcheck source=bin/project-coordinator-liveness-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/project-coordinator-liveness-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_sm_live_require_locks() { project_coordinator_liveness_live_require_locks "$@"; }
fm_secondmate_liveness_lock() { project_coordinator_liveness_lock "$@"; }
fm_secondmate_liveness_unlock() { project_coordinator_liveness_unlock "$@"; }
fm_sm_live_first_line() { project_coordinator_liveness_live_first_line "$@"; }
fm_secondmate_liveness_ledger_add() { project_coordinator_liveness_ledger_add "$@"; }
fm_secondmate_liveness_recent_attempts() { project_coordinator_liveness_recent_attempts "$@"; }
fm_secondmate_liveness_probe() { project_coordinator_liveness_probe "$@"; }
fm_secondmate_liveness_relaunch() { project_coordinator_liveness_relaunch "$@"; }
