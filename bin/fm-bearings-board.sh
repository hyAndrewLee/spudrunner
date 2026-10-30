#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/work-summary-board.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/work-summary-board.sh" "$@"
fi
# shellcheck source=bin/work-summary-board.sh
. "$(dirname "${BASH_SOURCE[0]}")/work-summary-board.sh" "$@"
