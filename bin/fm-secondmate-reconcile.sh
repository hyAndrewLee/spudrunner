#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/project-coordinator-reconcile.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/project-coordinator-reconcile.sh" "$@"
fi
# shellcheck source=bin/project-coordinator-reconcile.sh
. "$(dirname "${BASH_SOURCE[0]}")/project-coordinator-reconcile.sh" "$@"
