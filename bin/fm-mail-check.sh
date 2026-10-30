#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/mail-monitor.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/mail-monitor.sh" "$@"
fi
# shellcheck source=bin/mail-monitor.sh
. "$(dirname "${BASH_SOURCE[0]}")/mail-monitor.sh" "$@"
