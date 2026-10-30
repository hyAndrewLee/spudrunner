#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/project-capacity-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/project-capacity-lib.sh" "$@"
fi
# shellcheck source=bin/project-capacity-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/project-capacity-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_project_capacity_config_dir() { project_capacity_config_dir "$@"; }
fm_project_capacity_lookup() { project_capacity_lookup "$@"; }
fm_project_capacity_occupants() { project_capacity_occupants "$@"; }
