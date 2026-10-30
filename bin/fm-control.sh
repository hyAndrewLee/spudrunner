#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/agent-control.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/agent-control.sh" "$@"
fi
# shellcheck source=bin/agent-control.sh
. "$(dirname "${BASH_SOURCE[0]}")/agent-control.sh" "$@"
