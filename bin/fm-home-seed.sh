#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/project-coordinator-provision.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/project-coordinator-provision.sh" "$@"
fi
# shellcheck source=bin/project-coordinator-provision.sh
. "$(dirname "${BASH_SOURCE[0]}")/project-coordinator-provision.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
verify_firstmate_home() { verify_coordinator_home "$@"; }
