#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/host-mirror.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/host-mirror.sh" "$@"
fi
# shellcheck source=bin/host-mirror.sh
. "$(dirname "${BASH_SOURCE[0]}")/host-mirror.sh" "$@"
