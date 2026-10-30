#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/timing-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/timing-lib.sh" "$@"
fi
# shellcheck source=bin/timing-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/timing-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_timing_enabled() { timing_enabled "$@"; }
fm_timing_now_ms() { timing_now_ms "$@"; }
fm_timing_epoch_ensure() { timing_epoch_ensure "$@"; }
fm_timing_start() { timing_start "$@"; }
fm_timing_sanitize() { timing_sanitize "$@"; }
fm_timing_record() { timing_record "$@"; }
fm_timing_render() { timing_render "$@"; }
