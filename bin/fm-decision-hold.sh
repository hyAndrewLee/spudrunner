#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/legacy-decision-migration.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/legacy-decision-migration.sh" "$@"
fi
# shellcheck source=bin/legacy-decision-migration.sh
. "$(dirname "${BASH_SOURCE[0]}")/legacy-decision-migration.sh" "$@"
