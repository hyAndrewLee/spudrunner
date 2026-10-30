#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/backlog-handoff.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/backlog-handoff.sh" "$@"
fi
# shellcheck source=bin/backlog-handoff.sh
. "$(dirname "${BASH_SOURCE[0]}")/backlog-handoff.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
secondmate_home() { project_coordinator_home "$@"; }
validate_secondmate_home() { validate_project_coordinator_home "$@"; }
wake_secondmate_receiver() { wake_project_coordinator_receiver "$@"; }
wake_pending_secondmate_receiver() { wake_pending_project_coordinator_receiver "$@"; }
