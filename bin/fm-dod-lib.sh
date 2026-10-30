#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/task-completion-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/task-completion-lib.sh" "$@"
fi
# shellcheck source=bin/task-completion-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/task-completion-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_brief_worker_policy() { brief_worker_policy "$@"; }
fm_brief_worker_role() { brief_worker_role "$@"; }
fm_mode_publishes() { delivery_mode_publishes "$@"; }
fm_forge_valid_for_mode() { forge_valid_for_mode "$@"; }
fm_pr_text_valid() { pr_text_valid "$@"; }
fm_ship_branch_prefix() { implementation_branch_prefix "$@"; }
fm_base_branch_valid() { base_branch_valid "$@"; }
fm_brief_base_branches() { brief_base_branches "$@"; }
fm_ship_rule_one() { implementation_rule_one "$@"; }
fm_brief_task_placeholders_present() { brief_task_placeholders_present "$@"; }
fm_brief_marked_captain_words() { brief_marked_user_words "$@"; }
fm_brief_intent_overlay() { brief_intent_overlay "$@"; }
fm_brief_task_content_valid() { brief_task_content_valid "$@"; }
fm_brief_intent_address_line() { brief_intent_address_line "$@"; }
fm_ask_user_escalation_block() { validation_ask_user_escalation_block "$@"; }
fm_nm_driving_block() { validation_driving_block "$@"; }
fm_gerrit_publish_block() { gerrit_publish_block "$@"; }
fm_dod_manual_pr_block() { task_completion_manual_pr_block "$@"; }
fm_dod_block() { task_completion_block "$@"; }
fm_dod_ref_contains() { task_completion_ref_contains "$@"; }
fm_dod_note_reports_ci_ready() { task_completion_note_reports_ci_ready "$@"; }
fm_dod_note_has_pr_reference() { task_completion_note_has_pr_reference "$@"; }
fm_dod_note_reports_published_change() { task_completion_note_reports_published_change "$@"; }
fm_dod_note_reports_uploaded_review() { task_completion_note_reports_uploaded_review "$@"; }
fm_dod_review_url_from_done_note() { task_completion_review_url_from_done_note "$@"; }
fm_dod_accept_external_review_done() { task_completion_accept_external_review_done "$@"; }
fm_dod_should_gate_ship_done() { task_completion_should_gate_implementation_done "$@"; }
fm_dod_pr_url_from_done_note() { task_completion_pr_url_from_done_note "$@"; }
fm_dod_meta_value() { task_completion_meta_value "$@"; }
fm_dod_local_done_head() { task_completion_local_done_head "$@"; }
fm_dod_pin_local_done_head() { task_completion_pin_local_done_head "$@"; }
fm_dod_forge_head_is_named_head() { task_completion_forge_head_is_named_head "$@"; }
fm_dod_recorded_pr_on_forge() { task_completion_recorded_pr_on_forge "$@"; }
fm_dod_gerrit_change_carries_head() { task_completion_gerrit_change_carries_head "$@"; }
fm_dod_nm_custody_returned() { task_completion_nm_custody_returned "$@"; }
fm_dod_named_head_reachable_outside_worktree() { task_completion_named_head_reachable_outside_worktree "$@"; }
fm_dod_accept_ship_done() { task_completion_accept_implementation_done "$@"; }
