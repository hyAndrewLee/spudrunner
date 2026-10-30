#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/session-lock.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/session-lock.sh" "$@"
fi
# shellcheck source=bin/session-lock.sh
. "$(dirname "${BASH_SOURCE[0]}")/session-lock.sh" "$@"
