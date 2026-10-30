#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/relay-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/relay-lib.sh" "$@"
fi
# shellcheck source=bin/relay-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/relay-lib.sh" "$@"
