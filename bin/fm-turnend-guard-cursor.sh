#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/turn-end-guard-cursor.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/turn-end-guard-cursor.sh" "$@"
fi
# shellcheck source=bin/turn-end-guard-cursor.sh
. "$(dirname "${BASH_SOURCE[0]}")/turn-end-guard-cursor.sh" "$@"
