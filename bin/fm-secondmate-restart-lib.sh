#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/project-coordinator-restart-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/project-coordinator-restart-lib.sh" "$@"
fi
# shellcheck source=bin/project-coordinator-restart-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/project-coordinator-restart-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_secondmate_restart_capable() { project_coordinator_restart_capable "$@"; }
