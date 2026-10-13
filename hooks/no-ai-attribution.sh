#!/usr/bin/env sh
# no-ai-attribution — Claude Code SessionStart hook.
#
# Runs automatically when a Claude Code session starts, so it works even when
# the model doesn't load the skill. In the current git repository it:
#   1. sets the commit author (repo-local git config) when a name and email are given;
#   2. installs a commit-msg hook that strips Co-Authored-By Claude,
#      Claude-Session and "Generated with Claude Code" lines;
#   3. installs a pre-commit hook that refuses commits authored by
#      "Claude <noreply@anthropic.com>" (the default identity in cloud sessions);
#   4. installs a pre-push hook that refuses pushing branches named claude/*;
#   5. in an empty repository, switches the initial branch to main.
#
# Usage: no-ai-attribution.sh ["Your Name" "you@example.com"]

NAME="$1"
EMAIL="$2"

cd "${CLAUDE_PROJECT_DIR:-$PWD}" 2>/dev/null || exit 0
git rev-parse --git-dir >/dev/null 2>&1 || exit 0

# 1. Author identity (repo-local config wins over the global one).
if [ -n "$NAME" ] && [ -n "$EMAIL" ]; then
  git config user.name "$NAME"
  git config user.email "$EMAIL"
fi

HOOKS_DIR="$(git rev-parse --git-path hooks)"
mkdir -p "$HOOKS_DIR"
MARK="# managed-by: no-ai-attribution"

# Writes a git hook unless the user already has their own hook there.
install_hook() {
  target="$HOOKS_DIR/$1"
  if [ -f "$target" ] && ! grep -q "$MARK" "$target"; then
    echo "no-ai-attribution: $target already exists, not replaced" >&2
    return
  fi
  cat > "$target"
  chmod +x "$target"
}

# 2. Strip AI attribution lines from every commit message.
install_hook commit-msg <<EOF
#!/bin/sh
$MARK
f="\$1"
tmp="\$f.no-ai.\$\$"
grep -viE '^[[:space:]]*(co-authored-by:.*(claude|anthropic)|claude-session:|.*generated with \[?claude( code)?)' "\$f" > "\$tmp"
mv "\$tmp" "\$f"
EOF

# 3. Refuse commits authored by Claude.
install_hook pre-commit <<EOF
#!/bin/sh
$MARK
ident="\$(git var GIT_AUTHOR_IDENT 2>/dev/null)"
case "\$ident" in
  *noreply@anthropic.com*|Claude\ \<*)
    echo "no-ai-attribution: commit author is '\${ident%>*}>'." >&2
    echo "Set the human author first:" >&2
    echo '  git config user.name "Your Name"' >&2
    echo '  git config user.email "you@example.com"' >&2
    exit 1 ;;
esac
EOF

# 4. Refuse pushing claude/* branches (deleting them is allowed).
install_hook pre-push <<EOF
#!/bin/sh
$MARK
zero=0000000000000000000000000000000000000000
while read -r local_ref local_sha remote_ref remote_sha; do
  case "\$remote_ref" in
    refs/heads/claude/*)
      [ "\$local_sha" = "\$zero" ] && continue
      echo "no-ai-attribution: refusing to push \${remote_ref#refs/heads/}." >&2
      echo "Work on main instead:  git checkout main && git merge \${local_ref#refs/heads/} && git push origin main" >&2
      exit 1 ;;
  esac
done
exit 0
EOF

# 5. Empty repository: start on main, not on a claude/* branch.
if ! git rev-parse -q --verify HEAD >/dev/null 2>&1; then
  git symbolic-ref HEAD refs/heads/main
fi

case "$(git symbolic-ref --short -q HEAD)" in
  claude/*) echo "no-ai-attribution: the current branch is $(git symbolic-ref --short -q HEAD). The user wants all work on main: switch to main and never push claude/* branches." ;;
esac

AUTHOR="$(git config user.name) <$(git config user.email)>"
case "$AUTHOR" in
  *noreply@anthropic.com*|"Claude <"*)
    echo "no-ai-attribution: git author is $AUTHOR. Before committing, set the user's identity with git config user.name / user.email (ask the user if unknown). Never commit as Claude and never add Co-Authored-By or Claude-Session lines." ;;
  *)
    echo "no-ai-attribution: commits will be authored by $AUTHOR. Never add Co-Authored-By Claude or Claude-Session lines." ;;
esac
exit 0
