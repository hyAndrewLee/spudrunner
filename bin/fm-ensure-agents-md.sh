#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/ensure-agents-md.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/ensure-agents-md.sh" "$@"
fi
# shellcheck source=bin/ensure-agents-md.sh
. "$(dirname "${BASH_SOURCE[0]}")/ensure-agents-md.sh" "$@"
