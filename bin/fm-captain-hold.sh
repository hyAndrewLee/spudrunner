#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/user-decision.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/user-decision.sh" "$@"
fi
# shellcheck source=bin/user-decision.sh
. "$(dirname "${BASH_SOURCE[0]}")/user-decision.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
captain_hold_cleanup() { user_hold_cleanup "$@"; }
captain_toml_section_entries() { user_toml_section_entries "$@"; }
captain_beads_toml_entries() { user_beads_toml_entries "$@"; }
captain_beads_setting() { user_beads_setting "$@"; }
captain_migration_scan_load() { user_migration_scan_load "$@"; }
captain_markdown_archive_setting() { user_markdown_archive_setting "$@"; }
captain_markdown_archive_path() { user_markdown_archive_path "$@"; }
