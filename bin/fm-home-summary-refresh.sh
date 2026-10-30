#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/home-summary-refresh.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/home-summary-refresh.sh" "$@"
fi
# shellcheck source=bin/home-summary-refresh.sh
. "$(dirname "${BASH_SOURCE[0]}")/home-summary-refresh.sh" "$@"
