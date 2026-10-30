# Fork maintenance

Spudrunner is a standalone GitHub repository derived from [Firstmate](https://github.com/kunchenguid/firstmate), originally Copyright 2026 Kun Chen under MIT.
It retains the original history and attribution but is not attached to GitHub's fork network.
Development and review target [hyAndrewLee/spudrunner-standalone](https://github.com/hyAndrewLee/spudrunner-standalone).
Original-upstream publication is a separate action requiring explicit consent, never inferred from access or lineage.

## Remote roles and publication

Clone the fork as `origin`; an optional `upstream` remote is read-only consumption context.
Before publishing, verify `git remote -v`, the push URL, and `bin/publication-authority.sh`'s selected publication target.
Only `origin` should be marked `remote.origin.gh-resolved=base`; a competing base marker can select the wrong repository.
Without a base marker the compatibility resolver may prefer `upstream`, so merely changing origin is insufficient.
Configure this only in the intended repository, never in global configuration or an unrelated running home.
Use explicit `--repo hyAndrewLee/spudrunner-standalone` on every fork GitHub PR operation.
Preserve the existing lineage and task-consent guards; a fork is not an authority bypass.
Do not create standing maintainer authority on the user's behalf.
Push feature branches, open reviewable fork-local PRs against `main`, and merge only with the configured explicit authority.

Before every push, inspect staged content, the branch diff, and reachable history for credentials and private operational material.
Never copy a running home into the fork or force-add ignored files.
Keep `.env`, `data/`, `state/`, `config/`, and `projects/` private; ignore rules alone do not audit history.

## Upstream consumption

Record a known-good fork commit before an update.
Fetch the original upstream without pushing, compare its changes in an isolated copy, then replay intentional fork changes through a feature branch.
Review policy, source licenses, publication selection, and compatibility before applying upstream changes.
Run relevant behavioral checks, the documentation audience check, and pinned lint, then use the normal review and approval path.
Never blindly fast-forward a diverged fork, hard-reset unlanded work, or discard local changes to make an update proceed.
The guarded self-update command consumes this fork's origin; it does not reconcile an original-upstream integration automatically.

For pinned workflow updates, change only selected source files and their [manifest](../vendor/workflow/manifest.json).
Verify every fetched blob against its revision's API hash and inspect dependency and license changes.
Refresh the [adaptation record](workflow-sources.md) and effective skills together.
Do not install the upstream runtime products as a shortcut.

## Rollback

Keep the previous known-good commit available.
Revert the reviewed integration commits on a new branch and validate that branch before landing it with normal approval.
Do not reset a running home or rewrite shared history.
Private operational records and unlanded work remain preserved.
