#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/cortex-plugin.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/cortex-plugin.sh" "$@"
fi
# shellcheck source=bin/cortex-plugin.sh
. "$(dirname "${BASH_SOURCE[0]}")/cortex-plugin.sh" "$@"
