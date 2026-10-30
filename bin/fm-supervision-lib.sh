#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/supervision-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/supervision-lib.sh" "$@"
fi
# shellcheck source=bin/supervision-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/supervision-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_sup_stat_mtime() { supervision_stat_mtime "$@"; }
fm_supervision_status() { supervision_status "$@"; }
fm_supervision_needed() { supervision_needed "$@"; }
fm_supervision_unhealthy() { supervision_unhealthy "$@"; }
