#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/supervision-watch-checkpoint.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/supervision-watch-checkpoint.sh" "$@"
fi
# shellcheck source=bin/supervision-watch-checkpoint.sh
. "$(dirname "${BASH_SOURCE[0]}")/supervision-watch-checkpoint.sh" "$@"
