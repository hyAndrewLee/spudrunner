#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/polytoken-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/polytoken-lib.sh" "$@"
fi
# shellcheck source=bin/polytoken-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/polytoken-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_polytoken_binary() { polytoken_binary "$@"; }
fm_polytoken_global_config_dir() { polytoken_global_config_dir "$@"; }
fm_polytoken_config_dir() { polytoken_config_dir "$@"; }
fm_polytoken_sessions_root() { polytoken_sessions_root "$@"; }
fm_polytoken_hooks_file() { polytoken_hooks_file "$@"; }
fm_polytoken_facet_file() { polytoken_facet_file "$@"; }
fm_polytoken_busy_script() { polytoken_busy_script "$@"; }
fm_polytoken_json_escape() { polytoken_json_escape "$@"; }
fm_polytoken_shell_quote() { polytoken_shell_quote "$@"; }
fm_polytoken_write_config() { polytoken_write_config "$@"; }
fm_polytoken_write_facet() { polytoken_write_facet "$@"; }
fm_polytoken_write_busy_script() { polytoken_write_busy_script "$@"; }
fm_polytoken_require_hooks_free() { polytoken_require_hooks_free "$@"; }
fm_polytoken_require_handler_path() { polytoken_require_handler_path "$@"; }
fm_polytoken_write_hooks() { polytoken_write_hooks "$@"; }
fm_polytoken_models_refs() { polytoken_models_refs "$@"; }
fm_polytoken_launch_ref() { polytoken_launch_ref "$@"; }
fm_polytoken_model_ref() { polytoken_model_ref "$@"; }
fm_polytoken_sessions_json() { polytoken_sessions_json "$@"; }
fm_polytoken_session_for_project() { polytoken_session_for_project "$@"; }
fm_polytoken_credential_token() { polytoken_credential_token "$@"; }
fm_polytoken_rest() { polytoken_rest "$@"; }
fm_polytoken_rest_json() { polytoken_rest_json "$@"; }
fm_polytoken_turn_settled() { polytoken_turn_settled "$@"; }
fm_polytoken_interrupt() { polytoken_interrupt "$@"; }
fm_polytoken_interrupt_task() { polytoken_interrupt_task "$@"; }
