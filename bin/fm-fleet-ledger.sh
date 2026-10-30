#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/activity-ledger.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/activity-ledger.sh" "$@"
fi
# shellcheck source=bin/activity-ledger.sh
. "$(dirname "${BASH_SOURCE[0]}")/activity-ledger.sh" "$@"
