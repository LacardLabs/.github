# Reusable CI — How we wire it in every repo

**What this is:** One shared CI workflow in `lacard-labs/.github` that all project repos call.

**Why:** Single source of truth for CI. Change it once, every repo benefits.

## Files

- **Shared workflow (already in place)**
  - `lacard-labs/.github/.github/workflows/ci.yml`
  - Triggers: `workflow_call` + local `push`/`pull_request` so we can test edits here.

- **Caller workflow (per project)**
  - Path: `.github/workflows/ci.yml` (in the project repo)
  - Minimal content:
    ```yaml
    name: CI
    on:
      pull_request:
      push:
        branches: [ main, master ]
    jobs:
      ci:
        uses: lacard-labs/.github/.github/workflows/ci.yml@main
        secrets: inherit
        with:
          node-version: 'lts/*'
          python-version: '3.x'
    ```

## How to enable CI in a project (60 seconds)

1. Create the folder:
   - `mkdir -p .github/workflows`
2. Create the caller file shown above.
3. Commit and push:
   - `git add .github/workflows/ci.yml`
   - `git commit -m "ci: use org reusable workflow"`
   - `git push`

## Notes

- The shared CI runs Python steps only if it detects `requirements.txt` or `pyproject.toml`; Node steps only if `package.json` exists; Makefile fallback if `Makefile` exists.
- For `pyproject.toml`-managed projects the workflow installs your package (preferring the `test` extra via `pip install ".[test]"` when present, otherwise `pip install .`).
- Declare test extras inside `[project.optional-dependencies]` in `pyproject.toml`, for example:
  ```toml
  [project.optional-dependencies]
  test = ["pytest", "requests"]
  ```
- You can override tool versions via the `with:` block in the caller.
- CODEOWNERS is per-repo; add it to each project where you want enforced reviews.
