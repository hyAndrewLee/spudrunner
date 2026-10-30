#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/publication-authority-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/publication-authority-lib.sh" "$@"
fi
# shellcheck source=bin/publication-authority-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/publication-authority-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_role_file() { role_file "$@"; }
fm_role_inherit_receipt() { role_inherit_receipt "$@"; }
fm_role_scope_valid() { role_scope_valid "$@"; }
fm_role_scope_norm() { role_scope_norm "$@"; }
fm_role_abs_norm() { role_abs_norm "$@"; }
fm_role_local_identity() { role_local_identity "$@"; }
fm_role_path_identity() { role_path_identity "$@"; }
fm_role_remote_identity() { role_remote_identity "$@"; }
fm_role_git_common_dir() { role_git_common_dir "$@"; }
fm_role_publication_target() { role_publication_target "$@"; }
fm_role_shallow() { role_shallow "$@"; }
fm_role_self_repo() { role_self_repo "$@"; }
fm_role_parse_file() { role_parse_file "$@"; }
fm_role_sha256_stdin() { role_sha256_stdin "$@"; }
fm_role_inherit_check() { role_inherit_check "$@"; }
fm_role_resolve() { role_resolve "$@"; }
fm_role_inherit_payload() { role_inherit_payload "$@"; }
fm_role_gate_self_publish() { role_gate_self_publish "$@"; }
