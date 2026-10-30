#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/supervision-instructions.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/supervision-instructions.sh" "$@"
fi
# shellcheck source=bin/supervision-instructions.sh
. "$(dirname "${BASH_SOURCE[0]}")/supervision-instructions.sh" "$@"
