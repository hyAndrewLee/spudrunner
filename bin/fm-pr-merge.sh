#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/pr-merge.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/pr-merge.sh" "$@"
fi
# shellcheck source=bin/pr-merge.sh
. "$(dirname "${BASH_SOURCE[0]}")/pr-merge.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
require_released_captain_hold() { require_released_user_hold "$@"; }
