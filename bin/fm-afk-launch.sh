#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/away-mode-launch.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/away-mode-launch.sh" "$@"
fi
# shellcheck source=bin/away-mode-launch.sh
. "$(dirname "${BASH_SOURCE[0]}")/away-mode-launch.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_afk_launch_log() { away_mode_launch_log "$@"; }
fm_afk_launch_lock_owned() { away_mode_launch_lock_owned "$@"; }
fm_afk_launch_lock_acquire() { away_mode_launch_lock_acquire "$@"; }
fm_afk_launch_lock_release() { away_mode_launch_lock_release "$@"; }
fm_afk_launch_usage() { away_mode_launch_usage "$@"; }
fm_afk_launch_primary_harness() { away_mode_launch_primary_harness "$@"; }
fm_afk_launch_host_primary() { away_mode_launch_host_primary "$@"; }
fm_afk_launch_record_quiet() { away_mode_launch_record_quiet "$@"; }
fm_afk_launch_requested_mode() { away_mode_launch_requested_mode "$@"; }
fm_afk_launch_quiet_needs_nothing() { away_mode_launch_quiet_needs_nothing "$@"; }
fm_afk_launch_quiet_check() { away_mode_launch_quiet_check "$@"; }
fm_afk_launch_daemon_allowed() { away_mode_launch_daemon_allowed "$@"; }
fm_afk_launch_host_engine_note() { away_mode_launch_host_engine_note "$@"; }
fm_afk_launch_catchup_pending() { away_mode_launch_catchup_pending "$@"; }
fm_afk_launch_record_require() { away_mode_launch_record_require "$@"; }
fm_afk_launch_enter() { away_mode_launch_enter "$@"; }
fm_afk_launch_entry_cmd() { away_mode_launch_entry_cmd "$@"; }
fm_afk_launch_daemon_cmd() { away_mode_launch_daemon_cmd "$@"; }
fm_afk_launch_record_write() { away_mode_launch_record_write "$@"; }
fm_afk_launch_flag_write() { away_mode_launch_flag_write "$@"; }
fm_afk_launch_record_read() { away_mode_launch_record_read "$@"; }
fm_afk_launch_record_validate_if_present() { away_mode_launch_record_validate_if_present "$@"; }
fm_afk_launch_close_terminal() { away_mode_launch_close_terminal "$@"; }
fm_afk_launch_terminal_absent() { away_mode_launch_terminal_absent "$@"; }
fm_afk_launch_close_recorded() { away_mode_launch_close_recorded "$@"; }
fm_afk_launch_terminal_alive() { away_mode_launch_terminal_alive "$@"; }
fm_afk_launch_wait_ready() { away_mode_launch_wait_ready "$@"; }
fm_afk_launch_commit_terminal() { away_mode_launch_commit_terminal "$@"; }
fm_afk_launch_herdr_recover_created() { away_mode_launch_herdr_recover_created "$@"; }
fm_afk_launch_reconcile() { away_mode_launch_reconcile "$@"; }
fm_afk_launch_restore_backup() { away_mode_launch_restore_backup "$@"; }
fm_afk_launch_create_herdr() { away_mode_launch_create_herdr "$@"; }
fm_afk_launch_create_rex() { away_mode_launch_create_rex "$@"; }
fm_afk_launch_create_tmux() { away_mode_launch_create_tmux "$@"; }
fm_afk_launch_start() { away_mode_launch_start "$@"; }
fm_afk_launch_start_native() { away_mode_launch_start_native "$@"; }
fm_afk_launch_stop() { away_mode_launch_stop "$@"; }
fm_afk_launch_quiet_rollback() { away_mode_launch_quiet_rollback "$@"; }
fm_afk_launch_main() { away_mode_launch_main "$@"; }
