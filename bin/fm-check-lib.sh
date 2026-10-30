#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/supervision-check-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/supervision-check-lib.sh" "$@"
fi
# shellcheck source=bin/supervision-check-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/supervision-check-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_custom_check_sha256() { custom_check_sha256 "$@"; }
fm_custom_check_trust_read() { custom_check_trust_read "$@"; }
fm_custom_check_registered() { custom_check_registered "$@"; }
fm_custom_check_snapshot_prepare() { custom_check_snapshot_prepare "$@"; }
fm_custom_check_snapshot_cleanup() { custom_check_snapshot_cleanup "$@"; }
