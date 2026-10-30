# Naming conventions

The display brand is **Spudrunner**; the repository name is **spudrunner**.
Use neutral role vocabulary and sentence case.
There is no mandatory personal address and no nautical acknowledgement or decorative supervision marker.

| Display concept | Canonical term |
| --- | --- |
| Primary supervisor | Main coordinator |
| Change-producing agent | Implementation worker |
| Knowledge-only agent | Investigation worker |
| Persistent domain supervisor | Project coordinator |
| Original request | User intent |
| Build constraints | Implementation requirements |
| Current work digest | Status summary |
| Visible-session digest | Session recap |
| Decision section | Your decisions |
| Active, completed, upcoming sections | In progress, Recently completed, Next |

New instruction headings render `## User intent` and `## Implementation requirements`.
The shared heading reader accepts both canonical headings and `## Captain's intent` / `## Firstmate spec`, including old callers.
Original intent is never renamed inside its body, enriched with defaults, or rewritten as a side effect of reading.
Legacy provenance markers remain readable; new mixed legacy-style records may use `[user]`.
The same reader feeds dispatch, launch validation, and investigation-to-implementation conversion.

New filenames and command aliases use lower-kebab-case; shell functions and new data keys use snake_case.
TypeScript values use camelCase, types use PascalCase, and environment variables use UPPER_SNAKE_CASE.
Do not rename established interfaces merely to match the display vocabulary.

## Compatibility boundary

Retain existing `fm-`, `fm_`, `FM_`, `FIRSTMATE_OP`, `FM_INJECT_MARK`, tool IDs, paths, config filenames, persisted keys, status verbs, kind tokens, and Git branch defaults.
Existing skill names such as `self-repository-authority` and `user-decision-lifecycle` remain real compatibility entrypoints.
The internal `ship`, `scout`, `secondmate`, and `captain` protocol values are not display-role names.
Old command aliases continue to work; new user-facing skill entrypoints forward to the existing owners.
No standalone `spudrunner` CLI is provided or implied.
Do not rewrite history or private saved records for branding.
Original attribution, verbatim third-party sources, and historical verification keep their original names.
Existing documentation anchors are retained where headings change.
