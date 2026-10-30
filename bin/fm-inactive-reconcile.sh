#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/inactive-reconcile.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/inactive-reconcile.sh" "$@"
fi
# shellcheck source=bin/inactive-reconcile.sh
. "$(dirname "${BASH_SOURCE[0]}")/inactive-reconcile.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
home_secondmate_id() { home_project_coordinator_id "$@"; }
