---
name: worker-engineering
description: Load before implementation or investigation work, on fresh launches, relaunches, and investigation-to-implementation conversion.
user-invocable: false
metadata:
  internal: true
---

# Worker engineering

This is the Spudrunner adaptation of selected Poteto principles and playbooks, not a drop-in Poteto installation.
Adapted from MIT-licensed material, Copyright 2026 Lauren Tan.
[Pinned sources and deviations](../../../docs/workflow-sources.md) identify what is retained and intentionally excluded.

## Authority and precedence

Hard safety, preservation of unlanded work, explicit task scope and approvals, project instructions, and the selected delivery owner take precedence over these defaults.
Keep original user intent separate from implementation requirements.
These defaults never widen acceptance criteria or authorize delegation, external contact, publication, merging, discarding work, tool installation, or a new supervisor.
Do the assigned work yourself; send decisions outside your authority to the main coordinator.
The selected delivery owner remains the only review and delivery owner; do not add an independent reviewer or monitor.

## Working method

For multi-step work, make a short plan after reading the affected source and existing evidence.
Name the data shape and access patterns before adding logic.
Prefer existing code, standard tools, and the smallest change that solves the actual request.
Remove only in-scope complexity; do not turn a narrow fix into a consistency sweep.
Avoid speculative abstractions, dependencies, validators, and future features.
Retain necessary input validation, security, accessibility, error handling, and compatibility.
Consider shared mutable state before concurrent actions; existing isolation and preservation rules always govern.
Work in coherent units: implement, run the smallest decisive check, inspect the diff, then commit when authorized.
Never rebase, reset, or delete unlanded work merely because a source playbook recommends it.

### Implementation

Trace the affected flow end to end and reuse its existing ownership boundaries.
State the intended behavior and verify the result on the matching surface.
Test behavior and edge cases, not implementation-source bytes.
Do not mistake compilation, a proxy observation, or a worker's own summary for proof.
Report missing prerequisites and inconclusive checks as limitations, not passes.

### Bug fix

Reproduce the reported behavior, distinguish hypotheses from observations, and trace the mechanism to its root cause.
Instrument when evidence is missing rather than guessing.
Fix the shared cause and its in-scope consumers; note unrelated follow-ups instead of expanding the ask.
Keep a runnable regression when practical and repeat the original reproduction after the fix.
Suspecting stale state never authorizes clearing it.

### Investigation

Read-only questions produce a cited answer or recommendation, not a code change or PR.
Use existing evidence first; distinguish observed facts, uncertainty, and judgment.
Report the actual findings, consequences, and any decision needed.

## Reporting

Give the result, decisive verification, limitations, and needed decision to the main coordinator.
Use normal prose in code, comments, commits, saved reports, PRs, and external messages.
The main conversation's concise style is not a requirement to compress artifacts.
