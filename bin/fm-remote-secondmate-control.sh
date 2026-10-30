#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/remote-project-coordinator-control.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/remote-project-coordinator-control.sh" "$@"
fi
# shellcheck source=bin/remote-project-coordinator-control.sh
. "$(dirname "${BASH_SOURCE[0]}")/remote-project-coordinator-control.sh" "$@"
