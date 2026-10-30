#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/claude-trust.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/claude-trust.sh" "$@"
fi
# shellcheck source=bin/claude-trust.sh
. "$(dirname "${BASH_SOURCE[0]}")/claude-trust.sh" "$@"
