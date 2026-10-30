#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/quota-axi-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/quota-axi-lib.sh" "$@"
fi
# shellcheck source=bin/quota-axi-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/quota-axi-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_quota_axi_version_compatible() { quota_axi_version_compatible "$@"; }
fm_quota_axi_compatible() { quota_axi_compatible "$@"; }
fm_quota_json_valid() { quota_json_valid "$@"; }
fm_quota_single_provider_table() { quota_single_provider_table "$@"; }
fm_quota_single_provider_for_harness() { quota_single_provider_for_harness "$@"; }
fm_quota_provider_for_harness() { quota_provider_for_harness "$@"; }
