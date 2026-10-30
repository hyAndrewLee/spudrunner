#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/contributions.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/contributions.sh" "$@"
fi
# shellcheck source=bin/contributions.sh
. "$(dirname "${BASH_SOURCE[0]}")/contributions.sh" "$@"
