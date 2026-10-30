#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/tool-update-check.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/tool-update-check.sh" "$@"
fi
# shellcheck source=bin/tool-update-check.sh
. "$(dirname "${BASH_SOURCE[0]}")/tool-update-check.sh" "$@"
