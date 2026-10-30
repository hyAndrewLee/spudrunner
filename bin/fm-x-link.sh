#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/relay-link.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/relay-link.sh" "$@"
fi
# shellcheck source=bin/relay-link.sh
. "$(dirname "${BASH_SOURCE[0]}")/relay-link.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
scan_secondmate_routes() { scan_project_coordinator_routes "$@"; }
