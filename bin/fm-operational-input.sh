#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/operational-input.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/operational-input.sh" "$@"
fi
# shellcheck source=bin/operational-input.sh
. "$(dirname "${BASH_SOURCE[0]}")/operational-input.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_operational_kind_is_current() { operational_kind_is_current "$@"; }
fm_operational_input_encode() { operational_input_encode "$@"; }
fm_operational_input_construct() { operational_input_construct "$@"; }
fm_operational_generic_kind() { operational_generic_kind "$@"; }
fm_operational_input_kind() { operational_input_kind "$@"; }
fm_operational_input_body() { operational_input_body "$@"; }
fm_legacy_operational_input_kind() { legacy_operational_input_kind "$@"; }
fm_operational_input_classify() { operational_input_classify "$@"; }
fm_message_from_firstmate() { message_from_coordinator "$@"; }
fm_message_mark_from_firstmate() { message_mark_from_coordinator "$@"; }
fm_operational_harness_needs_record() { operational_harness_needs_record "$@"; }
fm_operational_record_prune() { operational_record_prune "$@"; }
fm_operational_record_write() { operational_record_write "$@"; }
fm_operational_doorbell_path() { operational_doorbell_path "$@"; }
fm_operational_record_kind() { operational_record_kind "$@"; }
fm_operational_doorbell_record_kind() { operational_doorbell_record_kind "$@"; }
fm_operational_doorbell_kind() { operational_doorbell_kind "$@"; }
fm_operational_home_state() { operational_home_state "$@"; }
fm_operational_read_stdin() { operational_read_stdin "$@"; }
fm_operational_usage() { operational_usage "$@"; }
fm_operational_main() { operational_main "$@"; }
