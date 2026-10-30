#!/usr/bin/env bash
# Fresh-machine setup plans, validation, and repeatable configuration without
# touching the operator's package managers, shell configuration, or credentials.
set -eu
# shellcheck source=tests/lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
TMP_ROOT=$(test_tmproot spudrunner-setup)
HOME="$TMP_ROOT/home with spaces"
export HOME
mkdir -p "$HOME" "$TMP_ROOT/fakebin" "$TMP_ROOT/checkout/bin"
cp "$ROOT/bin/setup.sh" "$TMP_ROOT/checkout/bin/setup.sh"
SETUP="$TMP_ROOT/checkout/bin/setup.sh"
LOG="$TMP_ROOT/commands"
export LOG
for tool in apt-get sudo brew; do
  cat > "$TMP_ROOT/fakebin/$tool" <<'SH'
#!/usr/bin/env bash
printf '%s\n' "${0##*/} $*" >> "$LOG"
SH
done
# uname -m must still report a supported architecture.
cat > "$TMP_ROOT/fakebin/uname" <<'SH'
#!/usr/bin/env bash
case "$1" in -s) echo "${SETUP_TEST_OS:-Linux}" ;; -m) echo x86_64 ;; esac
SH
# Existing tool installations are reused, never upgraded behind the user's back.
for tool in node npm pi claude codex gh-axi chrome-devtools-axi lavish-axi tasks-axi quota-axi treehouse herdr shellcheck actionlint no-mistakes; do
  cat > "$TMP_ROOT/fakebin/$tool" <<'SH'
#!/usr/bin/env bash
case "${1:-}" in -p) echo 22 ;; *) echo "unexpected tool execution: $0 $*" >> "$LOG"; exit 1 ;; esac
SH
done
chmod +x "$TMP_ROOT/fakebin/"*
export PATH="$TMP_ROOT/fakebin:$PATH"

out=$(bash "$SETUP" --dry-run)
assert_contains "$out" 'apt-get install' 'Linux plan omitted system prerequisites'
assert_contains "$out" 'present: pi' 'the default plan omitted Pi'
assert_contains "$out" 'present: claude' 'the default plan omitted Claude'
assert_contains "$out" 'present: codex' 'the default plan omitted Codex'
assert_absent "$LOG" 'dry-run executed a package manager'
assert_absent "$HOME/.config" 'dry-run wrote user configuration'
assert_absent "$TMP_ROOT/checkout/config" 'dry-run wrote project configuration'
pass 'dry-run describes the complete default installation without mutations'

out=$(SETUP_TEST_OS=Darwin bash "$SETUP" --dry-run --harnesses codex --backend herdr)
assert_contains "$out" 'brew install' 'macOS plan omitted Homebrew prerequisites'
assert_not_contains "$out" 'present: pi' 'explicit harness selection installed Pi'
pass 'macOS and explicit harness selection have their own installation plan'

for args in '--backend unknown' '--harnesses pi,unknown' '--harnesses pi,' '--harnesses ,pi' '--harnesses pi,,codex' '--backend' '--wat'; do
  rc=0
  # shellcheck disable=SC2086 # Deliberately pass each invalid argument vector.
  bash "$SETUP" $args > "$TMP_ROOT/error" 2>&1 || rc=$?
  [ "$rc" -ne 0 ] || fail "invalid arguments accepted: $args"
done
assert_absent "$LOG" 'invalid input invoked a package manager'
pass 'invalid input fails before installation'

bash "$SETUP" --backend herdr > "$TMP_ROOT/installed"
assert_grep 'apt-get' "$LOG" 'real mode did not invoke the system package manager'
[ "$(cat "$TMP_ROOT/checkout/config/backend")" = herdr ] || fail 'backend not initialized'
assert_present "$HOME/.config/spudrunner/env.sh" 'environment file missing'
assert_absent "$HOME/.bashrc" 'setup edited the user shell rc'
assert_absent "$HOME/.pi" 'setup copied global agent settings'
assert_absent "$HOME/.claude" 'setup copied credentials or Claude settings'
PATH_BEFORE=$PATH
# shellcheck source=/dev/null
. "$HOME/.config/spudrunner/env.sh"
case "$PATH" in *"$HOME/.local/share/spudrunner/npm/bin"*) ;; *) fail 'environment omitted npm executables' ;; esac
PATH=$PATH_BEFORE
printf 'tmux\n' > "$TMP_ROOT/checkout/config/backend"
bash "$SETUP" --backend herdr > "$TMP_ROOT/repeated"
[ "$(cat "$TMP_ROOT/checkout/config/backend")" = tmux ] || fail 'repeat setup overwrote private configuration'
assert_not_contains "$(cat "$LOG")" 'unexpected tool execution' 'setup ran an existing harness or modified tool state'
pass 'setup initializes a home, supports spaces, and preserves existing private settings on repeat runs'

# Exercise a genuinely missing harness using only fixture and system commands.
rm "$TMP_ROOT/fakebin/pi"
cat > "$TMP_ROOT/fakebin/npm" <<'SH'
#!/usr/bin/env bash
set -eu
printf '%s\n' "npm $*" >> "$LOG"
[ "${SETUP_TEST_NPM_FAIL:-0}" -eq 0 ] || exit 17
while [ "$#" -gt 0 ]; do
  if [ "$1" = --prefix ]; then prefix=$2; break; fi
  shift
done
mkdir -p "$prefix/bin"
printf '#!/usr/bin/env bash\nexit 0\n' > "$prefix/bin/pi"
chmod +x "$prefix/bin/pi"
SH
chmod +x "$TMP_ROOT/fakebin/npm"
PATH="$TMP_ROOT/fakebin:/usr/bin:/bin" bash "$SETUP" --harnesses pi > "$TMP_ROOT/npm-install"
assert_present "$HOME/.local/share/spudrunner/npm/bin/pi" 'missing harness was not installed user-locally'
assert_grep '@earendil-works/pi-coding-agent' "$LOG" 'Pi package was not selected'
rc=0
HOME="$TMP_ROOT/failed-home" SETUP_TEST_NPM_FAIL=1 PATH="$TMP_ROOT/fakebin:/usr/bin:/bin" \
  bash "$SETUP" --harnesses pi > "$TMP_ROOT/npm-failure" 2>&1 || rc=$?
[ "$rc" -eq 17 ] || fail "npm failure was hidden (exit $rc)"
assert_absent "$TMP_ROOT/failed-home/.config/spudrunner/env.sh" 'failed installation reported completed configuration'
pass 'missing harnesses use a local npm prefix and installer failures propagate'
echo FM_TEST_COMPLETE
