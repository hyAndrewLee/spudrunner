#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/pr-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/pr-lib.sh" "$@"
fi
# shellcheck source=bin/pr-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/pr-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_task_id_path_safe() { task_id_path_safe "$@"; }
fm_pr_task_id_valid() { pr_task_id_valid "$@"; }
fm_task_id_creation_valid() { task_id_creation_valid "$@"; }
fm_pr_forge_host_valid() { pr_forge_host_valid "$@"; }
fm_pr_gitlab_path_valid() { pr_gitlab_path_valid "$@"; }
fm_pr_gerrit_path_valid() { pr_gerrit_path_valid "$@"; }
fm_pr_forgejo_segment_valid() { pr_forgejo_segment_valid "$@"; }
fm_github_host_allowed() { github_host_allowed "$@"; }
fm_pr_github_host_export() { pr_github_host_export "$@"; }
fm_pr_url_parse() { pr_url_parse "$@"; }
fm_pr_head_valid() { pr_head_valid "$@"; }
fm_pr_number_from_branch() { pr_number_from_branch "$@"; }
fm_pr_json_draft_state() { pr_json_draft_state "$@"; }
fm_pr_file_mode() { pr_file_mode "$@"; }
fm_pr_file_device() { pr_file_device "$@"; }
fm_pr_file_link_count() { pr_file_link_count "$@"; }
fm_pr_file_inode() { pr_file_inode "$@"; }
fm_pr_file_identity() { pr_file_identity "$@"; }
fm_pr_sha256() { pr_sha256 "$@"; }
fm_pr_private_file_valid() { pr_private_file_valid "$@"; }
fm_pr_regular_destination_or_absent() { pr_regular_destination_or_absent "$@"; }
fm_pr_regular_destination_on_device_or_absent() { pr_regular_destination_on_device_or_absent "$@"; }
fm_pr_metadata_identity_parse() { pr_metadata_identity_parse "$@"; }
fm_pr_poll_data_parse() { pr_poll_data_parse "$@"; }
fm_pr_poll_registration_parse() { pr_poll_registration_parse "$@"; }
fm_pr_poll_cleanup() { pr_poll_cleanup "$@"; }
fm_pr_poll_revoke_final() { pr_poll_revoke_final "$@"; }
fm_pr_poll_prepare() { pr_poll_prepare "$@"; }
fm_pr_poll_publish_prepared() { pr_poll_publish_prepared "$@"; }
fm_pr_poll_artifacts_valid() { pr_poll_artifacts_valid "$@"; }
fm_pr_poll_artifacts_content_valid() { pr_poll_artifacts_content_valid "$@"; }
fm_pr_poll_registration_device_shifted() { pr_poll_registration_device_shifted "$@"; }
fm_pr_poll_registration_rerecord_device() { pr_poll_registration_rerecord_device "$@"; }
fm_pr_poll_snapshot_capture() { pr_poll_snapshot_capture "$@"; }
fm_pr_poll_snapshot_matches() { pr_poll_snapshot_matches "$@"; }
fm_pr_poll_retirement_parse() { pr_poll_retirement_parse "$@"; }
fm_pr_poll_retirement_receipt_valid() { pr_poll_retirement_receipt_valid "$@"; }
fm_pr_github_read_record_with_gh() { pr_github_read_record_with_gh "$@"; }
fm_pr_github_read_record_with_gh_axi() { pr_github_read_record_with_gh_axi "$@"; }
fm_pr_github_read_record() { pr_github_read_record "$@"; }
fm_pr_gitlab_read_record() { pr_gitlab_read_record "$@"; }
fm_pr_forgejo_login() { pr_forgejo_login "$@"; }
fm_pr_forgejo_read_record() { pr_forgejo_read_record "$@"; }
fm_pr_gerrit_read_change() { pr_gerrit_read_change "$@"; }
fm_pr_gerrit_read_record() { pr_gerrit_read_record "$@"; }
fm_pr_gerrit_read_revision() { pr_gerrit_read_revision "$@"; }
fm_pr_poll_retirement_data_valid() { pr_poll_retirement_data_valid "$@"; }
fm_pr_poll_retirement_registration_valid() { pr_poll_retirement_registration_valid "$@"; }
fm_pr_poll_retirement_check_valid() { pr_poll_retirement_check_valid "$@"; }
fm_pr_poll_retirement_state_valid() { pr_poll_retirement_state_valid "$@"; }
fm_pr_poll_retirement_remove_exact() { pr_poll_retirement_remove_exact "$@"; }
fm_pr_poll_retirement_discard_obsolete() { pr_poll_retirement_discard_obsolete "$@"; }
fm_pr_poll_retirement_publish() { pr_poll_retirement_publish "$@"; }
fm_pr_poll_retirement_recover_one() { pr_poll_retirement_recover_one "$@"; }
fm_pr_poll_retirement_recover_all() { pr_poll_retirement_recover_all "$@"; }
fm_pr_poll_merge_marker_matches() { pr_poll_merge_marker_matches "$@"; }
fm_pr_poll_merge_already_notified() { pr_poll_merge_already_notified "$@"; }
fm_pr_poll_merge_mark_notified() { pr_poll_merge_mark_notified "$@"; }
fm_pr_poll_merge_notified_remove() { pr_poll_merge_notified_remove "$@"; }
