#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/supervision-handoff.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/supervision-handoff.sh" "$@"
fi
# shellcheck source=bin/supervision-handoff.sh
. "$(dirname "${BASH_SOURCE[0]}")/supervision-handoff.sh" "$@"
