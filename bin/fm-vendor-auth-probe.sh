#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/vendor-auth-probe.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/vendor-auth-probe.sh" "$@"
fi
# shellcheck source=bin/vendor-auth-probe.sh
. "$(dirname "${BASH_SOURCE[0]}")/vendor-auth-probe.sh" "$@"
