# Test-only repair: blocked

HEAD remains 7c55cdb47a4716a04f04b7e4b829178d2b52176c; no commit or pipeline control was performed.
Only tests/extension-host-binding.test.sh changed; final Git blob identity is 3e812132fd9f71e2f811cf119b41ddaa97000c3c.
The exact patch is repair-tests.patch beside this report.

## Commands and retained attempts

E=/home/andrew/.no-mistakes-spudrunner-validation/evidence/01M686RRNB95JSFM1P5TBWQ3YY

Every execution used this exact command, sequentially, with segment substituted as listed:

FM_EXTENSION_BINDING_SEGMENT="$segment" /usr/bin/timeout -k 10 110 /usr/bin/bash "$E/round8-run-isolated.sh" /usr/bin/bash -x tests/extension-host-binding.test.sh

The existing unchanged wrapper read-opens the exclusive shared serial-tests.lock, pins PATH to /home/andrew/spudrunner-green/tools:/home/andrew/.nvm/versions/node/v22.23.3/bin:$PATH, sets TMPDIR=/tmp, limits virtual memory to 4194304 KiB and CPU to 480 seconds, and executes unshare --user --map-current-user --pid --fork --mount-proc.
No bypass variables were supplied, no bounds changed, and no children or broad suites were launched.

- repair-before-lifecycle-lock.log: exit 1, reproduced premature retirement assertion after classification.
- repair-before-lifecycle-state.log: exit 1, reproduced expected ownership-diagnostic mismatch for tab state root.
- repair-after-lifecycle-lock.log: exit 1, failed snapshot setup used result.extension instead of the actual sibling .extension sidecar; corrected naming.
- repair-verified-lifecycle-lock.log: exit 1, an overly restrictive new expectation incorrectly required terminal invocation failure; executable host semantics encode terminal true as exit 0 and silent false as exit 1, with empty output. Corrected assertions require those actual verdicts and reject diagnostic output.
- repair-final-lifecycle-lock.log: exit 0, all existing lifecycle-lock cases passed with real unreleased handshakes, operation liveness, retirement ordering, byte comparisons, no handled marker, explicit classification success, and exact-owner cleanup.
- repair-final-lifecycle-state.log: exit 1, tab refusal passed all strengthened integrity assertions; newline registration failed before any source could be snapshotted.
- repair-blocked-lifecycle-state.log: exit 1, repeated only the focused failing segment after making fixture setup fail immediately; exact blocker is `error: process-event state root is not a private directory`, followed by `not ok - control-byte registration fixture failed: newline`.

## Root cause and scope

Removing the premature process_race_release clear preserves its actual pathname so each result-operation iteration removes the old release file and establishes a real active reservation.
The tab-root diagnostic expectation now matches the specific existing `cannot claim source: <source>` refusal, retaining claim/reservation checks and strengthening source/decoy byte integrity, private poll sentinel, and absent capture assertions.
The newline case was previously unreachable and now demonstrably fails during register, not claim acquisition; no registration exists to snapshot.
Per the explicit stop boundary, no production fix, assertion relaxation, or further validation expansion was attempted.
Both focused segments have NOT passed, so subsequent remote-reply/process-events/remote-delta/extension-safety runs were not authorized by the prescribed execution order and were not run.
Historical handoff-readiness causality remains unknown; no speculative synchronization or optional diagnostics were added.
No resulting committed SHA or green verdict is claimed.

The final fixture fail-fast change was reverified in lifecycle-state only; lifecycle-lock bytes were unchanged after their passing run.
Git status contains only the intentional test-file modification; disposable test homes were removed by the tests' cleanup.
No linters, formatters, static analysis, publication, installation, or global configuration changes occurred.
