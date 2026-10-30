#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/mail-client.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/mail-client.sh" "$@"
fi
# shellcheck source=bin/mail-client.sh
. "$(dirname "${BASH_SOURCE[0]}")/mail-client.sh" "$@"
