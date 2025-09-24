# lacard-labs/.github Handbook

This repository holds the shared configuration that keeps the lacard-labs organization consistent across projects. Start here when you need to adjust community-facing content, automation, or policies.

## Contents

- [Repository Map](#repository-map)
- [Working on Shared Workflows](#working-on-shared-workflows)
- [Issue & PR Templates](#issue--pr-templates)
- [Organization Profile](#organization-profile)
- [Policies & Ownership](#policies--ownership)
- [Local Development Tips](#local-development-tips)

## Quick Checklist

1. Confirm you understand the guidance in `CONTRIBUTING.md`.
2. Create a branch or fork before editing shared files.
3. Open a pull request and tag the relevant CODEOWNERS for review.
4. Note downstream repositories or docs that must be updated alongside your change.

## Repository Map

| Path | Purpose |
| ---- | ------- |
| `profile/README.md` | Public landing page for the organization profile. Keep it welcoming and current. |
| `.github/workflows/ci.yml` | Reusable CI workflow called by downstream repositories. Supports Node, Python, and Make-based projects. |
| `.github/ISSUE_TEMPLATE/` | Organization-wide issue templates for bugs, features, and repository bootstrapping. |
| `.github/pull_request_template.md` | Narrative pull request template referenced in the contributing guide. |
| `.github/docs/reusable-ci.md` | Instructions for integrating the shared CI workflow into a project. |
| `CONTRIBUTING.md` | Voice, workflow, and diagram guidelines for contributors. |
| `SECURITY.md` | Contact details and expectations for vulnerability reports. |
| `CODEOWNERS` | Review requirements for critical paths in this repository. |

## Working on Shared Workflows

The reusable CI lives at `.github/workflows/ci.yml` and is documented in `.github/docs/reusable-ci.md`.

- Validate edits with a pull request in this repository. The workflow runs on `push` and `pull_request`, so changes are exercised before they land elsewhere.
- Check compatibility guidance (Node, Python, Make) in the docs before changing default tool versions or detection logic.
- Communicate breaking changes in the PR description and tag affected downstream repositories.

## Issue & PR Templates

Issue templates live under `.github/ISSUE_TEMPLATE/` and cover bugs, features, and repository initialization. When adjusting them:

1. Keep prompts concise but directive&mdash;they reinforce the narrated workflow in `CONTRIBUTING.md`.
2. Update `config.yml` if you add or remove templates so GitHub surfaces the right options.
3. Flag required fields directly in the template body to avoid omissions.

The PR template (`.github/pull_request_template.md`) mirrors the narrated summary approach. If you restructure it, note the intent in template comments so contributors understand how to respond.

## Organization Profile

`profile/README.md` controls the public organization profile. Treat updates like marketing copy:

- Spotlight community wins, active projects, and calls to action.
- Cross-link to CONTRIBUTING and SECURITY policies when relevant.
- Match the narrative tone described in `CONTRIBUTING.md`.

## Policies & Ownership

Policies live at the repository root:

- **Contributing:** See `CONTRIBUTING.md` for workflow steps and storytelling style.
- **Security:** Follow `SECURITY.md` when reporting vulnerabilities.
- **Ownership:** `CODEOWNERS` enforces review coverage. Update it when responsibilities change.

## Local Development Tips

- **Preview Markdown:** Run `npx markdownlint-cli2 README.md` (or the file you are editing) to catch formatting issues before committing.
- **Exercise workflows:** Use [`act`](https://github.com/nektos/act) to simulate GitHub Actions locally when you need faster feedback.
- **Craft commits:** Follow the narrated commit/PR style in `CONTRIBUTING.md`. Reference the issue, summarize the change, and flag next steps.

