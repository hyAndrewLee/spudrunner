#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/remote-job-worker.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/remote-job-worker.sh" "$@"
fi
# shellcheck source=bin/remote-job-worker.sh
. "$(dirname "${BASH_SOURCE[0]}")/remote-job-worker.sh" "$@"
