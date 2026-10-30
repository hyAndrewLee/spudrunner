#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/kimi-turn-end-hook.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/kimi-turn-end-hook.sh" "$@"
fi
# shellcheck source=bin/kimi-turn-end-hook.sh
. "$(dirname "${BASH_SOURCE[0]}")/kimi-turn-end-hook.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
validate_firstmate_files_for_remove() { validate_coordinator_files_for_remove "$@"; }
