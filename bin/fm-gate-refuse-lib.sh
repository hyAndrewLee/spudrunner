#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/gate-refuse-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/gate-refuse-lib.sh" "$@"
fi
# shellcheck source=bin/gate-refuse-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/gate-refuse-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_gate_lab_home() { gate_lab_home "$@"; }
fm_gate_lab_mark() { gate_lab_mark "$@"; }
fm_gate_lab_permitted() { gate_lab_permitted "$@"; }
fm_is_gate_agent() { is_gate_agent "$@"; }
fm_refuse_if_gate_agent() { refuse_if_gate_agent "$@"; }
