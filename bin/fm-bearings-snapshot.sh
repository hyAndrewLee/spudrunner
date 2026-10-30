#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/work-summary-snapshot.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/work-summary-snapshot.sh" "$@"
fi
# shellcheck source=bin/work-summary-snapshot.sh
. "$(dirname "${BASH_SOURCE[0]}")/work-summary-snapshot.sh" "$@"
