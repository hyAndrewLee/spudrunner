#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/dispatch-resolve.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/dispatch-resolve.sh" "$@"
fi
# shellcheck source=bin/dispatch-resolve.sh
. "$(dirname "${BASH_SOURCE[0]}")/dispatch-resolve.sh" "$@"
