#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/supervision-check-register.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/supervision-check-register.sh" "$@"
fi
# shellcheck source=bin/supervision-check-register.sh
. "$(dirname "${BASH_SOURCE[0]}")/supervision-check-register.sh" "$@"
