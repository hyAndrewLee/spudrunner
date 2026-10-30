#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/process-events-remote-reply.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/process-events-remote-reply.sh" "$@"
fi
# shellcheck source=bin/process-events-remote-reply.sh
. "$(dirname "${BASH_SOURCE[0]}")/process-events-remote-reply.sh" "$@"
