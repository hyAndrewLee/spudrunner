# Independent targeted product validation

Validated HEAD c5f8861bbfc0ac30ff23db5c8a464daaa982234c. No tracked changes, children, pipeline controls, lint, publication, or CI operations performed. Final worktree is clean; disposable baseline archive removed.

## Environment and commands

E=/home/andrew/.no-mistakes-spudrunner-validation/evidence/01M686RRNB95JSFM1P5TBWQ3YY

Unchanged round8-run-isolated.sh SHA256: 500d6509689614813c899a3bcb696113142d41a8a5d306a085ad2ab43d9a82f9. This preserves UID/GID, shared read-open exclusive flock with 20-second acquisition bound, pinned tools/Node, TMPDIR and memory/CPU limits. Timeout remains OUTSIDE the namespace. No bypass/orphan-skip flags were supplied.

Exact targeted commands, each once, serially:

```sh
timeout -k 10 110 bash "$E/round8-run-isolated.sh" env FM_EXTENSION_BINDING_SEGMENT=lifecycle-lock bash -x tests/extension-host-binding.test.sh
timeout -k 10 110 bash "$E/round8-run-isolated.sh" env FM_EXTENSION_BINDING_SEGMENT=lifecycle-state bash -x tests/extension-host-binding.test.sh
timeout -k 10 300 bash "$E/round8-run-isolated.sh" env FM_TEST_EVIDENCE=1 bash tests/remote-reply.test.sh
timeout -k 10 110 bash "$E/round8-run-isolated.sh" bash tests/remote-delta-read.test.sh
timeout -k 10 110 bash "$E/round8-run-isolated.sh" env FM_EXTENSION_BINDING_SEGMENT=lifecycle-runner bash -x tests/extension-host-binding.test.sh
timeout -k 10 110 bash "$E/round8-run-isolated.sh" env EVIDENCE="$E" FM_EXTENSION_BINDING_SEGMENT=lifecycle-runner bash "$E/independent14-external-floor-driver.sh"
timeout -k 10 300 bash "$E/round8-run-isolated.sh" bash tests/process-events.test.sh
```

All seven commands exited 0. Corresponding independent14-*.log artifacts retain outputs. These execute real process-event runners, public registration/handler/reconcile interfaces, real extension host and disposable executable extension packages. Remote-reply uses an isolated local transport shim that executes the real remote entrypoint and delta reader; no real remote service or credentials were touched. No TUI or rendered UI is changed or exercised, so screenshots are not applicable.

## Observable results

- lifecycle-lock: Linux PID 1 stat/cmdline captured; namespace init is the test Bash. Exact recorded worker PID/starttime captured and checked; worker 4581 is proven absent/reaped before registration recovery. Live stopped-worker lock protection and interruption recovery pass.
- lifecycle-state: raw claim, registration, binding, reservations and decoy snapshots logged with hashes/base64. Runner/group 3622 proven absent before reconcile. Default-root reconcile preserves foreign-root bytes; matching-root reconcile clears old-token reservations, validates replacement process ownership and preserves unrelated-generation reservation and default-root decoy. Public exact-owner cleanup passes, as do subsequent registry/inbox/symlink and legacy safety cases.
- remote-reply: exact FIFO adoption/floor barriers replace same-command registrations through the public handler. Plain and NUL-bearing subsequent payloads are captured/handled by the same PID/token without fallback start or reconcile. Cursor, digest, normalization and replay assertions remain active. Changed command/adapter, missing source, wrong home/PID/token and one-shot adoption are refused.
- external active poll: all registration-owner transitions refuse while the prior runner is active. Separate floor-barrier driver replaces the registered inode; the external owner exits without polling or deleting the replacement. Raw PID/token/registration identities and absent poll marker are retained in independent14-external-floor-records.log. The driver is a private copy of the existing evidence driver with only its test-library path and output destination adjusted; product code is not substituted.
- public process-event and delta-reader scripts complete successfully, including stale live-group refusal and bounded listener/re-arm behavior.

## Baseline negative control

A disposable full archive of e1846c7ba5c06a894673f7c7f85f9cc925b7f86b was created under .validation-independent14 and removed at completion. First attempt ran current remote-reply regression from that archive and failed setup: remote-entrypoint refuses archive-local remote-delta-read.sh because it is not tracked at that path. This is NOT a product regression result.

Corrected independent14-baseline-driver.sh retains the current tracked handler/remote-entrypoint paths and uses the archived original process-events executable for all runner commands. Other relevant production libraries/handler bytes are unchanged between base and target. This narrow old-runner/new-regression control avoids the archive tracking failure; it is not represented as a full baseline-suite run.

```sh
timeout -k 10 110 bash "$E/round8-run-isolated.sh" bash "$E/independent14-baseline-driver.sh"
```

Exit 1: reaches handoff 5, replaces the adopted registration, then next plain-text result is absent, claim is gone, and assertion reports `the header-collision line was not captured`. See independent14-baseline-corrected.log. Current unmodified tracked regression passes both plain and NUL handoffs. No baseline failures are attributed to current product.

## Verdict

GO for this local Test phase. Previous lifecycle prerequisites and remote readiness failure do not reproduce with the authorized topology and corrected fixture. No production fixes or test edits were needed in this phase. Publication, new PR and hosted CI remain the outer executor's responsibility; this report does not claim those phases completed.
