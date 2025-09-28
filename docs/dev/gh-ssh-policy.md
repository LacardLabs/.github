# GitHub access policy (LacardLabs)
- **Git transports**: SSH **only** for `git` operations. HTTPS is disallowed.
- **CLI**: Prefer `gh` (GitHub CLI) for GitHub objects (PRs, issues, actions).
- **Headless auth**: When on SSH-only hosts, use the **device flow** and open \
  https://github.com/login/device on another device to enter the printed code.
- **No GUI required**: `GH_NO_BROWSER=1` disables any local browser attempts.
- **Automation**: Scripts live in this repo today; plan to fold them into the LacardLabs CLI when ready.
