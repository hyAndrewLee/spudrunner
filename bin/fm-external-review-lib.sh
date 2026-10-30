#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/external-review-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/external-review-lib.sh" "$@"
fi
# shellcheck source=bin/external-review-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/external-review-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_external_review_config_dir() { external_review_config_dir "$@"; }
fm_external_review_file_state() { external_review_file_state "$@"; }
fm_external_review_url_parse() { external_review_url_parse "$@"; }
fm_external_review_adapter_body() { external_review_adapter_body "$@"; }
fm_external_review_backup() { external_review_backup "$@"; }
fm_external_review_prefix_disjoint() { external_review_prefix_disjoint "$@"; }
fm_external_review_url_normalize() { external_review_url_normalize "$@"; }
fm_external_review_remote_urls() { external_review_remote_urls "$@"; }
