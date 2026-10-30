#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/task-launch.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/task-launch.sh" "$@"
fi
# shellcheck source=bin/task-launch.sh
. "$(dirname "${BASH_SOURCE[0]}")/task-launch.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
spawn_remote_secondmate() { spawn_remote_project_coordinator "$@"; }
secondmate_registry_value() { project_coordinator_registry_value "$@"; }
validate_firstmate_home_for_spawn() { validate_coordinator_home_for_spawn "$@"; }
validate_firstmate_operational_dirs() { validate_coordinator_operational_dirs "$@"; }
