# Independent targeted Test result

Verdict: **no-go**. Target and resulting SHA remain `7c55cdb47a4716a04f04b7e4b829178d2b52176c`. No permanent source/test edits, commits, children, pipeline controls, publication, lint, static analysis, or complete repository suite. No Herdr/fleet session or credentials were touched.

## Required invocation

All test executions were sequential, using the existing evidence `round8-run-isolated.sh`:

```bash
export PATH="/home/andrew/spudrunner-green/tools:/home/andrew/.nvm/versions/node/v22.23.3/bin:$PATH"
export TMPDIR=/tmp
exec 9</home/andrew/spudrunner-green/serial-tests.lock
flock -x -w 20 9
ulimit -v 4194304
ulimit -t 480
exec unshare --user --map-current-user --pid --fork --mount-proc "$@"
```

No test bypass environment variables were supplied; the initial `env | grep '^FM_TEST_'` emitted nothing. Repository tests set their own ordinary test seams. The external lock was opened read-only, never created/truncated. `round10-environment.log` records namespace UID/GID 1000, PID 1, TMPDIR /tmp, memory 4194304 KiB, CPU 480 seconds, full PATH, and exact tools: /usr/bin/bash 5.0.17, pinned ruby 2.7.0p0, pinned node v22.23.3, /usr/bin/timeout, /home/linuxbrew/.linuxbrew/bin/unshare and flock.

Set `E=/home/andrew/.no-mistakes-spudrunner-validation/evidence/01M686RRNB95JSFM1P5TBWQ3YY` below. `round10-commands.log` retains exact invocations and exits. Each command output was redirected separately under E; no older-round evidence was overwritten.

| Command | Exit | Log |
|---|---:|---|
| `timeout -k 10 360 bash "$E/round8-run-isolated.sh" bash -x tests/remote-reply.test.sh` | 0 | round10-remote-reply.log |
| `timeout -k 10 650 bash "$E/round8-run-isolated.sh" bash -x tests/process-events.test.sh` | 0 | round10-process-events.log |
| `timeout -k 10 120 bash "$E/round8-run-isolated.sh" bash -x tests/remote-delta-read.test.sh` | 0 | round10-remote-delta-read.log |
| `FM_EXTENSION_BINDING_SEGMENT=lifecycle-runner timeout -k 10 110 bash "$E/round8-run-isolated.sh" bash -x tests/extension-host-binding.test.sh` | 0 | round10-lifecycle-runner.log |
| same command, segment `lifecycle-order` | 0 | round10-lifecycle-order.log |
| same command, segment `early-integrity` | 0 | round10-early-integrity.log |
| same command, segment `early-validation` | 0 | round10-early-validation.log |
| same command, segment `lifecycle-lock` | 1 | round10-lifecycle-lock.log |
| same command, segment `lifecycle-state` | 1 | round10-lifecycle-state.log |

These execute real public runner, adapter, reader and extension-host commands with disposable private homes and transport/package fixtures, not a live SSH host or live fleet. They do not establish real-network transport behavior, which this repair does not alter.

## Baseline comparison and product records

Baseline setup (all under the assigned worktree):

```bash
mkdir -p .validation-round10/base
cp -a bin .validation-round10/base/bin
 git show e1846c7ba5c06a894673f7c7f85f9cc925b7f86b:bin/process-events.sh > .validation-round10/base/bin/process-events.sh
```

The current extension test was copied to `tests/.round10-baseline.test.sh`, changing only `PROCEVENT="$ROOT/bin/process-events.sh"` to `PROCEVENT="$ROOT/.validation-round10/base/bin/process-events.sh"`. This compares baseline runner against identical target tests/dependencies, not an entire baseline checkout.

For each segment `lifecycle-lock` and `lifecycle-state`:

```bash
FM_EXTENSION_BINDING_SEGMENT="$segment" timeout -k 10 110 bash "$E/round8-run-isolated.sh" bash -x tests/.round10-baseline.test.sh
```

Both complete-fixture commands exited 1, retaining `round10-baseline-complete-lifecycle-{lock,state}.log`. Driver retained as `round10-baseline-complete-driver.sh`.

For reviewer-visible product records, copied current remote-reply test to `tests/.round10-handoff.test.sh`, adding only output of existing barrier records, claim, captures, mirrored status and cursor after all plain/NUL identity assertions. No assertion, scheduling, timeout or production behavior changed. Command:

```bash
timeout -k 10 360 bash "$E/round8-run-isolated.sh" bash -x tests/.round10-handoff.test.sh
```

Exit 0; `round10-handoff-complete-run.log`, `round10-handoff-complete-driver.sh`, and `round10-handoff-complete-product.log` retained. Barriers 5 and 6 and final claim share PID `5395`, token `.claim.2l9REV-5395`; adopted registration identities `2096:1336186` and `2096:1336200` changed to final `2096:1336206`. Captured next plain payload is `status=delta`; next NUL capture contains actual before-NUL-after bytes. Mirrored output is `before?after`, cursor 615, prefix digest `79ae3f217e80680e9b82a4b7fce075a4b6ef09ca401a72d0622f4218add2124d`. No fallback start/reconcile intervenes in those two handoffs.

Initial temporary-driver generation mistakenly used truncated read-tool output. Both first baseline attempts and the first output-only handoff attempt exited 2 with syntax errors; retained separately as `round10-baseline-lifecycle-{lock,state}.log`, `round10-handoff-evidence-run.log` and their incomplete driver files. Those are setup failures, not product failures or passes. Fixed by transforming complete original files with Python; complete-fixture commands above are separate attempts. The first partial handoff output file is not the final proof.

## Historical readiness diagnosis: still unresolved

Inspected the actual first failing `test-final-remote-reply.log` and permanent barrier/await/adoption path, before making temporary diagnostic drivers. The log shows generation 5 was captured and handled, after `reply_owner` reported live; no generation-5 fallback start is shown. It then exhausts the 100 readiness checks and fails `listener never reached handoff 5`. It does not retain the runner adoption decision, runner output or claim at that failure, and its cleanup deletes the private fixture. Handled-marker publication is not proof of subsequent successful adoption/floor entry. The first failure's unsupported environment is a fact, not a demonstrated causal explanation.

This turn's original permanent traced run and subsequent output-only traced run both pass. They do not establish why the historical barrier was absent, and no synchronization repair is justified by the surviving evidence. The selected readiness finding remains unresolved; further diagnosis needs a failing run retaining adoption/claim/barrier diagnostics under the required environment. No timeout increase, timer release, assertion weakening or speculative rewrite was performed. Previously retained original-listener counterfactual evidence is unchanged; the baseline lifecycle failures here are not claimed to reproduce the original handoff bug.

## Known red checks retained, not repaired or re-filed

`lifecycle-lock` fails identically on target and baseline: `binding retirement bypassed result.classify lifecycle reservation`. Earlier retirement checks observe binding-in-use refusal; this failure does not independently establish unsafe binding removal. `lifecycle-state` also fails on both: expected `cannot acquire source ownership`, actual `error: cannot claim source: control-tab-state-source`. Ownership is refused, but the exact diagnostic assertion is red. These previously ignored findings were not changed, waived or reintroduced as new findings. Per the recorded requirement, their corrected-environment rechecks and unresolved readiness causality retain the overall no-go for parent authority.

Complete remote/process/delta scripts pass; external active-poll replacement, lifecycle ordering and invalid identity checks pass. No UI was changed; CLI execution traces and persisted runtime records are the relevant evidence, so no screenshot was captured. Broader lifecycle-flow was not rerun or repaired.

## Cleanup

Removed `.validation-round10`, `tests/.round10-baseline.test.sh`, and `tests/.round10-handoff.test.sh`. Final `git status --short` is empty and HEAD remains exact target. Tests cleaned their disposable private homes. No dependencies were removed. All retained new evidence is in the designated evidence directory.
