#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/agent-input-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/agent-input-lib.sh" "$@"
fi
# shellcheck source=bin/agent-input-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/agent-input-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_composer_strip_ansi() { agent_input_strip_ansi "$@"; }
fm_composer_normalize_spaces_var() { agent_input_normalize_spaces_var "$@"; }
fm_composer_normalize_trim_var() { agent_input_normalize_trim_var "$@"; }
fm_composer_strip_ghost() { agent_input_strip_ghost "$@"; }
fm_busy_lines_match() { agent_activity_lines_match "$@"; }
fm_composer_strip_braille() { agent_input_strip_braille "$@"; }
_fm_composer_is_prompt_glyph() { _agent_input_is_prompt_glyph "$@"; }
fm_composer_leading_prompt_glyph_var() { agent_input_leading_prompt_glyph_var "$@"; }
fm_composer_leading_agent_glyph_var() { agent_input_leading_agent_glyph_var "$@"; }
fm_composer_leading_shell_glyph_var() { agent_input_leading_shell_glyph_var "$@"; }
fm_composer_idle_matches() { agent_input_idle_matches "$@"; }
fm_composer_classify_content() { agent_input_classify_content "$@"; }
_fm_composer_pi_separator_row() { _agent_input_pi_separator_row "$@"; }
_fm_composer_titled_rule_row() { _agent_input_titled_rule_row "$@"; }
_fm_composer_scan_screen() { _agent_input_scan_screen "$@"; }
_fm_composer_grok_typed_title_ok() { _agent_input_grok_typed_title_ok "$@"; }
_fm_composer_titled_rule_inner_ok() { _agent_input_titled_rule_inner_ok "$@"; }
_fm_composer_titled_bottom_ok() { _agent_input_titled_bottom_ok "$@"; }
fm_composer_row_has_edge() { agent_input_row_has_edge "$@"; }
fm_composer_geometry_spaces() { agent_input_geometry_spaces "$@"; }
_fm_composer_screen_row() { _agent_input_screen_row "$@"; }
_fm_composer_row_content() { _agent_input_row_content "$@"; }
_fm_composer_classify_rows() { _agent_input_classify_rows "$@"; }
_fm_composer_classify_bare_row() { _agent_input_classify_bare_row "$@"; }
_fm_composer_row_is_omp_status() { _agent_input_row_is_omp_status "$@"; }
_fm_composer_row_is_pi_status() { _agent_input_row_is_pi_status "$@"; }
_fm_composer_row_is_cortex_status() { _agent_input_row_is_cortex_status "$@"; }
_fm_composer_row_is_braille_furniture() { _agent_input_row_is_braille_furniture "$@"; }
_fm_composer_bare_row_strip_furniture_var() { _agent_input_bare_row_strip_furniture_var "$@"; }
_fm_composer_wrap_region_ok() { _agent_input_wrap_region_ok "$@"; }
_fm_composer_classify_bare_wrap() { _agent_input_classify_bare_wrap "$@"; }
_fm_composer_leftbar_cwd_start() { _agent_input_leftbar_cwd_start "$@"; }
_fm_composer_row_is_leftbar_footer() { _agent_input_row_is_leftbar_footer "$@"; }
_fm_composer_leftbar_plain_content() { _agent_input_leftbar_plain_content "$@"; }
_fm_composer_classify_leftbar() { _agent_input_classify_leftbar "$@"; }
_fm_composer_leftbar_floor_row() { _agent_input_leftbar_floor_row "$@"; }
_fm_composer_row_is_composer_furniture() { _agent_input_row_is_composer_furniture "$@"; }
_fm_composer_locate_footer_zone() { _agent_input_locate_footer_zone "$@"; }
_fm_composer_bare_rule_sandwich() { _agent_input_bare_rule_sandwich "$@"; }
_fm_composer_select_cursorless() { _agent_input_select_cursorless "$@"; }
fm_composer_extract_selected_content() { agent_input_extract_selected_content "$@"; }
fm_composer_blocking_dialog() { agent_input_blocking_dialog "$@"; }
fm_composer_note_blocking_dialog() { agent_input_note_blocking_dialog "$@"; }
fm_composer_blocking_dialog_noted() { agent_input_blocking_dialog_noted "$@"; }
fm_composer_dialog_sink_prepare() { agent_input_dialog_sink_prepare "$@"; }
fm_composer_dialog_sink_release() { agent_input_dialog_sink_release "$@"; }
fm_composer_classify_screen() { agent_input_classify_screen "$@"; }
fm_composer_submit_retry_core() { agent_input_submit_retry_core "$@"; }
fm_composer_queued_enter_verdict() { agent_input_queued_enter_verdict "$@"; }
_fm_composer_classify_pi_rows() { _agent_input_classify_pi_rows "$@"; }
_fm_composer_classify_bare_pi_overlap() { _agent_input_classify_bare_pi_overlap "$@"; }
_fm_composer_pi_verdict() { _agent_input_pi_verdict "$@"; }
