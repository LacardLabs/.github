# Reusable CI (workflow_call)

**Workflow**: `.github/workflows/ci.yml`

## Inputs

| Name | Type | Default | Description |
| ---- | ---- | ------- | ----------- |
| `language` | string | `none` | Optional hint: `python`, `node`, `rust`, or `none`. Auto-detect still runs. |
| `python-version` | string | `3.12` | Python version to install when Python tooling is detected. Leave blank to accept the default. |
| `node-version` | string | `lts/*` | Node.js version to install when Node tooling is detected. Leave blank to accept the default. |
| `run_tests` | boolean | `true` | Set `false` to skip test steps while still running lint. |
| `codeql` | boolean | `true` | Enable CodeQL analysis when supported (automatically disabled for Rust-only projects). |
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

### Prepare job outputs

Downstream jobs consume a handful of signals emitted by the `prepare` job. They are available to callers as `needs.prepare.outputs.*` when overriding the workflow:

| Output | Description |
| ------ | ----------- |
| `has_python` / `has_node` / `has_rust` | Language footprints detected in the repository or via the `language` hint. |
| `python_version` / `node_version` | Resolved toolchain versions, honoring provided inputs and defaulting to Python 3.12 / Node LTS. |
| `codeql_languages` | Comma-delimited list of languages passed to CodeQL (defaults to `python` when nothing is detected). |
| `codeql_enabled` | Whether CodeQL analysis will run after applying feature toggles. |
| `run_tests_enabled` | Indicates if test steps—including the Make fallback—should execute. |
| `sbom_enabled` | Signals if the SBOM job should run and upload an artifact. |

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
- Python and Node setup steps honor the `python-version`/`node-version` inputs when provided and fall back to `3.12`/`lts/*` for in-repo push and PR runs.
- Node support caches `npm` installs and gracefully skips lint/test when scripts are missing.
- Rust support assumes a standard Cargo layout and enforces `cargo fmt --check` before running tests.
- CodeQL skips unsupported Rust analysis: Rust-only repos automatically disable CodeQL, while mixed-language projects filter the Rust footprint from the language list.
- Make fallback (`make test` → `make ci`) only runs when no supported language footprint is detected and tests are enabled, and it
  captures exit codes so missing targets skip while real failures halt the workflow.
- SBOM upload only publishes for workflow calls and tag/release events to keep noise low during PR edits.
