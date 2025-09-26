# Lacard Labs Organization Controls

_Last updated: 2025-09-26 01:56:48 UTC_

## Security & Policy Defaults

| Setting | Default | Notes |
| --- | --- | --- |
| Require 2FA for members | ✅ | Enforced at org level. |
| Dependency graph for new repositories | ❌ | Default enablement when repos are created. |
| Dependabot alerts for new repositories | ❌ | Security alerts on by default. |
| Dependabot auto-updates for new repositories | ❌ | Keeps dependencies patched. |
| Secret scanning for new repositories | ❌ | Scans for leaked secrets. |
| Secret scanning push protection (new repos) | ❌ | Blocks pushes with detected secrets. |
| Advanced Security for new repositories | ❌ | Required for CodeQL/secret scanning billing. |
| Web commit sign-off required | ❌ | Forces DCO-style sign-offs on web commits. |

## Rulesets & Branch Protections

> Automated ruleset export requires the GitHub CLI to be authenticated with `admin:org`. Unable to fetch rulesets automatically — review them manually in **Settings → Code security & analysis → Rulesets**. (error: gh: Not Found (HTTP 404)
gh: This API operation needs the "admin:org" scope. To request it, run:  gh auth refresh -h github.com -s admin:org)

### Manual verification checklist
- Confirm org-level branch protection under **Settings → Repositories → Rules**.
- Confirm repository-specific overrides as needed.

## Updating this report

Run `scripts/export_org_settings.py` locally (requires the GitHub CLI) or allow the scheduled workflow `org-settings-report.yml` to refresh this file nightly. The workflow authenticates with the `ORG_REPORT_TOKEN` secret, which must be a personal access token (or GitHub App token) scoped for `read:org` and `admin:org` so that rulesets export succeeds.

