#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/supervision-watch.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/supervision-watch.sh" "$@"
fi
# shellcheck source=bin/supervision-watch.sh
. "$(dirname "${BASH_SOURCE[0]}")/supervision-watch.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
captain_held_silenced() { user_held_silenced "$@"; }
secondmate_oldest_queue_row() { project_coordinator_oldest_queue_row "$@"; }
secondmate_in_active_turn() { project_coordinator_in_active_turn "$@"; }
secondmate_busy_class() { project_coordinator_busy_class "$@"; }
secondmate_idle_ring_safe() { project_coordinator_idle_ring_safe "$@"; }
secondmate_ring_to_drain() { project_coordinator_ring_to_drain "$@"; }
secondmate_wake_stall_tick() { project_coordinator_wake_stall_tick "$@"; }
secondmate_liveness_tick() { project_coordinator_liveness_tick "$@"; }
task_captain_call_open() { task_user_call_open "$@"; }
captain_call_declaration() { user_call_declaration "$@"; }
captain_call_stale_bound() { user_call_stale_bound "$@"; }
fm_check_output_cleanup() { check_output_cleanup "$@"; }
fm_active_check_stop() { active_check_stop "$@"; }
fm_capture_output_cleanup() { capture_output_cleanup "$@"; }
fm_wait_tmp_cleanup() { wait_tmp_cleanup "$@"; }
mark_all_captain_relevant_surfaced() { mark_all_user_relevant_surfaced "$@"; }
