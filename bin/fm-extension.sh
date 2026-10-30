#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/extension-host.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/extension-host.sh" "$@"
fi
# shellcheck source=bin/extension-host.sh
. "$(dirname "${BASH_SOURCE[0]}")/extension-host.sh" "$@"
