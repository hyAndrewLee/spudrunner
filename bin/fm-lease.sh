#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/supervision-lease.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/supervision-lease.sh" "$@"
fi
# shellcheck source=bin/supervision-lease.sh
. "$(dirname "${BASH_SOURCE[0]}")/supervision-lease.sh" "$@"
