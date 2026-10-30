#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/usage-warner.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/usage-warner.sh" "$@"
fi
# shellcheck source=bin/usage-warner.sh
. "$(dirname "${BASH_SOURCE[0]}")/usage-warner.sh" "$@"
