#!/usr/bin/env python3
import json
import subprocess
from datetime import datetime, timezone
from pathlib import Path

ORG = "LacardLabs"
ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "docs" / "org-settings.md"


def gh_api(endpoint: str) -> dict:
    result = subprocess.run(
        ["gh", "api", endpoint],
        check=False,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )
    if result.returncode != 0:
        raise RuntimeError(f"gh api {endpoint} failed: {result.stderr.strip()}")
    return json.loads(result.stdout or "{}")


def format_status(value):
    if isinstance(value, bool):
        return "✅" if value else "❌"
    if value is None:
        return "—"
    return str(value)


def fetch_rulesets():
    result = subprocess.run(
        ["gh", "api", f"orgs/{ORG}/rulesets"],
        check=False,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )
    if result.returncode != 0:
        return None, result.stderr.strip()
    try:
        data = json.loads(result.stdout or "[]")
    except json.JSONDecodeError as exc:
        return None, f"Failed to decode rulesets JSON: {exc}"
    return data, None


def render_ruleset_section():
    rulesets, error = fetch_rulesets()
    if rulesets is None:
        extra = f" (error: {error})" if error else ""
        return (
            "> Automated ruleset export requires the GitHub CLI to be authenticated with "
            "`admin:org`. Unable to fetch rulesets automatically — review them manually "
            "in **Settings → Code security & analysis → Rulesets**." + extra
        )
    if not rulesets:
        return "No organization-level rulesets are currently defined."

    rows = ["| Ruleset | Enforcement | Applies to |", "| --- | --- | --- |"]
    for rs in rulesets:
        name = rs.get("name", "—")
        enforcement = str(rs.get("enforcement", "—")).title()
        target = rs.get("target")
        if isinstance(target, list):
            target_desc = ", ".join(str(t) for t in target) or "—"
        else:
            target_desc = str(target or "—")
        rows.append(f"| {name} | {enforcement} | {target_desc} |")
    return "\n".join(rows)


def main():
    org = gh_api(f"orgs/{ORG}")
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)

    table_rows = [
        ("Require 2FA for members", format_status(org.get("two_factor_requirement_enabled")), "Enforced at org level."),
        ("Dependency graph for new repositories", format_status(org.get("dependency_graph_enabled_for_new_repositories")), "Default enablement when repos are created."),
        ("Dependabot alerts for new repositories", format_status(org.get("dependabot_alerts_enabled_for_new_repositories")), "Security alerts on by default."),
        ("Dependabot auto-updates for new repositories", format_status(org.get("dependabot_security_updates_enabled_for_new_repositories")), "Keeps dependencies patched."),
        ("Secret scanning for new repositories", format_status(org.get("secret_scanning_enabled_for_new_repositories")), "Scans for leaked secrets."),
        ("Secret scanning push protection (new repos)", format_status(org.get("secret_scanning_push_protection_enabled_for_new_repositories")), "Blocks pushes with detected secrets."),
        ("Advanced Security for new repositories", format_status(org.get("advanced_security_enabled_for_new_repositories")), "Required for CodeQL/secret scanning billing."),
        ("Web commit sign-off required", format_status(org.get("web_commit_signoff_required")), "Forces DCO-style sign-offs on web commits."),
    ]

    table_lines = ["| Setting | Default | Notes |", "| --- | --- | --- |"]
    for name, status, note in table_rows:
        table_lines.append(f"| {name} | {status} | {note} |")

    now = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M:%S UTC")

    sections = [
        "# Lacard Labs Organization Controls",
        "",
        f"_Last updated: {now}_",
        "",
        "## Security & Policy Defaults",
        "",
    ]
    sections.extend(table_lines)
    sections.extend([
        "",
        "## Rulesets & Branch Protections",
        "",
        render_ruleset_section(),
        "",
        "### Manual verification checklist",
        "- Confirm org-level branch protection under **Settings → Repositories → Rules**.",
        "- Confirm repository-specific overrides as needed.",
        "",
        "## Updating this report",
        "",
        "Run `scripts/export_org_settings.py` locally (requires the GitHub CLI) or allow the scheduled workflow `org-settings-report.yml` to refresh this file nightly. The workflow authenticates with the `ORG_REPORT_TOKEN` secret (scoped for `read:org` and `admin:org`).",
        "",
    ])

    OUTPUT.write_text("\n".join(sections) + "\n")
    print(f"Wrote {OUTPUT.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
