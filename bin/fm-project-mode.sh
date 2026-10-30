#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/project-mode.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/project-mode.sh" "$@"
fi
# shellcheck source=bin/project-mode.sh
. "$(dirname "${BASH_SOURCE[0]}")/project-mode.sh" "$@"
