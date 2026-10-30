#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/remote-entrypoint.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/remote-entrypoint.sh" "$@"
fi
# shellcheck source=bin/remote-entrypoint.sh
. "$(dirname "${BASH_SOURCE[0]}")/remote-entrypoint.sh" "$@"
