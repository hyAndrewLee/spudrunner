#!/usr/bin/env bash
# shellcheck disable=SC2329 # Source-only legacy API aliases are called externally.
# Compatibility entrypoint for installed homes; use bin/task-state.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/task-state.sh" "$@"
fi

# shellcheck disable=SC2329 # Legacy source-library API aliases.
emit_ship_status_done() { emit_implementation_status_done "$@"; }
crew_busy_verdict() { worker_busy_verdict "$@"; }

# shellcheck source=bin/task-state.sh
. "$(dirname "${BASH_SOURCE[0]}")/task-state.sh" "$@"
