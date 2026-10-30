#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/process-events-quota.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/process-events-quota.sh" "$@"
fi
# shellcheck source=bin/process-events-quota.sh
. "$(dirname "${BASH_SOURCE[0]}")/process-events-quota.sh" "$@"
