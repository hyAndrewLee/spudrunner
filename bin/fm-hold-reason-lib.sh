#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/hold-reason-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/hold-reason-lib.sh" "$@"
fi
# shellcheck source=bin/hold-reason-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/hold-reason-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_hold_reason_encode() { hold_reason_encode "$@"; }
fm_hold_reason_decode_stream() { hold_reason_decode_stream "$@"; }
