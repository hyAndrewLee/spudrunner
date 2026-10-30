#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/project-coordinator-parent-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/project-coordinator-parent-lib.sh" "$@"
fi
# shellcheck source=bin/project-coordinator-parent-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/project-coordinator-parent-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_secondmate_parent_record_parse() { project_coordinator_parent_record_parse "$@"; }
