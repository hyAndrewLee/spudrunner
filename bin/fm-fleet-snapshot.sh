#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/active-work-snapshot.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/active-work-snapshot.sh" "$@"
fi
# shellcheck source=bin/active-work-snapshot.sh
. "$(dirname "${BASH_SOURCE[0]}")/active-work-snapshot.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
crew_state_json() { worker_state_json "$@"; }
secondmate_home_summary_json() { project_coordinator_home_summary_json "$@"; }
secondmate_current_json() { project_coordinator_current_json "$@"; }
secondmate_landed_from_current_json() { project_coordinator_landed_from_current_json "$@"; }
scout_report_lines() { investigation_report_lines "$@"; }
