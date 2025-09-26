# Reusable CI (workflow_call)

**Workflow**: `.github/workflows/ci.yml`

## Inputs

| Name | Type | Default | Description |
| ---- | ---- | ------- | ----------- |
| `language` | string | `none` | Optional hint: `python`, `node`, `rust`, or `none`. Auto-detect still runs. |
| `run_tests` | boolean | `true` | Set `false` for lint-only runs. |
| `codeql` | boolean | `true` | Enable CodeQL analysis when supported. |
| `sbom` | boolean | `false` | Emit a CycloneDX SBOM artifact. |

## Permissions

- Workflow default: `contents: read`
- CodeQL job: adds `security-events: write`
- SBOM job: uses `actions/upload-artifact` only

## Jobs

1. **prepare** – detects Python/Node/Rust footprints and surfaces CodeQL languages.
2. **lint_test** – installs toolchains conditionally, runs language-specific lint/test, falls back to Make targets when no language detected.
3. **codeql** – optional; initializes, autobuilds, analyzes with languages from `prepare` (defaults to Python when no stack detected).
4. **sbom** – optional; uses Syft to produce `sbom.json` (CycloneDX) and uploads as artifact.

## Caller Example

```yaml
name: CI
on:
  push:
    branches: [ main ]
  pull_request:
permissions:
  contents: read
jobs:
  org-ci:
    uses: LacardLabs/.github/.github/workflows/ci.yml@main
    with:
      language: python
      run_tests: true
      codeql: true
      sbom: false
    secrets: inherit
```

## Notes

- The reusable workflow also triggers on pushes/PRs within this repo so edits can be validated locally.
- Direct pushes/PRs in this repo run with defaults (`language=none`, `run_tests=true`, `codeql=true`, `sbom=false`) so the workflow remains executable without workflow-call inputs.
- Python support tests for `requirements.txt`, `pyproject.toml`, or `poetry.lock` before bootstrapping.
- Node support caches `npm` installs and gracefully skips lint/test when scripts are missing.
- Rust support assumes a standard Cargo layout and enforces `cargo fmt --check` before running tests.
- Make fallback (`make test` → `make ci`) only runs when no supported language footprint is detected.
- SBOM upload only publishes for workflow calls and tag/release events to keep noise low during PR edits.
