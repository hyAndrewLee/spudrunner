#!/usr/bin/env bash
# shellcheck disable=SC2329 # Source-only legacy API aliases are called externally.
# Compatibility entrypoint for installed homes; use bin/installation-check.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/installation-check.sh" "$@"
fi

# shellcheck disable=SC2329 # Legacy source-library API aliases.
secondmate_note_respawned() { project_coordinator_note_respawned "$@"; }
secondmate_sync() { project_coordinator_sync "$@"; }
secondmate_nudge_marker_path() { project_coordinator_bootstrap_nudge_marker_path "$@"; }
secondmate_write_nudge_marker() { project_coordinator_write_nudge_marker "$@"; }
secondmate_send_nudge() { project_coordinator_send_nudge "$@"; }
fm_ff_after_instruction_update() { home_fast_forward_after_instruction_update "$@"; }
secondmate_retry_pending_nudges() { project_coordinator_retry_pending_nudges "$@"; }
secondmate_sync_remote_one() { project_coordinator_sync_remote_one "$@"; }
secondmate_sync_remote_one_timed() { project_coordinator_sync_remote_one_timed "$@"; }
secondmate_liveness_sweep() { project_coordinator_liveness_sweep "$@"; }
secondmate_liveness_one_timed() { project_coordinator_liveness_one_timed "$@"; }
secondmate_liveness_one() { project_coordinator_liveness_one "$@"; }
secondmate_handoff_resume() { project_coordinator_handoff_resume "$@"; }
secondmate_handoff_detect() { project_coordinator_handoff_detect "$@"; }
crew_dispatch_validate() { worker_dispatch_validate "$@"; }

# shellcheck source=bin/installation-check.sh
. "$(dirname "${BASH_SOURCE[0]}")/installation-check.sh" "$@"
