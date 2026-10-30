#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/project-coordinator-charter-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/project-coordinator-charter-lib.sh" "$@"
fi
# shellcheck source=bin/project-coordinator-charter-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/project-coordinator-charter-lib.sh" "$@"
