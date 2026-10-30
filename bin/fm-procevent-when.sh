#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/process-events-when.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/process-events-when.sh" "$@"
fi
# shellcheck source=bin/process-events-when.sh
. "$(dirname "${BASH_SOURCE[0]}")/process-events-when.sh" "$@"
