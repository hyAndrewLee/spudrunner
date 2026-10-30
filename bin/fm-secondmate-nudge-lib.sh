#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/project-coordinator-nudge-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/project-coordinator-nudge-lib.sh" "$@"
fi
# shellcheck source=bin/project-coordinator-nudge-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/project-coordinator-nudge-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_secondmate_nudge_marker_path() { project_coordinator_nudge_marker_path "$@"; }
fm_remote_inherit_transaction_lock_path() { remote_inherit_transaction_lock_path "$@"; }
fm_remote_inherit_generation_next() { remote_inherit_generation_next "$@"; }
fm_secondmate_nudge_write() { project_coordinator_nudge_write "$@"; }
fm_secondmate_remote_nudge_owed() { project_coordinator_remote_nudge_owed "$@"; }
fm_secondmate_remote_sync_changed() { project_coordinator_remote_sync_changed "$@"; }
