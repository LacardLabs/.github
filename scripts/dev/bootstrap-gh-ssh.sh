#!/usr/bin/env bash
# Bootstrap SSH + gh for GitHub, headless-friendly, no local browser required.
# Policy baked in: SSH-only for git; gh preferred; block HTTPS pushes.
# Usage: scripts/dev/bootstrap-gh-ssh.sh
# Optional env: GH_KEY_PATH (~/.ssh/github), GH_TOKEN / GITHUB_TOKEN (PAT), GH_HOST (default github.com)

set -euo pipefail

# ---------- config ----------
GH_HOST="${GH_HOST:-github.com}"
KEY_PATH="${GH_KEY_PATH:-$HOME/.ssh/github}"
PUB_PATH="${KEY_PATH}.pub"
KEY_COMMENT="${KEY_COMMENT:-$(whoami)@$(hostname)}"
NEED_SCOPES="${GH_SCOPES:-admin:public_key,repo,workflow}"
# ----------------------------

say() { printf '%s\n' "$*" ; }
hr() { printf '%*s\n' "$(tput cols 2>/dev/null || echo 80)" '' | tr ' ' '-'; }

ensure_ssh_key() {
  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"

  if [[ ! -f "$KEY_PATH" ]]; then
    say "→ Generating ED25519 key at $KEY_PATH"
    ssh-keygen -t ed25519 -a 100 -C "$KEY_COMMENT" -f "$KEY_PATH" -N ""
  else
    say "✓ SSH key exists: $KEY_PATH"
  fi

  chmod 600 "$KEY_PATH"
  [[ -f "$PUB_PATH" ]] && chmod 644 "$PUB_PATH"

  # ssh-agent
  if ! ssh-add -l >/dev/null 2>&1; then
    say "→ Starting ssh-agent"
    eval "$(ssh-agent -s)" >/dev/null
  fi
  ssh-add "$KEY_PATH" >/dev/null 2>&1 || true

  # ~/.ssh/config entry (pin to this key)
  if ! grep -qE '^Host '"$GH_HOST"'$' "$HOME/.ssh/config" 2>/dev/null; then
    say "→ Writing SSH config for $GH_HOST"
    cat >> "$HOME/.ssh/config" <<EOF_CFG

Host $GH_HOST
  HostName $GH_HOST
  User git
  IdentityFile $KEY_PATH
  IdentitiesOnly yes
  AddKeysToAgent yes
EOF_CFG
    chmod 600 "$HOME/.ssh/config"
  else
    say "✓ SSH config already contains host $GH_HOST"
  fi
}

prove_ssh() {
  set +e
  ssh -T -o StrictHostKeyChecking=accept-new git@"$GH_HOST" </dev/null
  rc=$?
  set -e
  # 1 or 255 are okay banners depending on OpenSSH; both indicate publickey path hit
  if [[ $rc -eq 1 || $rc -eq 255 ]]; then
    say "→ SSH probe returned code $rc (expected 1/255). If you saw a greeting banner, SSH wiring is good."
  fi
}

gh_setup_git_protocol() {
  if command -v gh >/dev/null 2>&1; then
    gh config set -h "$GH_HOST" git_protocol ssh || true
  fi
}

upload_key_via_gh_or_pat() {
  # If gh is logged-in and has admin:public_key, use it. Else, try PAT. Else, trigger device flow.
  if command -v gh >/dev/null 2>&1; then
    if gh auth status -h "$GH_HOST" >/dev/null 2>&1; then
      # try add; refresh scopes if needed
      if ! gh ssh-key add "$PUB_PATH" -t "$(hostname) $(date +%F)" 2>/tmp/gh_key_add.err; then
        if grep -q "admin:public_key" /tmp/gh_key_add.err; then
          say "→ Refreshing gh token scopes to include admin:public_key"
          GH_NO_BROWSER=1 gh auth refresh -h "$GH_HOST" -s admin:public_key || true
          gh ssh-key add "$PUB_PATH" -t "$(hostname) $(date +%F)" || true
        fi
      else
        say "✓ SSH public key uploaded via gh"
      fi
    else
      say "→ gh not logged in for $GH_HOST"
    fi
  fi

  # If gh path didn’t work, try PAT
  GH_PAT="${GH_TOKEN:-${GITHUB_TOKEN:-}}"
  if [[ -n "${GH_PAT}" ]]; then
    say "→ Uploading SSH key via PAT API"
    curl -fsS -H "Authorization: token ${GH_PAT}" \
         -H "Accept: application/vnd.github+json" \
         "https://api.${GH_HOST}/user/keys" \
         -d "{\"title\":\"$(hostname) $(date +%F)\",\"key\":\"$(cat "$PUB_PATH")\"}" >/dev/null || true
  fi
}

device_flow_if_needed() {
  # Only if gh exists and not logged-in
  command -v gh >/dev/null 2>&1 || return 0
  if ! gh auth status -h "$GH_HOST" >/dev/null 2>&1; then
    say "→ Starting headless device flow. Leave this shell open."
    say "   On another device, open: https://github.com/login/device"
    export GH_NO_BROWSER=1
    gh auth login -h "$GH_HOST" --git-protocol ssh -s "$NEED_SCOPES"
    # After login, add key (idempotent)
    gh ssh-key add "$PUB_PATH" -t "$(hostname) $(date +%F)" || true
  else
    say "✓ gh already logged in for $GH_HOST"
  fi
}

enforce_ssh_hook() {
  mkdir -p .githooks
  cat > .githooks/pre-push <<'HOOK'
#!/usr/bin/env bash
set -euo pipefail
remote_url="$(git remote get-url origin 2>/dev/null || echo)"
case "$remote_url" in
  https://github.com/*|https://*github*/*)
    echo "❌ HTTPS push blocked by org policy. Use SSH remote: git@github.com:OWNER/REPO.git" >&2
    exit 1
    ;;
esac
exit 0
HOOK
  chmod +x .githooks/pre-push
  git config core.hooksPath .githooks || true
}

migrate_remote_to_ssh() {
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    url="$(git remote get-url origin 2>/dev/null || true)"
    if [[ "$url" =~ ^https://github.com/ ]]; then
      ssh_url="${url/https:\/\/github.com\//git@github.com:}"
      say "→ Converting remote to SSH"
      git remote set-url origin "$ssh_url"
    fi
  fi
}

set_upstream_if_missing() {
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    branch="$(git branch --show-current 2>/dev/null || true)"
    if [[ -n "$branch" ]]; then
      if ! git rev-parse --abbrev-ref --symbolic-full-name "@{u}" >/dev/null 2>&1; then
        say "→ Setting upstream for current branch: $branch"
        git push --set-upstream origin "$branch" || true
      fi
    fi
  fi
}

main() {
  hr; say "Bootstrap: SSH + gh (host=$GH_HOST)"; hr
  ensure_ssh_key
  gh_setup_git_protocol
  upload_key_via_gh_or_pat
  device_flow_if_needed
  prove_ssh
  enforce_ssh_hook
  migrate_remote_to_ssh
  git config --global push.autoSetupRemote true || true
  set_upstream_if_missing
  hr; say "Done. Policy enforced: SSH-only git; gh preferred; HTTPS blocked."; hr
  say "Headless activation reminder: open https://github.com/login/device on another device when prompted."
}

main "$@"
