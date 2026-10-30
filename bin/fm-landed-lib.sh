#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/landed-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/landed-lib.sh" "$@"
fi
# shellcheck source=bin/landed-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/landed-lib.sh" "$@"
