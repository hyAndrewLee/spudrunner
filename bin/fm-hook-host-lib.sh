#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/hook-host-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/hook-host-lib.sh" "$@"
fi
# shellcheck source=bin/hook-host-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/hook-host-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_hook_payload_is_foreign_host() { hook_payload_is_foreign_host "$@"; }
