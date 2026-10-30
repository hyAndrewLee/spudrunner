#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/supervision-events-drain.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/supervision-events-drain.sh" "$@"
fi
# shellcheck source=bin/supervision-events-drain.sh
. "$(dirname "${BASH_SOURCE[0]}")/supervision-events-drain.sh" "$@"
