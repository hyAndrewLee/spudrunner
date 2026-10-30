#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/project-sync.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/project-sync.sh" "$@"
fi
# shellcheck source=bin/project-sync.sh
. "$(dirname "${BASH_SOURCE[0]}")/project-sync.sh" "$@"
