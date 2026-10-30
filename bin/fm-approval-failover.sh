#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/approval-failover.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/approval-failover.sh" "$@"
fi
# shellcheck source=bin/approval-failover.sh
. "$(dirname "${BASH_SOURCE[0]}")/approval-failover.sh" "$@"
