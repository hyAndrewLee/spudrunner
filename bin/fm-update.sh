#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/self-update.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/self-update.sh" "$@"
fi
# shellcheck source=bin/self-update.sh
. "$(dirname "${BASH_SOURCE[0]}")/self-update.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
secondmate_agent_may_be_alive() { project_coordinator_agent_may_be_alive "$@"; }
claim_settled_secondmate() { claim_settled_project_coordinator "$@"; }
fm_ff_after_secondmate_settled() { home_fast_forward_after_project_coordinator_settled "$@"; }
