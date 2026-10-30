#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/test-tap-verify.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/test-tap-verify.sh" "$@"
fi
# shellcheck source=bin/test-tap-verify.sh
. "$(dirname "${BASH_SOURCE[0]}")/test-tap-verify.sh" "$@"
