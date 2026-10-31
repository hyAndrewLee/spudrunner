# Focused test fixture repair

Phase completed 2026-10-31 09:10:18 UTC, within the authorized focused budget. HEAD remains d7f97cf70bdb76b9037976819abf4cb52fd45ab1; only tests/extension-host-binding.test.sh is modified. No commit, pipeline operation, children, production edit, lint, installation, or publication was performed. The outer executor owns committing and independent Test.

## Reproduction and cause

Both complete focused segments ran first using exactly the authorized outer timeout form:

```
E=/home/andrew/.no-mistakes-spudrunner-validation/evidence/01M686RRNB95JSFM1P5TBWQ3YY
timeout -k 10 110 bash "$E/round8-run-isolated.sh" env FM_EXTENSION_BINDING_SEGMENT=lifecycle-lock bash -x tests/extension-host-binding.test.sh
timeout -k 10 110 bash "$E/round8-run-isolated.sh" env FM_EXTENSION_BINDING_SEGMENT=lifecycle-state bash -x tests/extension-host-binding.test.sh
```

fix14-lock-before.log: exit 0. Restoring historical timeout topology resolves the previously diagnosed namespace zombie problem without changing production. Wrapper SHA256 remains 500d6509689614813c899a3bcb696113142d41a8a5d306a085ad2ab43d9a82f9.

fix14-state-before.log: exit 1 at the reported dead overridden-state claim assertion. The fixture reconciles the default state instead of the claim's recorded override. Existing state-root isolation requires preserving that foreign claim.

## Changes and proof

Lock fixture records actual /proc/1 stat/cmdline and worker stat/cmdline, asserts the worker's starttime equals the lifecycle lock's pid-start, then requires positive-PID signal-0 failure and proc disappearance within the existing 400 x .005 polling bound after SIGKILL. An ignored wait is no longer evidence of worker reaping.

State fixture snapshots raw claim, source registration, binding, old-token reservation and default-root decoy; logs their base64 bytes and SHA256. It checks live PID/token/full Linux identity, recorded source inode/device, and state-root inode/device/uid/mode before killing the actual owner group. It requires leader and group signal-0 failure plus leader proc disappearance before reconciliation. Default-root reconcile must preserve exact original bytes. Matching-root reconcile must remove old-token reservations only, preserve the decoy and an unrelated schema-valid reservation fixture, and validate any replacement claim against real process identity, new PID/token/identity, source registration and recorded state root. The unrelated reservation is a deliberately constructed schema-valid different-generation record, not a claimed second live runner. Replacement cleanup uses public retire with the captured exact registration owner.

An initial attempt to create a second live reservation via public register while result.silent was blocked timed out on the shared lifecycle lock (fix14-state-after.log, exit 124). That fixture approach was removed, not retained as a fallback. fix14-state-generation.log (exit 1) exposed a checker mistake: claim reg-id identifies the source file, not its directory; the checker now verifies the source file's actual stat.

fix14-state-owned.log and fix14-state-adjacent.log (exit 1) reached a previously blocked adjacent registry race assertion. The exact emitted diagnostic is `error: cannot establish the source launch boundary: registry-race-source`. Existing public external start requires the launch-ready marker at the registered pathname after capture; swapping that pathname refuses, rather than succeeding merely because capture holds descriptors. Corrected this mechanical expectation to require exit 1 and that exact diagnostic, unchanged registration/binding bytes, and no entries in the substituted outside directory. No arbitrary nonzero is accepted; all later inbox, registry, leaf, publication and compatibility checks remain active. fix14-state-registry.log then passed the full state segment.

## Final focused verification

Same exact two commands above ran once each against final test bytes, sequentially with unchanged wrapper/limits/isolation:

- fix14-final-lock.log: exit 0.
- fix14-final-state.log: exit 0, including both negative and positive state recovery, replacement identity validation, public exact-owner cleanup, and subsequent safety cases.
- fix14-final-hashes.log binds final extension test SHA256 d06cbf0f31cbfdbfe6f21d5eea3ed9c59e58726b86402c49ee94678fbaf9f251 and unchanged remote-reply test SHA256 3b028f6f279132eb486f8b0545d258dac07a1a369c72bceb1ca61eeb966e3f39.

No transient working-tree artifacts remain; git status lists only the intentional test edit. No full suite or other phase ran. This is focused fixer verification, not independent Test approval. The outer executor must bind subsequent independent Test and parent review to its final committed tree; historical remote-reply readiness remains unproven here.
