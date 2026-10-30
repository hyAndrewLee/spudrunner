#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/agent-transition-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/agent-transition-lib.sh" "$@"
fi
# shellcheck source=bin/agent-transition-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/agent-transition-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_transition_record() { transition_record "$@"; }
fm_transition_clean_field() { transition_clean_field "$@"; }
fm_transition_field() { transition_field "$@"; }
fm_transition_pane_id() { transition_pane_id "$@"; }
fm_transition_workspace_id() { transition_workspace_id "$@"; }
fm_transition_from_status() { transition_from_status "$@"; }
fm_transition_to_status() { transition_to_status "$@"; }
fm_transition_agent() { transition_agent "$@"; }
fm_transition_detail() { transition_detail "$@"; }
fm_transition_policy() { transition_policy "$@"; }
fm_transition_marker() { transition_marker "$@"; }
fm_transition_apply() { transition_apply "$@"; }
fm_transition_commit() { transition_commit "$@"; }
fm_transition_clear() { transition_clear "$@"; }
