#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/public-followup.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/public-followup.sh" "$@"
fi
# shellcheck source=bin/public-followup.sh
. "$(dirname "${BASH_SOURCE[0]}")/public-followup.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
public_followup_secondmate_home() { public_followup_project_coordinator_home "$@"; }
