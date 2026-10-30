#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/capacity.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/capacity.sh" "$@"
fi
# shellcheck source=bin/capacity.sh
. "$(dirname "${BASH_SOURCE[0]}")/capacity.sh" "$@"
