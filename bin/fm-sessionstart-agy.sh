#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/session-open-agy.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/session-open-agy.sh" "$@"
fi
# shellcheck source=bin/session-open-agy.sh
. "$(dirname "${BASH_SOURCE[0]}")/session-open-agy.sh" "$@"
