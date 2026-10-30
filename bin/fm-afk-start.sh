#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/away-mode-start.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/away-mode-start.sh" "$@"
fi
# shellcheck source=bin/away-mode-start.sh
. "$(dirname "${BASH_SOURCE[0]}")/away-mode-start.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_afk_start_usage() { away_mode_start_usage "$@"; }
fm_afk_clear_stale_artifacts() { away_mode_clear_stale_artifacts "$@"; }
fm_afk_flag_write() { away_mode_flag_write "$@"; }
fm_afk_start_main() { away_mode_start_main "$@"; }
