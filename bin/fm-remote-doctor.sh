#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/remote-doctor.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/remote-doctor.sh" "$@"
fi
# shellcheck source=bin/remote-doctor.sh
. "$(dirname "${BASH_SOURCE[0]}")/remote-doctor.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
wrapper_is_firstmate_owned() { wrapper_is_coordinator_owned "$@"; }
