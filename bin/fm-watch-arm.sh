#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/supervision-watch-arm.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/supervision-watch-arm.sh" "$@"
fi
# shellcheck source=bin/supervision-watch-arm.sh
. "$(dirname "${BASH_SOURCE[0]}")/supervision-watch-arm.sh" "$@"
