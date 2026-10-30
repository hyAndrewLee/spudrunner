#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/memory-pressure-guard.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/memory-pressure-guard.sh" "$@"
fi
# shellcheck source=bin/memory-pressure-guard.sh
. "$(dirname "${BASH_SOURCE[0]}")/memory-pressure-guard.sh" "$@"
