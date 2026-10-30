#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/session-open-cursor.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/session-open-cursor.sh" "$@"
fi
# shellcheck source=bin/session-open-cursor.sh
. "$(dirname "${BASH_SOURCE[0]}")/session-open-cursor.sh" "$@"
