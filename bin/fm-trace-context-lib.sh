#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/trace-context-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/trace-context-lib.sh" "$@"
fi
# shellcheck source=bin/trace-context-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/trace-context-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_trace_context_valid() { trace_context_valid "$@"; }
fm_trace_context_hex() { trace_context_hex "$@"; }
fm_trace_context_enabled() { trace_context_enabled "$@"; }
fm_trace_context_session_lock() { trace_context_session_lock "$@"; }
fm_trace_context_session_start() { trace_context_session_start "$@"; }
fm_trace_context_session_effective() { trace_context_session_effective "$@"; }
fm_trace_context_recorded() { trace_context_recorded "$@"; }
fm_trace_context_mint() { trace_context_mint "$@"; }
fm_trace_context_resolve() { trace_context_resolve "$@"; }
