#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/task-cleanup.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/task-cleanup.sh" "$@"
fi
# shellcheck source=bin/task-cleanup.sh
. "$(dirname "${BASH_SOURCE[0]}")/task-cleanup.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
t3code_secondmate_lsof_check() { t3code_project_coordinator_lsof_check "$@"; }
secondmate_unresolved_pending_replies_refuse() { project_coordinator_unresolved_pending_replies_refuse "$@"; }
remote_secondmate_teardown() { remote_project_coordinator_teardown "$@"; }
remote_secondmate_teardown_locked() { remote_project_coordinator_teardown_locked "$@"; }
collect_local_firstmate_states() { collect_local_coordinator_states "$@"; }
firstmate_home_has_treehouse_slot() { coordinator_home_has_treehouse_slot "$@"; }
validate_firstmate_operational_dirs_for_removal() { validate_coordinator_operational_dirs_for_removal "$@"; }
validate_firstmate_home_for_removal() { validate_coordinator_home_for_removal "$@"; }
t3code_secondmate_home_shutdown_barrier() { t3code_project_coordinator_home_shutdown_barrier "$@"; }
remove_firstmate_home() { remove_coordinator_home "$@"; }
firstmate_home_has_process_events() { coordinator_home_has_process_events "$@"; }
snapshot_firstmate_home_process_events() { snapshot_coordinator_home_process_events "$@"; }
restore_firstmate_home_process_events() { restore_coordinator_home_process_events "$@"; }
cleanup_firstmate_home_process_events() { cleanup_coordinator_home_process_events "$@"; }
preflight_firstmate_home_process_events() { preflight_coordinator_home_process_events "$@"; }
preflight_firstmate_home_process_event_tree() { preflight_coordinator_home_process_event_tree "$@"; }
validate_firstmate_home_children_removal() { validate_coordinator_home_children_removal "$@"; }
preflight_firstmate_home_herdr_children() { preflight_coordinator_home_herdr_children "$@"; }
cleanup_firstmate_home_children() { cleanup_coordinator_home_children "$@"; }
remove_secondmate_registry_entry() { remove_project_coordinator_registry_entry "$@"; }
