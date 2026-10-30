#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/turn-end-guard-grok.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/turn-end-guard-grok.sh" "$@"
fi
# shellcheck source=bin/turn-end-guard-grok.sh
. "$(dirname "${BASH_SOURCE[0]}")/turn-end-guard-grok.sh" "$@"
