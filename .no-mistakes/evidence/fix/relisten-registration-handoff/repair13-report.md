# Assigned test-fix phase: blocked after authorized fixture corrections

Base HEAD remains 6436bedbf34350349184205154731fc2cc88682e; changes are uncommitted for the outer executor. Only tests/extension-host-binding.test.sh and diagnostic-only tests/remote-reply.test.sh changed. No production, configuration, refs, pipeline controls, children, publication, lint, formatting, or static-analysis commands were used.

## Reproduction and verification

Every execution used the unchanged round8-run-isolated.sh wrapper, SHA256 500d6509689614813c899a3bcb696113142d41a8a5d306a085ad2ab43d9a82f9, from this evidence directory. Each command was:

```sh
FM_EXTENSION_BINDING_SEGMENT=lifecycle-state timeout -k 10 110 bash "$E/round8-run-isolated.sh" bash -x tests/extension-host-binding.test.sh
```

Chronological logs, all exit 1:

- repair13-before-state.log: reproduced original newline registration fixture failure, exact private-directory refusal at lines 592-595.
- repair13-after-state.log: corrected tab/start and newline/register refusal cases both pass, including exact diagnostic, directory identity/mode/UID/GID preservation, registration-byte preservation for tab, absent registration for newline, decoy-byte preservation, absent claim/reservation/poll/capture/runner. Newly reached crash fixture expects two reservations but observes one.
- repair13-final-state.log: instrumented serialized reservation JSON proves the remaining record is result.terminal with matching source/claim PID/token. An intermediate assertion incorrectly hypothesized result.silent remained and failed. That hypothesis was disproven by the actual record, not accepted as a pass.
- repair13-verified-state.log: final correction requires exactly one pending result.terminal record with exact source, PID and claim token. This assertion and both control-byte cases pass. Next failure: `reconcile retained a dead overridden-state claim`, after group SIGKILL, waiting for public start, then public reconcile.

The reservation-count correction is the authorized adjacent mechanical fixture mismatch: result.silent consumes its own reservation before the blocking fixture handshake; the pending terminal record remains. It now asserts the concrete persisted record's operation/source/owner instead of only counting two nonexistent immediate reservations.

## Remaining blocker and stop boundary

No-go: full lifecycle-state is not green. The cause of reconcile retaining the killed runner's claim has NOT been established. Existing production deliberately preserves stale claims when the process group still has members; that is only a possible explanation, not observed proof of this failure. No cleanup workaround, retry loop, safety concession or production change was made. Later inbox/registry cases remain unverified. Lifecycle-lock was not rerun after this failure, nor were dependent process-events, remote-reply, remote-delta or extension safety checks. All test fixture temporary directories were removed by existing cleanup; git status lists only the two intentional test changes.

The remote-reply change adds bounded existing reply_diagnostics, barrier sequence/ready/ready.tmp presence and content, and recorded owner PID liveness before the unchanged readiness failure. It has not been executed because the focused prerequisite remains red. Historical readiness cause remains UNKNOWN.

Final file SHA256:

- tests/extension-host-binding.test.sh: 0cae6ecaa9d470e8589681c02c7e2e67cc6367b463cabecc8db87b8853da3b5b
- tests/remote-reply.test.sh: 3b028f6f279132eb486f8b0545d258dac07a1a369c72bceb1ca61eeb966e3f39

Outer executor owns any next diagnosis, commit, subsequent phases and verdict. This report is not approval of the full test phase.
