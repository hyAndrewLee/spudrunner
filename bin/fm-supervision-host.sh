#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/supervision-host.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/supervision-host.sh" "$@"
fi
# shellcheck source=bin/supervision-host.sh
. "$(dirname "${BASH_SOURCE[0]}")/supervision-host.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
turn_captain_seqs() { turn_user_seqs "$@"; }
