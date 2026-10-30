#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/session-open-nudge.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/session-open-nudge.sh" "$@"
fi
# shellcheck source=bin/session-open-nudge.sh
. "$(dirname "${BASH_SOURCE[0]}")/session-open-nudge.sh" "$@"
