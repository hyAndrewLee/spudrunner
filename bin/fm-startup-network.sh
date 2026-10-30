#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/startup-network.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/startup-network.sh" "$@"
fi
# shellcheck source=bin/startup-network.sh
. "$(dirname "${BASH_SOURCE[0]}")/startup-network.sh" "$@"
