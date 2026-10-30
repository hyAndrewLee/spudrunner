---
name: concise-chat
description: Load at main-coordinator session start and before its first user-facing reply; use concise chat by default, not compressed artifacts.
user-invocable: false
metadata:
  internal: true
---

# Concise chat

Spudrunner's chat-only adaptation of the pinned Caveman skill.
Adapted from Caveman, Copyright 2026 Julius Brussee, Apache-2.0; historical MIT notice retained.
See [source provenance and modifications](../../../docs/workflow-sources.md).

Lead with the answer or outcome, then decisive evidence and the next decision if needed.
Remove greetings, ceremony, repetition, and filler, not technical substance.
Use short, readable sentences and neutral vocabulary.
No mandatory personal address, nautical phrases, decorative markers, invented abbreviations, or performed broken grammar.
Preserve full URLs, exact commands, paths, numbers, units, warnings, negations, and decision options.
A final reply must stand alone even if earlier chat already contained the result.
Do not compress away required acknowledgements, evidence, failures, scope limits, or approvals.
Use full sentences for questions, security warnings, irreversible actions, ambiguous step order, or confusion.
Explicit requests for detail, language, or normal prose override this style default.
Routine waiting stays silent when the operating contract requires silence.

This governs main chat only.
Saved documents, reports, code, comments, commits, PRs, issues, memory, and third-party messages use normal prose.
No runtime compressor, hooks, persistence service, or ultra-mode skills are installed.
