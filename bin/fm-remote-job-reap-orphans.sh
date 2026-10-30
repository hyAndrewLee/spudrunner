#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/remote-job-reap-orphans.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/remote-job-reap-orphans.sh" "$@"
fi
# shellcheck source=bin/remote-job-reap-orphans.sh
. "$(dirname "${BASH_SOURCE[0]}")/remote-job-reap-orphans.sh" "$@"
