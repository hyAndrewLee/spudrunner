---
name: pr-delivery
description: Load when scoping an implementation PR, before opening a PR, and while supervising its CI checks.
user-invocable: false
metadata:
  internal: true
---

# Atomic PRs and delegated CI supervision

## Scope and tests

Keep each PR small and atomic: one independently reviewable behavior or inseparable migration, with the tests needed to prove it.
Split unrelated refactors, features, and workflow changes into separate PRs; sequence dependent PRs explicitly rather than silently bundling them.
An explicitly user-approved large migration remains one coherent exception, not a standing waiver for later PRs.
Fixes include behavioral regression coverage that fails before the fix when feasible; docs-only changes use the existing documentation checks.
The selected delivery path remains the single owner of validation and publication.

## Observer and implementing worker

After opening a PR, delegate CI babysitting to a separate read-only agent using the active harness's supported delegation mechanism.
Give it the repository, PR, original implementing worker's identity, return channel, and stop condition.
The observer checks the current PR head and its workflows every 10 seconds, using a bounded tool-level polling loop rather than a model call for every poll.
Keep its last observed SHA and deduplication state in private task artifacts, never tracked project files.
It follows replacement heads after pushes and reports API or authentication failures instead of treating unreadable state as green.

On a new failed check, the observer reports the exact head SHA, check and run identifiers, link, and decisive log excerpt to the original implementing worker through the supervisor.
It does not edit code, retry or cancel jobs, push, change attestations, or merge.
The original implementing worker owns diagnosis, a focused follow-up fix, relevant tests, and publication through the same selected delivery path.
When no-mistakes owns the branch, that worker drives its supported fix/gate flow rather than hand-editing, creating a competing writer, or restarting the active run.
A correction to the same behavior stays a follow-up commit on the same PR; unrelated new behavior gets a separate atomic PR.
After the fix is published, the observer checks the replacement head every 10 seconds and repeats the failure-report/fix loop until the required checks pass.

Green means the required checks exist and pass on the exact current PR head, with none pending or failing; absent checks and stale-head success are not green.
Keep the existing merge-authority and named-head guards in [task-landing](../task-landing/SKILL.md); the observer has no merge authority.
Stop the observer and its polling process after merge, closure, or an explicit supervisor stop, preserving its final evidence and any unresolved blocker.
