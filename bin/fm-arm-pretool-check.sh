#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/supervision-pretool-check.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/supervision-pretool-check.sh" "$@"
fi
# shellcheck source=bin/supervision-pretool-check.sh
. "$(dirname "${BASH_SOURCE[0]}")/supervision-pretool-check.sh" "$@"
