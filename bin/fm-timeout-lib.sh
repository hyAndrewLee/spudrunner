#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/timeout-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/timeout-lib.sh" "$@"
fi
# shellcheck source=bin/timeout-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/timeout-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_external_timeout_path() { external_timeout_path "$@"; }
fm_timeout_mechanism() { timeout_mechanism "$@"; }
fm_run_bash_timeout() { run_bash_timeout "$@"; }
fm_run_external_timeout() { run_external_timeout "$@"; }
fm_run_timed() { run_timed "$@"; }
fm_timed_out() { timed_out "$@"; }
fm_exec_timed() { exec_timed "$@"; }
