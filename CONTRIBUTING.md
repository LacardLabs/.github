# Contributing

We keep every change traceable from **issue → branch → PR → merge**.

## Voice & Narrative
Write directly to Sarah in PRs and feature issues:
“Sarah, I did this. You need to do this. This is what we have now. This is what I thought at the time. This still needs to be done.”

## Workflow
All repositories start from the template on GitHub. Clone them locally with `gh repo clone LacardLabs/<repo> ~/GitHub/LacardLabs/<repo>` so shared scripts can assume that path. Run `pwd` before committing to make sure you're inside the expected directory.
1) Open an Issue (feature or bug).
2) For features: fill **Narrated Summary**, **JTBD**, **Define**, **Scope**, optional **Develop**.
3) Branch: `feat/<slug>` or `fix/<slug>`.
4) Implement with tests.
5) Open a PR and fill the template (Narrated Summary, JTBD, Define, Develop, **C4 delta**, tests, rollout, docs).
6) Get review (CODEOWNERS). CI must pass.
7) Squash-merge with a clear title. Update docs/diagrams if applicable.

## Diagrams
If using Mermaid, commit files under `docs/diagrams/` (e.g., `container.mmd`, `component.mmd`) and link them in the PR. Avoid embedding code fences in templates.

## Other Info
See `.github/docs/reusable-ci.md` for wiring the org-wide CI into this repo.
