#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/worker-account-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/worker-account-lib.sh" "$@"
fi
# shellcheck source=bin/worker-account-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/worker-account-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_worker_account_file() { worker_account_file "$@"; }
fm_worker_account_read() { worker_account_read "$@"; }
fm_worker_account_config() { worker_account_config "$@"; }
fm_worker_account_resolve() { worker_account_resolve "$@"; }
fm_worker_account_pi_provider() { worker_account_pi_provider "$@"; }
fm_worker_account_check() { worker_account_check "$@"; }
fm_worker_account_select() { worker_account_select "$@"; }
fm_worker_account_claude_shed() { worker_account_claude_shed "$@"; }
