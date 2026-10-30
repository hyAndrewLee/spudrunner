#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/task-inspect.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/task-inspect.sh" "$@"
fi
# shellcheck source=bin/task-inspect.sh
. "$(dirname "${BASH_SOURCE[0]}")/task-inspect.sh" "$@"
