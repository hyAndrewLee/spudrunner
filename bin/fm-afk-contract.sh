#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/away-mode-contract.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/away-mode-contract.sh" "$@"
fi
# shellcheck source=bin/away-mode-contract.sh
. "$(dirname "${BASH_SOURCE[0]}")/away-mode-contract.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_afk_contract_path() { away_mode_contract_path "$@"; }
fm_afk_contract_legacy_proposal_path() { away_mode_contract_legacy_proposal_path "$@"; }
fm_afk_contract_archive_dir() { away_mode_contract_archive_dir "$@"; }
fm_afk_contract_present() { away_mode_contract_present "$@"; }
fm_afk_contract_live_ordinary_workers() { away_mode_contract_live_ordinary_workers "$@"; }
fm_afk_contract_entry_spend_default() { away_mode_contract_entry_spend_default "$@"; }
fm_afk_contract_record_mode() { away_mode_contract_record_mode "$@"; }
fm_afk_contract_mode() { away_mode_contract_mode "$@"; }
fm_afk_contract_away_present() { away_mode_contract_away_present "$@"; }
fm_afk_contract_lock_path() { away_mode_contract_lock_path "$@"; }
fm_afk_contract_lock_helpers() { away_mode_contract_lock_helpers "$@"; }
fm_afk_contract_lock_hold() { away_mode_contract_lock_hold "$@"; }
fm_afk_contract_lock_release() { away_mode_contract_lock_release "$@"; }
fm_afk_contract_log() { away_mode_contract_log "$@"; }
fm_afk_contract_usage() { away_mode_contract_usage "$@"; }
fm_afk_contract_now_iso() { away_mode_contract_now_iso "$@"; }
fm_afk_contract_validate_iso() { away_mode_contract_validate_iso "$@"; }
fm_afk_contract_render_record() { away_mode_contract_render_record "$@"; }
fm_afk_contract_write_atomic() { away_mode_contract_write_atomic "$@"; }
fm_afk_contract_read_field() { away_mode_contract_read_field "$@"; }
fm_afk_contract_read_words() { away_mode_contract_read_words "$@"; }
fm_afk_contract_validate() { away_mode_contract_validate "$@"; }
fm_afk_contract_render_readback() { away_mode_contract_render_readback "$@"; }
fm_afk_contract_render_announcement() { away_mode_contract_render_announcement "$@"; }
fm_afk_contract_parse_inputs() { away_mode_contract_parse_inputs "$@"; }
fm_afk_contract_archive_target() { away_mode_contract_archive_target "$@"; }
fm_afk_contract_cmd_enter() { away_mode_contract_cmd_enter "$@"; }
fm_afk_contract_cmd_archive() { away_mode_contract_cmd_archive "$@"; }
fm_afk_contract_select_path() { away_mode_contract_select_path "$@"; }
fm_afk_contract_locked_cmd() { away_mode_contract_locked_cmd "$@"; }
fm_afk_contract_main() { away_mode_contract_main "$@"; }
