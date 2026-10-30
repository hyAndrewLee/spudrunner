#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/public-followup-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/public-followup-lib.sh" "$@"
fi
# shellcheck source=bin/public-followup-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/public-followup-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_pf_relay_active() { public_followup_relay_active "$@"; }
fm_pf_root() { public_followup_root "$@"; }
fm_pf_registry_dir() { public_followup_registry_dir "$@"; }
fm_pf_events_dir() { public_followup_events_dir "$@"; }
fm_pf_outbox_dir() { public_followup_outbox_dir "$@"; }
fm_pf_consumed_dir() { public_followup_consumed_dir "$@"; }
fm_pf_rejected_dir() { public_followup_rejected_dir "$@"; }
fm_pf_rejection_wakes_dir() { public_followup_rejection_wakes_dir "$@"; }
fm_pf_retired_dir() { public_followup_retired_dir "$@"; }
fm_pf_retirement_receipt_exists() { public_followup_retirement_receipt_exists "$@"; }
fm_pf_dir_has_entry() { public_followup_dir_has_entry "$@"; }
fm_pf_has_registrations() { public_followup_has_registrations "$@"; }
fm_pf_has_events() { public_followup_has_events "$@"; }
fm_pf_has_open_loops() { public_followup_has_open_loops "$@"; }
fm_pf_active() { public_followup_active "$@"; }
fm_pf_slug_valid() { public_followup_slug_valid "$@"; }
fm_pf_home_id_valid() { public_followup_home_id_valid "$@"; }
fm_pf_sha256() { public_followup_sha256 "$@"; }
fm_pf_event_id() { public_followup_event_id "$@"; }
fm_pf_clean_outcome_text() { public_followup_clean_outcome_text "$@"; }
fm_pf_bound_bytes() { public_followup_bound_bytes "$@"; }
fm_pf_deliverable_format() { public_followup_deliverable_format "$@"; }
fm_pf_deliverable_key_valid() { public_followup_deliverable_key_valid "$@"; }
fm_pf_expected_outcome() { public_followup_expected_outcome "$@"; }
fm_pf_deliverable_keys() { public_followup_deliverable_keys "$@"; }
fm_pf_pr_url_valid() { public_followup_pr_url_valid "$@"; }
fm_pf_deliverable_problem() { public_followup_deliverable_problem "$@"; }
fm_pf_obligation_json() { public_followup_obligation_json "$@"; }
fm_pf_registry_get() { public_followup_registry_get "$@"; }
fm_pf_registry_ids() { public_followup_registry_ids "$@"; }
fm_pf_registry_ids_for_work() { public_followup_registry_ids_for_work "$@"; }
fm_pf_now_epoch() { public_followup_now_epoch "$@"; }
fm_pf_now_rfc3339() { public_followup_now_rfc3339 "$@"; }
fm_pf_rfc3339_to_epoch() { public_followup_rfc3339_to_epoch "$@"; }
fm_pf_followup_window_class() { public_followup_followup_window_class "$@"; }
fm_pf_b64_encode() { public_followup_b64_encode "$@"; }
fm_pf_b64_decode() { public_followup_b64_decode "$@"; }
fm_pf_registry_loop_state() { public_followup_registry_loop_state "$@"; }
fm_pf_registry_rechainable() { public_followup_registry_rechainable "$@"; }
fm_pf_has_delivered_open_loops() { public_followup_has_delivered_open_loops "$@"; }
fm_pf_registry_lock_path() { public_followup_registry_lock_path "$@"; }
fm_pf_registry_lock_acquire() { public_followup_registry_lock_acquire "$@"; }
fm_pf_registry_lock_release() { public_followup_registry_lock_release "$@"; }
fm_pf_registry_stamp_delivered() { public_followup_registry_stamp_delivered "$@"; }
fm_pf_events_signature() { public_followup_events_signature "$@"; }
