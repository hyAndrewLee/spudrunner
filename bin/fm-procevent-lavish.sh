#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/process-events-lavish.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/process-events-lavish.sh" "$@"
fi
# shellcheck source=bin/process-events-lavish.sh
. "$(dirname "${BASH_SOURCE[0]}")/process-events-lavish.sh" "$@"
