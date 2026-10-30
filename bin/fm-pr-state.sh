#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/pr-state.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/pr-state.sh" "$@"
fi
# shellcheck source=bin/pr-state.sh
. "$(dirname "${BASH_SOURCE[0]}")/pr-state.sh" "$@"
