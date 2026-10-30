#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/test-isolation-proof.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/test-isolation-proof.sh" "$@"
fi
# shellcheck source=bin/test-isolation-proof.sh
. "$(dirname "${BASH_SOURCE[0]}")/test-isolation-proof.sh" "$@"
