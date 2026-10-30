#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/away-supervision-daemon.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/away-supervision-daemon.sh" "$@"
fi
# shellcheck source=bin/away-supervision-daemon.sh
. "$(dirname "${BASH_SOURCE[0]}")/away-supervision-daemon.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_daemon_primary_harness() { daemon_primary_harness "$@"; }
fm_super_main() { away_supervisor_main "$@"; }
