#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/supervision-check-unregister.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/supervision-check-unregister.sh" "$@"
fi
# shellcheck source=bin/supervision-check-unregister.sh
. "$(dirname "${BASH_SOURCE[0]}")/supervision-check-unregister.sh" "$@"
