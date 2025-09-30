# THIS IS A SPECIAL REPOSITORY

**IMPORTANT**: THIS REPOSITORY IS NAMED `.github` \
**AND** HAS A TOP-LEVEL DIRECTORY NAMED `.github`

THIS IS NOT AN ERROR. DO NOT BE CONFUSED.

THIS RESPOSITORY IS REQUIRED FOR GITHUB ORGANIZATIONS


# Repository Handbook

This repository holds the shared configuration that keeps the lacard-labs organization consistent across projects.

Start here when you need to adjust community-facing content, documentation, and policy.


## Organization Profile

`profile/README.md` controls the public organization profile.


## New Repository Setup

When you create a project with `LacardLabs/template`, walk the checklist below so new repositories match org defaults:

\# Figure out what pre-commits are


## Organization Repository Directory

| Name | Description |
| ---- | ----------- |

## Repository Map

| Path | Purpose |
| ---- | ------- |
| `profile/README.md` | Public landing page for the organization profile. Keep it welcoming and current. |
| `.github/workflows/ci.yml` | Reusable CI workflow called by downstream repositories. Supports Node, Python, and Make-based projects. |
| `.github/ISSUE_TEMPLATE/` | Organization-wide issue templates for bugs, features, and repository bootstrapping. |
| `.github/pull_request_template.md` | Narrative pull request template referenced in the contributing guide. |
| `.github/docs/reusable-ci.md` | Instructions for integrating the shared CI workflow into a project. |
| `docs/org-settings.md` | Nightly snapshot of org security defaults and ruleset fetch status. Requires the `ORG_REPORT_TOKEN` secret for automation. |
| `CONTRIBUTING.md` | Voice, workflow, and diagram guidelines for contributors. |
| `SECURITY.md` | Contact details and expectations for vulnerability reports. |
| `CODEOWNERS` | Review requirements for critical paths in this repository. |


## Working on Shared Workflows

The reusable CI lives at `.github/workflows/ci.yml` and is documented in `.github/workflows/ci.md`.


## Policies & Ownership

- **Ownership:** `CODEOWNERS`.
- **Security:** Follow `SECURITY.md` for reporting security issues or vulnerabilities.
- **Contributing:** See `CONTRIBUTING.md`.


## Quick Checklist for Contributors

1. Confirm you understand the guidance in `CONTRIBUTING.md`.
2. Create a branch before editing shared files.
3. Open a pull request and tag the relevant CODEOWNERS for review.


## Local Development Tips

- **Clone repos consistently:** Run `gh repo clone LacardLabs/<repo> ~/GitHub/LacardLabs/<repo>` so local tooling can rely on that path.

Development practices assume repos are in an Ubuntu installation, in the home directory, specifically at `~/GitHub/LacardLabs/*`


## Pull Request Templates

The Pull Request template is available at `.github/pull_request_template.md`.
