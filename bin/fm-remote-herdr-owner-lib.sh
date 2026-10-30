#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/remote-herdr-owner-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/remote-herdr-owner-lib.sh" "$@"
fi
# shellcheck source=bin/remote-herdr-owner-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/remote-herdr-owner-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_remote_herdr_socket_owner() { remote_herdr_socket_owner "$@"; }
fm_remote_herdr_process_env() { remote_herdr_process_env "$@"; }
fm_remote_herdr_process_ancestry() { remote_herdr_process_ancestry "$@"; }
fm_remote_herdr_gui_job_proves_owner() { remote_herdr_gui_job_proves_owner "$@"; }
fm_remote_herdr_gui_job_is_exclusive() { remote_herdr_gui_job_is_exclusive "$@"; }
fm_remote_herdr_owner_birth() { remote_herdr_owner_birth "$@"; }
fm_remote_herdr_ancestry_has_ssh_origin() { remote_herdr_ancestry_has_ssh_origin "$@"; }
fm_remote_herdr_birth_is_aqua() { remote_herdr_birth_is_aqua "$@"; }
