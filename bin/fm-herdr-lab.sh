#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/herdr-lab.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/herdr-lab.sh" "$@"
fi
# shellcheck source=bin/herdr-lab.sh
. "$(dirname "${BASH_SOURCE[0]}")/herdr-lab.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_herdr_lab_error() { herdr_lab_error "$@"; }
fm_herdr_lab_validate_name() { herdr_lab_validate_name "$@"; }
fm_herdr_lab_state_dir() { herdr_lab_state_dir "$@"; }
fm_herdr_lab_tripwire_path() { herdr_lab_tripwire_path "$@"; }
fm_herdr_lab_raw() { herdr_lab_raw "$@"; }
fm_herdr_lab_session_list() { herdr_lab_session_list "$@"; }
fm_herdr_lab_fleet_state() { herdr_lab_fleet_state "$@"; }
fm_herdr_lab_prepare() { herdr_lab_prepare "$@"; }
fm_herdr_lab_refuse_if_default() { herdr_lab_refuse_if_default "$@"; }
fm_herdr_lab_cli() { herdr_lab_cli "$@"; }
fm_herdr_lab_viewer_record_path() { herdr_lab_viewer_record_path "$@"; }
fm_herdr_lab_viewer_log_path() { herdr_lab_viewer_log_path "$@"; }
fm_herdr_lab_viewer_launcher_path() { herdr_lab_viewer_launcher_path "$@"; }
fm_herdr_lab_viewer_reason() { herdr_lab_viewer_reason "$@"; }
fm_herdr_lab_process_start() { herdr_lab_process_start "$@"; }
fm_herdr_lab_process_parent() { herdr_lab_process_parent "$@"; }
fm_herdr_lab_viewer_recorded_value() { herdr_lab_viewer_recorded_value "$@"; }
fm_herdr_lab_viewer_owned_pair() { herdr_lab_viewer_owned_pair "$@"; }
fm_herdr_lab_viewer_owned_pid() { herdr_lab_viewer_owned_pid "$@"; }
fm_herdr_lab_viewer_signal() { herdr_lab_viewer_signal "$@"; }
fm_herdr_lab_viewer_owned_alive() { herdr_lab_viewer_owned_alive "$@"; }
fm_herdr_lab_viewer_session_stopped_or_absent() { herdr_lab_viewer_session_stopped_or_absent "$@"; }
fm_herdr_lab_viewer_start() { herdr_lab_viewer_start "$@"; }
fm_herdr_lab_viewer_stop() { herdr_lab_viewer_stop "$@"; }
fm_herdr_lab_viewer() { herdr_lab_viewer "$@"; }
fm_herdr_lab_cancel_viewer_launcher() { herdr_lab_cancel_viewer_launcher "$@"; }
fm_herdr_lab_cancel_provision() { herdr_lab_cancel_provision "$@"; }
fm_herdr_lab_provision() { herdr_lab_provision "$@"; }
fm_herdr_lab_check_tripwire() { herdr_lab_check_tripwire "$@"; }
fm_herdr_lab_verify_tripwire() { herdr_lab_verify_tripwire "$@"; }
fm_herdr_lab_stop() { herdr_lab_stop "$@"; }
fm_herdr_lab_teardown() { herdr_lab_teardown "$@"; }
fm_herdr_lab_name() { herdr_lab_name "$@"; }
fm_herdr_lab_usage() { herdr_lab_usage "$@"; }
fm_herdr_lab_main() { herdr_lab_main "$@"; }
