#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/task-instructions.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/task-instructions.sh" "$@"
fi
# shellcheck source=bin/task-instructions.sh
. "$(dirname "${BASH_SOURCE[0]}")/task-instructions.sh" "$@"
