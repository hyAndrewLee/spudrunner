#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/agent-activity-event.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/agent-activity-event.sh" "$@"
fi
# shellcheck source=bin/agent-activity-event.sh
. "$(dirname "${BASH_SOURCE[0]}")/agent-activity-event.sh" "$@"
