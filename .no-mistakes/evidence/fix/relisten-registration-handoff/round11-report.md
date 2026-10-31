# Independent Test: no-go

Exact tested and resulting HEAD: 6436bedbf34350349184205154731fc2cc88682e. No source/test changes or commits. Final git status --short was empty.

## Fresh execution

Sequentially executed, first lifecycle-lock then lifecycle-state:

```sh
E=/home/andrew/.no-mistakes-spudrunner-validation/evidence/01M686RRNB95JSFM1P5TBWQ3YY
FM_EXTENSION_BINDING_SEGMENT=lifecycle-lock timeout -k 10 110 bash "$E/round8-run-isolated.sh" bash -x tests/extension-host-binding.test.sh
FM_EXTENSION_BINDING_SEGMENT=lifecycle-state timeout -k 10 110 bash "$E/round8-run-isolated.sh" bash -x tests/extension-host-binding.test.sh
```

Output saved separately in round11-lifecycle-lock.log (exit 0) and round11-lifecycle-state.log (exit 1). Exact commands/exits are in round11-commands.log. Used the existing unchanged wrapper: read-open exclusive shared serial-tests.lock, pinned tools and Node PATH, TMPDIR=/tmp, virtual memory 4194304 KiB, CPU 480 seconds, unshare --user --map-current-user --pid --fork --mount-proc. No caller-supplied FM_TEST_ variables or bypasses. Environment observation through the same wrapper confirms UID/GID 1000, PID 1, Bash 5.0.17, Ruby 2.7.0p0, Node v22.23.3; full resolved tools and environment in round11-environment.log. Observation command: timeout -k 10 20 bash "$E/round8-run-isolated.sh" bash -c 'id; printf "pid=%s\nPATH=%s\nTMPDIR=%s\n" "$$" "$PATH" "$TMPDIR"; ulimit -v; ulimit -t; for tool in bash ruby node timeout unshare flock; do command -v "$tool"; done; bash --version | head -1; ruby --version; node --version' (exit 0).

## Observed product behavior

Real public extension host and process-event commands ran against test-created private homes, with disposable extension package fixtures. No Herdr, default session, real fleet data or credentials were used.

- Lifecycle-lock passes: real unreleased handshake and live operation before retirement; retirement stays waiting through classify/terminal/silent reservation, then refuses specifically for registered dependency. Binding, guard registration, captured result and extension sidecar bytes are compared unchanged, with no handled marker. Classification emits external-ready after explicit release. Exact-owner cleanup and lock recovery complete.
- Lifecycle-state reaches and passes stale-owner refusal, forged capture authority rejection and bounded reservation checks. Tab-root start refuses with the exact cannot-claim diagnostic; source and decoy bytes remain unchanged and no claim, reservation, poll sentinel or capture appears.
- Newline-root setup fails at public register, BEFORE start or source snapshot: `error: process-event state root is not a private directory`, followed by `not ok - control-byte registration fixture failed: newline` (trace lines 592-595). The directory was created and chmod 0700 first. This independently reproduces the fixer's retained blocker, not the earlier diagnostic mismatch. It establishes an incompatible fixture premise, not unsafe capture or a newly proven production regression. No assertion was relaxed and no production repair attempted.

Read the full remaining-lifecycle-diagnosis.md and repair-test-phase-report.md. Both focus segments have not passed; the recorded execution-order/stop boundary therefore prevents proceeding to remote-reply, process-events, remote-delta-read, external lifecycle-runner, lifecycle-order and invalid-identity reruns. These scenarios remain untested in THIS Test turn, despite older passing artifacts. Historical handoff-readiness cause remains unknown. No old evidence is claimed as fresh proof.

The step cannot demonstrate the complete listener intent at this target. Parent authority must reconcile the newline fixture's expectation with the existing state-root refusal and authorize the bounded correction before resuming the required order. No broad behavior repair is authorized.

No linters, static analysis, full suite, children, publication or pipeline controls ran. Tests cleaned their disposable homes; no transient worktree files remain. No UI change: CLI traces are the relevant product evidence; no screenshot was needed.
