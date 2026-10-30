#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/runtime-backend-hometag-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/runtime-backend-hometag-lib.sh" "$@"
fi
# shellcheck source=bin/runtime-backend-hometag-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/runtime-backend-hometag-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_backend_hometag() { runtime_backend_hometag "$@"; }
