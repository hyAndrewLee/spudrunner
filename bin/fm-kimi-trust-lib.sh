#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/kimi-trust-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/kimi-trust-lib.sh" "$@"
fi
# shellcheck source=bin/kimi-trust-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/kimi-trust-lib.sh" "$@"
