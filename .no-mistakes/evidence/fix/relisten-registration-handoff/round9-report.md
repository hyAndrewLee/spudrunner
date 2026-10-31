# Independent test-phase environment correction

Verdict: **no-go**. No source or permanent test changes were made.
Unchanged target/resulting SHA: `7c55cdb47a4716a04f04b7e4b829178d2b52176c`.
Baseline runner: `e1846c7ba5c06a894673f7c7f85f9cc925b7f86b`.
No children, pipeline controls, publication, lint, formatters, static analysis, full repository suite, or global configuration changes were performed.

## Required environment

Every test below ran sequentially using the existing `round8-run-isolated.sh`, without test bypass variables.
Its complete execution prefix is:

```bash
export PATH="/home/andrew/spudrunner-green/tools:/home/andrew/.nvm/versions/node/v22.23.3/bin:$PATH"
export TMPDIR=/tmp
exec 9</home/andrew/spudrunner-green/serial-tests.lock
flock -x -w 20 9
ulimit -v 4194304
ulimit -t 480
exec unshare --user --map-current-user --pid --fork --mount-proc "$@"
```

`round9-environment.log` records namespace UID 1000, PID 1, complete PATH, memory/CPU limits and tool resolution/version.
Bash: `/usr/bin/bash`, 5.0.17.
Node: `/home/andrew/.nvm/versions/node/v22.23.3/bin/node`, v22.23.3.
Ruby: `/home/andrew/spudrunner-green/tools/ruby`, 2.7.0p0.
Unshare and flock: `/home/linuxbrew/.linuxbrew/bin/{unshare,flock}`, util-linux 2.41.3.
Timeout: `/usr/bin/timeout`, coreutils 8.30.
The wrapper retains the inherited PATH after its required pinned prefix; no substitutions or tool installs occurred.
The external lock was opened read-only, not created or truncated.

## Commands and outcomes

All commands ran at the assigned worktree root.
Set `E=/home/andrew/.no-mistakes-spudrunner-validation/evidence/01M686RRNB95JSFM1P5TBWQ3YY` for every command below.
Each command's output was redirected to its stated separate evidence file; no previous evidence was overwritten.

| Command | Exit | Evidence |
|---|---:|---|
| `timeout -k 10 360 bash "$E/round8-run-isolated.sh" bash -x tests/remote-reply.test.sh` | 0 | round9-remote-reply-traced.log |
| `timeout -k 10 650 bash "$E/round8-run-isolated.sh" bash tests/process-events.test.sh` | 0 | round9-process-events.log |
| `timeout -k 5 120 bash "$E/round8-run-isolated.sh" bash tests/remote-delta-read.test.sh` | 0 | round9-remote-delta.log |
| `FM_EXTENSION_BINDING_SEGMENT=lifecycle-runner timeout -k 10 110 bash "$E/round8-run-isolated.sh" bash -x tests/extension-host-binding.test.sh` | 0 | round9-lifecycle-runner.log |
| `FM_EXTENSION_BINDING_SEGMENT=lifecycle-order timeout -k 10 110 bash "$E/round8-run-isolated.sh" bash -x tests/extension-host-binding.test.sh` | 0 | round9-lifecycle-order.log |
| `FM_EXTENSION_BINDING_SEGMENT=early-integrity timeout -k 10 110 bash "$E/round8-run-isolated.sh" bash -x tests/extension-host-binding.test.sh` | 0 | round9-early-integrity.log |
| `FM_EXTENSION_BINDING_SEGMENT=early-validation timeout -k 10 110 bash "$E/round8-run-isolated.sh" bash -x tests/extension-host-binding.test.sh` | 0 | round9-early-validation.log |
| `FM_EXTENSION_BINDING_SEGMENT=lifecycle-lock timeout -k 10 110 bash "$E/round8-run-isolated.sh" bash -x tests/extension-host-binding.test.sh` | 1 | round9-lifecycle-lock.log |
| `FM_EXTENSION_BINDING_SEGMENT=lifecycle-state timeout -k 10 110 bash "$E/round8-run-isolated.sh" bash -x tests/extension-host-binding.test.sh` | 1 | round9-lifecycle-state.log |
| `FM_EXTENSION_BINDING_SEGMENT=lifecycle-lock timeout -k 10 110 bash "$E/round8-run-isolated.sh" bash -x tests/.round9-baseline.test.sh` | 1 | round9-baseline-lifecycle-lock.log |
| `FM_EXTENSION_BINDING_SEGMENT=lifecycle-state timeout -k 10 110 bash "$E/round8-run-isolated.sh" bash -x tests/.round9-baseline.test.sh` | 1 | round9-baseline-lifecycle-state.log |
| `timeout -k 10 360 bash "$E/round8-run-isolated.sh" bash -x tests/.round9-handoff.test.sh` | 0 | round9-handoff-evidence-run.log |

Baseline setup: `mkdir -p .validation-round9/base; cp -a bin .validation-round9/base/bin; git show e1846c7ba5c06a894673f7c7f85f9cc925b7f86b:bin/process-events.sh > .validation-round9/base/bin/process-events.sh`.
The baseline driver is the current extension test with only `PROCEVENT="$ROOT/bin/process-events.sh"` replaced by `PROCEVENT="$ROOT/.validation-round9/base/bin/process-events.sh"`.
This compares baseline runner production with the current identical test and dependencies; it is not a claim to have run an entirely baseline tree.
Saved temporary drivers: `round9-baseline-driver.sh` and `round9-handoff-driver.sh`.
The handoff evidence driver adds only output of existing runtime records after the NUL assertions; it changes no barrier, assertion, timer, fallback or timeout.

## Original handoff readiness investigation

Read the actual first failing `test-final-remote-reply.log` and affected test/runner source before executing or changing anything.
That log proves generation 5 was durably captured and handled, and `reply_owner` had returned `live` before capture; it does not show a fallback start for generation 5.
The subsequent 100 readiness checks found no `handoff/5.ready` and exited 1.
The log does not retain the isolated runner's `start-one.out`, claim at failure, barrier sequence reads, or adoption decision; cleanup deleted that fixture.
Consequently it cannot distinguish an exited/refusing owner from an owner delayed before adoption, nor prove why the barrier was absent.

The source places the barrier immediately before `process_events_launch_floor_wait`, conditioned on the requested generation's handled marker.
Capture/handling completion alone does not establish that `adopt_relisten` subsequently succeeded or that the runner reached that floor boundary.
The failure's validation environment was unsupported (no required lock/namespace and a bypass variable), but that fact alone does **not** establish it caused this failure.
The first corrected traced execution of the exact permanent test passed, including both barriers and all ownership refusals.
One subsequent traced output-only execution also passed and retained actual identities and payloads.
These are distinct passing attempts, not an explanation or erasure of the original failed attempt.
No unsupported-environment replay or speculative synchronization change was attempted.
**Exact historical readiness cause remains unresolved; the selected readiness finding is not closed.**
Further diagnosis requires a failing run retaining runner adoption/claim/barrier diagnostics under the required environment; there is no evidence justifying a permanent fix yet.

## Runtime proof and remaining failures

`round9-handoff-product.log` records barrier 5 and 6 PID `4800`, token `.claim.NhIgf2-4800`, adopted identities `2096:1336047` and `2096:1336061`, and final claim identity `2096:1336076` with the same PID/token.
It retains the actual plain and NUL captures, normalized `before?after` mirrored status, and cursor offset `615` with matching prefix SHA-256 `685c137a126a3621a3dd90da8b81bded1f9209c13fe52c9fb0c17c0cb062d2f6`.
The permanent test independently asserts changed registration identities and captures plain/NUL under the existing owner without manual reconcile/fallback.
The external active-poll segment passes its unchanged registration/claim/runner/poll comparisons before explicitly releasing the poll.
Complete process-events and remote-delta scripts passed independently; invalid identity, changed command/adapter, missing registration, and ownership refusal checks were retained.
Previously retained original-listener counterfactual evidence was not modified; no new baseline handoff result is claimed.

`lifecycle-lock` still fails on target and baseline at `binding retirement bypassed result.classify lifecycle reservation`.
The earlier serialized retirement assertions in each trace explicitly observe binding-in-use refusal; neither this failure nor the previous diagnostic evidence proves unsafe removal.
The failing final temporal assertion remains red, unchanged, and is not waived.
`lifecycle-state` still fails on target and baseline: expected `cannot acquire source ownership`, actual `error: cannot claim source: control-tab-state-source`.
Ownership refusal does not make its diagnostic assertion green.
No changes were made for either ignored finding.
Broader lifecycle-flow was not rerun or repaired; its recorded namespace group_pid limitation remains as previously reported.

## Cleanup

Removed `.validation-round9`, `tests/.round9-baseline.test.sh` and `tests/.round9-handoff.test.sh` after retaining diagnostic drivers in evidence.
No dependencies were removed.
No patch or commit was created; target SHA is unchanged.
The environment-method omission is corrected by these independent targeted executions, but unresolved readiness causality and reproduced lifecycle failures keep the overall result no-go for parent authority.
