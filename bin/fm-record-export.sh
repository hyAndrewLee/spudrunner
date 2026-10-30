#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/record-export.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/record-export.sh" "$@"
fi
# shellcheck source=bin/record-export.sh
. "$(dirname "${BASH_SOURCE[0]}")/record-export.sh" "$@"
