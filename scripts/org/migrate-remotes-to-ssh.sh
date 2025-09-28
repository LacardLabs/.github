#!/usr/bin/env bash
# Convert HTTPS GitHub remotes under a root path to SSH for LacardLabs.
# Usage: scripts/org/migrate-remotes-to-ssh.sh "$HOME/GitHub"
set -euo pipefail
ROOT="${1:-$HOME/GitHub}"
OWNER="LacardLabs"
find "$ROOT" -type d -name ".git" -prune -print0 | while IFS= read -r -d '' g; do
  repo_dir="$(dirname "$g")"
  url="$(git -C "$repo_dir" remote get-url origin 2>/dev/null || true)"
  case "$url" in
    https://github.com/${OWNER}/*)
      ssh_url="${url/https:\/\/github.com\//git@github.com:}"
      echo "[$repo_dir] $url -> $ssh_url"
      git -C "$repo_dir" remote set-url origin "$ssh_url"
      git -C "$repo_dir" config core.hooksPath .githooks || true
      ;;
  esac
done
