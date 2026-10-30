#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/supervision-engine-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/supervision-engine-lib.sh" "$@"
fi
# shellcheck source=bin/supervision-engine-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/supervision-engine-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_supervision_host_primary() { supervision_host_primary "$@"; }
fm_supervision_host_enabled() { supervision_host_enabled "$@"; }
fm_supervision_engine_verified() { supervision_engine_verified "$@"; }
fm_supervision_engine_default_model() { supervision_engine_default_model "$@"; }
fm_supervision_host_config() { supervision_host_config "$@"; }
fm_supervision_host_attended_ready() { supervision_host_attended_ready "$@"; }
fm_supervision_host_outcomes_drained() { supervision_host_outcomes_drained "$@"; }
fm_supervision_host_main_key() { supervision_host_main_key "$@"; }
fm_supervision_host_health_key() { supervision_host_health_key "$@"; }
fm_supervision_host_paused_until() { supervision_host_paused_until "$@"; }
fm_supervision_host_clock() { supervision_host_clock "$@"; }
fm_supervision_engine_bin() { supervision_engine_bin "$@"; }
_fm_engine_identity() { _engine_identity "$@"; }
_fm_engine_process_table() { _engine_process_table "$@"; }
_fm_engine_snapshot_descendants() { _engine_snapshot_descendants "$@"; }
_fm_engine_reap() { _engine_reap "$@"; }
fm_supervision_engine_turn() { supervision_engine_turn "$@"; }
fm_supervision_engine_result() { supervision_engine_result "$@"; }
