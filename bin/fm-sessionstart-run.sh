#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/session-open-run.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/session-open-run.sh" "$@"
fi
# shellcheck source=bin/session-open-run.sh
. "$(dirname "${BASH_SOURCE[0]}")/session-open-run.sh" "$@"
