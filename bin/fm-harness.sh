#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/agent-runtime.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/agent-runtime.sh" "$@"
fi
# shellcheck source=bin/agent-runtime.sh
. "$(dirname "${BASH_SOURCE[0]}")/agent-runtime.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
resolve_crew() { resolve_worker "$@"; }
secondmate_parse() { project_coordinator_parse "$@"; }
secondmate_line() { project_coordinator_line "$@"; }
secondmate_field() { project_coordinator_field "$@"; }
resolve_secondmate() { resolve_project_coordinator "$@"; }
resolve_secondmate_model() { resolve_project_coordinator_model "$@"; }
resolve_secondmate_effort() { resolve_project_coordinator_effort "$@"; }
