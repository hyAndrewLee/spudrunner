#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/home-fast-forward-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/home-fast-forward-lib.sh" "$@"
fi
# shellcheck source=bin/home-fast-forward-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/home-fast-forward-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
validate_secondmate_home() { validate_project_coordinator_home "$@"; }
secondmate_update_reconcile_marker_path() { project_coordinator_update_reconcile_marker_path "$@"; }
secondmate_update_reconcile_record() { project_coordinator_update_reconcile_record "$@"; }
secondmate_update_reconcile_clear() { project_coordinator_update_reconcile_clear "$@"; }
live_secondmate_meta_records() { live_project_coordinator_meta_records "$@"; }
process_secondmate() { process_project_coordinator "$@"; }
sweep_live_secondmate_metas() { sweep_live_project_coordinator_metas "$@"; }
