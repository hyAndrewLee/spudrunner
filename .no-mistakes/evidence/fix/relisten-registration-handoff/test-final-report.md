# Targeted product validation

Target: 7c55cdb47a4716a04f04b7e4b829178d2b52176c
Baseline: e1846c7ba5c06a894673f7c7f85f9cc925b7f86b

No production or permanent test changes. No pipeline control, publication, lint, full repository suite, live fleet, or credential operations. Disposable test homes used the existing executable tests' private claim roots with TMPDIR=/tmp and FM_TEST_SKIP_ORPHAN_REAP=1. Test cleanup removed their fixtures. The temporary baseline and output-only diagnostic drivers were removed; final git status was empty.

## Commands and outcomes

All test commands below used `env TMPDIR=/tmp FM_TEST_SKIP_ORPHAN_REAP=1`.

- `FM_TEST_EVIDENCE=1 timeout 240 bash -x tests/remote-reply.test.sh`: exit 1, listener never reached handoff 5. See test-final-remote-reply.log. This is an instrumentation-sensitive/flaky readiness failure, not evidence of a payload regression. Cause not established.
- `FM_TEST_EVIDENCE=1 timeout 240 bash tests/remote-reply.test.sh`: exit 0. See test-final-remote-reply-recheck.log. Plain and NUL handoffs, unchanged owner, digest/cursor/control normalization, and command/adapter/missing/home/PID/token/one-shot refusals passed against real product scripts with disposable transport fixtures.
- `FM_EXTENSION_BINDING_SEGMENT=lifecycle-runner timeout 40 bash -x tests/extension-host-binding.test.sh`: exit 0. See test-final-lifecycle-runner.log. A real external poll remained blocked; both public replacement paths refused before release; source, claim, runner, and poll marker were unchanged; the original poll subsequently completed and safe replacement succeeded.
- `FM_EXTENSION_BINDING_SEGMENT=<segment> timeout 40 bash -x tests/extension-host-binding.test.sh`, for lifecycle-order, lifecycle-lock, lifecycle-state, lifecycle-flow: respectively exits 0, 1, 1, 0. Logs are test-final-<segment>.log. These independent homes were exercised concurrently in this group.
- `git archive e1846c7ba5c06a894673f7c7f85f9cc925b7f86b bin tests | tar -x -C .validation-baseline`; the same lifecycle-runner, lifecycle-lock, lifecycle-state commands without xtrace against `.validation-baseline/tests/extension-host-binding.test.sh`: respectively exits 124, 1, 1. The active-poll defect reproduces on unchanged baseline within the same 40-second bound; target passes. Both additional failures reproduce on baseline.
- A temporary copy of the remote-reply driver added only printing of adopted/replacement registration identity, claim, captured NUL payload, mirrored status, and cursor; `FM_TEST_EVIDENCE=1 timeout 240 bash tests/.validation-remote.test.sh`: exit 0 after fixing an initial driver-generation truncation error (exit 2). See test-final-handoff-product.log and test-final-output-only-driver.patch. Assertions, barriers, and bounds were unchanged. Both handoffs used PID 19068 and token .claim.IHzgvq-19068. Actual NUL-bearing captured bytes and normalized before?after status appear in the log.
- An output-only diagnostic copy of the extension driver, `FM_EXTENSION_BINDING_SEGMENT=lifecycle-lock timeout 40 bash tests/.validation-extension.test.sh`: exit 1 after fixing the same initial generation truncation error (exit 2). See test-final-lock-diagnostic.log. The operation had returned `external-ready`; retirement returned `binding-in-use`, rather than remaining alive as the test expected. This does NOT demonstrate unsafe binding removal.
- Supplemental baseline handoff attempts copied the current regression into the extracted baseline. First attempt exited 1 because remote-entrypoint requires a Git-tracked root. `git -C .validation-baseline init -q; git -C .validation-baseline add bin tests` fixed that refusal, but the rerun still exited 1 before the handoff with source exit 64. See test-final-baseline-handoff.log. These disposable-baseline attempts do not reproduce or disprove the original handoff defect; no baseline handoff pass is claimed.

## Outstanding test failures

1. The first traced remote-reply run failed its handoff-5 readiness wait; two subsequent untraced executions, including output-only instrumentation, passed. Do not silently call every invocation green or increase timeouts to mask this observation.
2. lifecycle-lock fails at the result.classify retirement wait on baseline and target. Diagnostic evidence shows safe refusal rather than removal. The existing temporal expectation needs reconciliation with the actual lifecycle contract before changing the assertion; this run makes no production-lock regression claim.
3. lifecycle-state expects `cannot acquire source ownership` for a control-bearing state path, but baseline and target both emit `cannot claim source`. Ownership is refused; the diagnostic assertion still fails.

Core repair behavior is demonstrated live through executable product interfaces. The complete targeted command set is not green. No UI changed, so runtime CLI transcripts and durable records are the appropriate evidence; no screenshots were needed.
