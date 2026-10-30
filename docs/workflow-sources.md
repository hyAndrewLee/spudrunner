# Workflow sources

Spudrunner includes a deliberately bounded, Firstmate-compatible Poteto adaptation and a chat-only Caveman adaptation.
It is not a faithful Poteto port, and neither upstream project sponsors this fork.
The original Firstmate MIT license and Kun Chen attribution remain in [LICENSE](../LICENSE).

## Reproducible inputs

[The manifest](../vendor/workflow/manifest.json) owns every selected source path, full revision, Git blob ID, and SHA-256.
Vendored files are unmodified source evidence, not automatically installed or invoked skills.
The effective modified instructions are [worker-engineering](../.agents/skills/worker-engineering/SKILL.md) and [concise-chat](../.agents/skills/concise-chat/SKILL.md).
Their adaptation notices identify the modifications; upstream files keep their original notices.

- Poteto: `poteto/plugins@74dd2291e8e37b12fd6dc49b2acbd655c6bdaf12`, selected `pstack/skills/` principles and feature, bug-fix, investigation playbooks.
  The [pstack MIT license](../vendor/workflow/poteto/LICENSE), Copyright 2026 Lauren Tan, covers this selection.
- Caveman: `JuliusBrussee/caveman@9b68f7ed12b05e7efaff18e65c5a3fc2849fd0a4`, `skills/caveman/SKILL.md` only.
  Retain [Apache-2.0](../vendor/workflow/caveman/LICENSE), [NOTICE](../vendor/workflow/caveman/NOTICE), [historical MIT license](../vendor/workflow/caveman/LICENSE-MIT), and [licensing explanation](../vendor/workflow/caveman/LICENSING.md).
  This is not claimed to match a locally installed Caveman skill.

The retained Caveman NOTICE describes upstream runtime components, but no engine, proxy, browser, font, SDK, CLI, or runtime binary from that repository is included.
No cursor-team-kit files, Cursor built-ins, or unrelated runtime products are vendored.

## Dependency closure and deliberate differences

The effective adaptation has no external skill or runtime dependency beyond the existing coordinator, worker tools, and delivery path.
The raw selected playbooks are reference material only: never load them as an executable task contract.
Every reference from those inputs is accounted for below rather than silently promising missing capabilities.

| Selected input or referenced dependency | Effective disposition |
| --- | --- |
| Foundational thinking, subtract before adding, fix root causes | Data shapes first, existing mechanisms, in-scope simplicity, reproduce and diagnose; no permission to remove safety or clear state. |
| Prove it works, sequence verifiable units | Direct evidence, behavioral regressions, coherent verified commits; no mandatory history rewrite or reset. |
| `show-me-your-work`, `build-the-lever`, `separate-before-serializing-shared-state` | Existing task evidence and isolation suffice; no new logger, automation product, or parallelism authority. |
| Feature, bug-fix, investigation playbooks | Read source, plan, implement or answer, test the actual surface, report evidence; investigation does not imply implementation authority. |
| `how`, `why`, `tdd` | Ordinary source/history reading and runnable reproduction; no additional skill dependency or forced model fan-out. |
| `architect`, `interrogate`, `arena`, subagents | Not installed or invoked by this adaptation; no parallel design, four-model review, cross-judge, or nested delegation requirement. |
| Cursor `Task`, background agents, `poteto-agent` | Not Pi APIs; implementation workers work directly under the existing coordinator. |
| `unslop`, `deslop`, Comments, matching control skills | Readable normal artifacts, diff inspection, existing CLI/browser/test tools; no copied skill or implied control capability. |
| Opening a PR, `babysit`, `/loop` | Existing selected delivery and supervision owners exclusively; no second review gate, monitor, publication grant, or reset-based recovery. |
| Hardcoded feature/bug-fix models, catalogs | Existing dispatch profile, effort, account, and catalog resolution only; no model names imposed. |
| Autonomous external reversible actions | Omitted; existing scoped approvals and publication consent govern even reversible actions. |
| Mandatory first todo, four-item throughput checkpoint, principle citations | Short task-appropriate planning and evidence, not ceremony or invented scope; no compulsory reply expansion. |
| Caveman ultra/wenyan/megacave, status hooks, compressor | Not included; concise main chat only, with explicit detail requests winning and artifacts staying normal. |

The Poteto wrapper and other playbooks are not included, so their additional triggers are not dependencies of this selection.
The upstream Caveman runtime and other modes are similarly outside the selected chat skill.
See [integration ownership](workflow-integration.md) for effective paths and [fork maintenance](fork-maintenance.md) for upgrades.
