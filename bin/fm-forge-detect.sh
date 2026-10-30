#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/forge-detect.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/forge-detect.sh" "$@"
fi
# shellcheck source=bin/forge-detect.sh
. "$(dirname "${BASH_SOURCE[0]}")/forge-detect.sh" "$@"
