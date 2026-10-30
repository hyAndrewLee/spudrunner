#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/task-instructions-heading-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/task-instructions-heading-lib.sh" "$@"
fi
# shellcheck source=bin/task-instructions-heading-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/task-instructions-heading-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_brief_heading_parse() { brief_heading_parse "$@"; }
fm_brief_heading_body() { brief_heading_body "$@"; }
fm_brief_heading_present() { brief_heading_present "$@"; }
fm_brief_task_heading_body() { brief_task_heading_body "$@"; }
fm_brief_task_heading_present() { brief_task_heading_present "$@"; }
