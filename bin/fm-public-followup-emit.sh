#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/public-followup-emit.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/public-followup-emit.sh" "$@"
fi
# shellcheck source=bin/public-followup-emit.sh
. "$(dirname "${BASH_SOURCE[0]}")/public-followup-emit.sh" "$@"
