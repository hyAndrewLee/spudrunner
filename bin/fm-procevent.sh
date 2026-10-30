#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/process-events.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/process-events.sh" "$@"
fi
# shellcheck source=bin/process-events.sh
. "$(dirname "${BASH_SOURCE[0]}")/process-events.sh" "$@"
