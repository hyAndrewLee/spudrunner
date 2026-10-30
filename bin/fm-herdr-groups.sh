#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/herdr-groups.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/herdr-groups.sh" "$@"
fi
# shellcheck source=bin/herdr-groups.sh
. "$(dirname "${BASH_SOURCE[0]}")/herdr-groups.sh" "$@"
