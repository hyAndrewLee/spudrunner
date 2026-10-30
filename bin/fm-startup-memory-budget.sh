#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/startup-memory-budget.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/startup-memory-budget.sh" "$@"
fi
# shellcheck source=bin/startup-memory-budget.sh
. "$(dirname "${BASH_SOURCE[0]}")/startup-memory-budget.sh" "$@"
