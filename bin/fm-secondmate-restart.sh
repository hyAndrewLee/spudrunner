#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/project-coordinator-restart.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/project-coordinator-restart.sh" "$@"
fi
# shellcheck source=bin/project-coordinator-restart.sh
. "$(dirname "${BASH_SOURCE[0]}")/project-coordinator-restart.sh" "$@"
