#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/remote-readiness-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/remote-readiness-lib.sh" "$@"
fi
# shellcheck source=bin/remote-readiness-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/remote-readiness-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_remote_readiness_ensure() { remote_readiness_ensure "$@"; }
