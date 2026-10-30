#!/usr/bin/env bash
# Compatibility entrypoint for installed homes; use bin/credential-source-lib.sh.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  exec bash "$(dirname "${BASH_SOURCE[0]}")/credential-source-lib.sh" "$@"
fi
# shellcheck source=bin/credential-source-lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/credential-source-lib.sh" "$@"

# shellcheck disable=SC2329 # Legacy source-library API aliases.
fm_credsrc_supported() { credential_source_supported "$@"; }
fm_credsrc_check() { credential_source_check "$@"; }
fm_credsrc_declares() { credential_source_declares "$@"; }
fm_credsrc_field() { credential_source_field "$@"; }
fm_credsrc_read() { credential_source_read "$@"; }
fm_credsrc_macos_keychain() { credential_source_macos_keychain "$@"; }
