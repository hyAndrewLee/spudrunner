#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/environment-file-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/environment-file-lib.sh" "$@"
fi
# shellcheck source=bin/environment-file-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/environment-file-lib.sh" "$@"
