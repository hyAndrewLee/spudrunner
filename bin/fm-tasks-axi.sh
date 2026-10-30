#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/tasks-axi.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/tasks-axi.sh" "$@"
fi
# shellcheck source=bin/tasks-axi.sh
. "$(dirname "${BASH_SOURCE[0]}")/tasks-axi.sh" "$@"
