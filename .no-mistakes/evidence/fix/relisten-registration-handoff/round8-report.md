# Active external poll registration refusal repair

Before: `6c05bca9362dc80e1ead7461d4eb348935e95c80`.
After: `7c55cdb47a4716a04f04b7e4b829178d2b52176c`.
Baseline production: `e1846c7ba5c06a894673f7c7f85f9cc925b7f86b`.
Patch: `round8-fix.patch`; exact tool paths and versions: `round8-provenance.log`.
This delta requires parent review; the earlier review does not cover it.

## Diagnosis and fix

Trigger: public register-extension attempts replacement while an external poll is active.
Masking condition: without a live poll, lifecycle acquisition completes and the existing ownership refusal helper is reachable.
Symptom: registration hangs instead of returning its ownership refusal.
Verified cmd_register_extension acquired the source lock then waited on lifecycle before checking ownership; cmd_extension_process_event holds lifecycle throughout its exec into the host/poll.
The existing cmd_register path checks the same ownership helper under the source lock without lifecycle acquisition.
Both unchanged baseline and target reproduced the timeout before editing.
Earlier retained round7-active-target-lock-trace.log records actual lifecycle acquisition waiting; round8-baseline-active.log and round8-target-before.log reproduce the unchanged public scenario reaching active poll readiness and blocking replacement.

Added only an early refusal using the existing helper, under the continuously held source lock.
It cannot authorize publication: the existing later helper, binding resolution/validation, task ownership check, and publication remain unchanged under both locks.
No release/reacquire gap was introduced; concurrent public claim/registration mutations use the same source lock.
Lifecycle serialization implementation is untouched.
The existing scenario now passes without any release timer or changed bound.
Strengthened it to compare serialized live registration, claim, runner and poll marker against originals before releasing the poll, and verify the original runner remains alive.
The scenario then releases the poll explicitly, waits for terminal completion and exercises safe built-in and extension replacements.
Actual runtime records and matching SHA-256 pairs are in round8-active-product-records.log.

## Exact targeted verification

All test executions used the saved round8-run-isolated.sh wrapper: configured pinned tool PATH, TMPDIR=/tmp, existing exclusive serial-tests.lock opened read-only, 4194304-KiB virtual-memory limit, 480-second CPU ceiling, and unshare --user --map-current-user --pid --fork --mount-proc.
Commands below used `bash .validation-tmp/run-isolated.sh` as WRAPPER.
Baseline copied bin/ into worktree-local .validation-tmp/base/bin, substituted only process-events.sh via git show of the baseline, and copied the unchanged extension test to tests/active-baseline-driver.sh with only PROCEVENT pointing at that local baseline runner.
No external clone or bare repository files were opened directly.

- Before edits: `FM_EXTENSION_BINDING_SEGMENT=lifecycle-runner timeout -k 10 80 WRAPPER bash -x tests/active-baseline-driver.sh`: 124; round8-baseline-active.log.
- Before edits: same command with tests/extension-host-binding.test.sh: 124; round8-target-before.log.
- After production fix, before test strengthening: identical unchanged target command and 80-second bound: 0; round8-target-after-unchanged.log.
- After strengthening: identical target command: 0; round8-lifecycle-runner.log.
- Evidence-only driver, same 80-second bound, prints actual persisted records before releasing poll: 0; round8-active-product-records.log. Saved as round8-active-evidence-driver.sh.
- `timeout -k 10 650 WRAPPER bash tests/process-events.test.sh`: 0; round8-process-events.log. Includes torn-claim snapshot, serialized start/retirement, cross-home ownership, descendant and orphan checks.
- `timeout -k 10 360 WRAPPER bash tests/remote-reply.test.sh`: 0; round8-remote-reply.log. Includes deterministic same-owner plain/NUL handoffs and changed-command/adapter, missing-registration, wrong home/PID/token and one-shot refusals.
- `timeout -k 5 120 WRAPPER bash tests/remote-delta-read.test.sh`: 0; round8-remote-delta.log.
- Extension sections use `FM_EXTENSION_BINDING_SEGMENT=SECTION timeout -k 10 110 WRAPPER bash tests/extension-host-binding.test.sh` (lifecycle-order and lifecycle-state initially used bash -x).
- lifecycle-order: 0; concurrent register/reconcile completes with coherent locking and owner-matched retirement.
- early-integrity: 0; invalid package/binding refusal checks.
- early-validation: 0.

## Additional existing failures, not waived

The following focused lifecycle checks fail identically with target and baseline production. They were not repaired because they are outside the authorized active-poll refusal defect, and their failures are not presented as green:

- lifecycle-state: 1, after passing stale/current generation retirement and capture-authority checks. Control-tab fixture expects 'cannot acquire source ownership', actual diagnostic is 'cannot claim source'. See round8-lifecycle-state.log and round8-baseline-lifecycle-state.log.
- lifecycle-lock: 1, after passing registration/retirement publication serialization and process-event resolution reservation. Fails 'binding retirement bypassed result.classify lifecycle reservation'. See round8-lifecycle-lock.log and round8-baseline-lifecycle-lock.log.
- lifecycle-flow: 1, after passing full external capture/classify/terminal retirement, inner host crash recovery and invalid/retired binding refusal. Later expects process-cleanup-failed but receives schema-invalid group_pid must be >=2 in this PID namespace. See round8-lifecycle-flow.log and round8-baseline-lifecycle-flow.log.

Baseline comparisons used the same per-section commands, bounds and namespace, replacing only the test path with tests/active-baseline-driver.sh.
These limitations mean this report is not a claim that every relevant lifecycle check passes; outer executor owns disposition and broad CI.

## Cleanup and boundaries

Removed .validation-tmp and temporary test drivers after verification.
Only the two intentional tracked files changed; worktree clean after scoped commit.
No dependencies removed, no new children, lint/format/static-analysis, full repository suite, pipeline controls, publication, configuration mutation or merge performed.
