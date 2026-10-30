#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/project-coordinator-registry-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/project-coordinator-registry-lib.sh" "$@"
fi
# shellcheck source=bin/project-coordinator-registry-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/project-coordinator-registry-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
secondmate_registry_lock_path() { project_coordinator_registry_lock_path "$@"; }
secondmate_reply_lifecycle_lock_path() { project_coordinator_reply_lifecycle_lock_path "$@"; }
secondmate_registry_parse_line() { project_coordinator_registry_parse_line "$@"; }
secondmate_registry_line_for_id() { project_coordinator_registry_line_for_id "$@"; }
secondmate_registry_field() { project_coordinator_registry_field "$@"; }
secondmate_registry_path_key() { project_coordinator_registry_path_key "$@"; }
secondmate_registry_validate_bindings() { project_coordinator_registry_validate_bindings "$@"; }
