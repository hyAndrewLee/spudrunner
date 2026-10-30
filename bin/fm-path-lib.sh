#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/path-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/path-lib.sh" "$@"
fi
# shellcheck source=bin/path-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/path-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_dirname_to() { dirname_to "$@"; }
fm_basename_to() { basename_to "$@"; }
