#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/relay-followup.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/relay-followup.sh" "$@"
fi
# shellcheck source=bin/relay-followup.sh
. "$(dirname "${BASH_SOURCE[0]}")/relay-followup.sh" "$@"
