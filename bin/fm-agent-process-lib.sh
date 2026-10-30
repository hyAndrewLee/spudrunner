#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/agent-process-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/agent-process-lib.sh" "$@"
fi
# shellcheck source=bin/agent-process-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/agent-process-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_agent_process_classify_name() { agent_process_classify_name "$@"; }
fm_agent_process_classify() { agent_process_classify "$@"; }
