#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/relay-reply.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/relay-reply.sh" "$@"
fi
# shellcheck source=bin/relay-reply.sh
. "$(dirname "${BASH_SOURCE[0]}")/relay-reply.sh" "$@"
