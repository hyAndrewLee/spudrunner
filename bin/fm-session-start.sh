#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/session-start.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/session-start.sh" "$@"
fi
# shellcheck source=bin/session-start.sh
. "$(dirname "${BASH_SOURCE[0]}")/session-start.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_session_start_endpoint_read() { session_start_endpoint_read "$@"; }
