#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/agent-control-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/agent-control-lib.sh" "$@"
fi
# shellcheck source=bin/agent-control-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/agent-control-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_control_verbs() { agent_control_verbs "$@"; }
fm_control_verb_allowed() { agent_control_verb_allowed "$@"; }
fm_control_harnesses() { agent_control_harnesses "$@"; }
fm_control_harness_supported() { agent_control_harness_supported "$@"; }
fm_control_harness_family() { agent_control_harness_family "$@"; }
fm_control_harness_supports_kind() { agent_control_harness_supports_kind "$@"; }
fm_control_interrupt_transport() { agent_control_interrupt_transport "$@"; }
fm_control_interrupt_key() { agent_control_interrupt_key "$@"; }
fm_control_interrupt_repeat() { agent_control_interrupt_repeat "$@"; }
fm_control_interrupt_arm_signal() { agent_control_interrupt_arm_signal "$@"; }
fm_control_interrupt_press_gap() { agent_control_interrupt_press_gap "$@"; }
fm_control_interrupt_hazard_signal() { agent_control_interrupt_hazard_signal "$@"; }
fm_control_interrupt_clear_key() { agent_control_interrupt_clear_key "$@"; }
fm_control_interrupt_ack_source() { agent_control_interrupt_ack_source "$@"; }
fm_control_exit_command() { agent_control_exit_command "$@"; }
fm_control_relaunch_resume_flag() { agent_control_relaunch_resume_flag "$@"; }
fm_control_backend_supports_key() { agent_control_backend_supports_key "$@"; }
fm_control_backend_state_verified() { agent_control_backend_state_verified "$@"; }
fm_control_backend_exit_supported() { agent_control_backend_exit_supported "$@"; }
fm_control_backend_relaunch_supported() { agent_control_backend_relaunch_supported "$@"; }
fm_control_absence_recheck_applies() { agent_control_absence_recheck_applies "$@"; }
fm_control_endpoint_absence_verdict() { agent_control_endpoint_absence_verdict "$@"; }
fm_control_harness_wiring_paths() { agent_control_harness_wiring_paths "$@"; }
fm_control_harness_wiring_dirs() { agent_control_harness_wiring_dirs "$@"; }
fm_control_harness_turnend_token_path() { agent_control_harness_turnend_token_path "$@"; }
fm_control_harness_turnend_auth_path() { agent_control_harness_turnend_auth_path "$@"; }
