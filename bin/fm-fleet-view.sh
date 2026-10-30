#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/active-work-view.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/active-work-view.sh" "$@"
fi
# shellcheck source=bin/active-work-view.sh
. "$(dirname "${BASH_SOURCE[0]}")/active-work-view.sh" "$@"
