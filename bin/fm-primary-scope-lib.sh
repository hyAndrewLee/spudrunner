#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/coordinator-scope-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/coordinator-scope-lib.sh" "$@"
fi
# shellcheck source=bin/coordinator-scope-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/coordinator-scope-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_root_is_secondmate_home() { root_is_project_coordinator_home "$@"; }
fm_primary_root_matches() { primary_root_matches "$@"; }
fm_primary_scope_matches() { primary_scope_matches "$@"; }
