#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/supervision-events-grant.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/supervision-events-grant.sh" "$@"
fi
# shellcheck source=bin/supervision-events-grant.sh
. "$(dirname "${BASH_SOURCE[0]}")/supervision-events-grant.sh" "$@"
