#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/rex-marks.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/rex-marks.sh" "$@"
fi
# shellcheck source=bin/rex-marks.sh
. "$(dirname "${BASH_SOURCE[0]}")/rex-marks.sh" "$@"
