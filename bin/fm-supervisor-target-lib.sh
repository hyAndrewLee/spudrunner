#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/supervisor-target-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/supervisor-target-lib.sh" "$@"
fi
# shellcheck source=bin/supervisor-target-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/supervisor-target-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_supervisor_in_rex() { supervisor_in_rex "$@"; }
