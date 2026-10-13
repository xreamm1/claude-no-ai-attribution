#!/usr/bin/env sh
# Installs no-ai-attribution for Claude Code.
#
#   ./install.sh [--name "Your Name" --email "you@example.com"]             -> all your projects (~/.claude)
#   ./install.sh <repo-dir> [--name "Your Name" --email "you@example.com"]  -> one repository (<repo-dir>/.claude)
#
# --name/--email set the commit author in every session. They matter most for
# cloud sessions (claude.ai/code), where git is preconfigured as
# "Claude <noreply@anthropic.com>". If omitted, your current git identity is
# used unless it is Claude's.
set -e

SRC="$(cd "$(dirname "$0")" && pwd)"
TARGET=""
NAME=""
EMAIL=""

while [ $# -gt 0 ]; do
  case "$1" in
    --name) NAME="$2"; shift 2 ;;
    --email) EMAIL="$2"; shift 2 ;;
    -h|--help) sed -n '2,10p' "$0"; exit 0 ;;
    *) TARGET="$1"; shift ;;
  esac
done

if [ -n "$TARGET" ]; then
  ROOT="$(cd "$TARGET" && pwd)"
  CLAUDE_DIR="$ROOT/.claude"
  CLAUDE_MD="$ROOT/CLAUDE.md"
  HOOK_CMD_PATH='$CLAUDE_PROJECT_DIR/.claude/hooks/no-ai-attribution.sh'
  ID_DIR="$ROOT"
else
  CLAUDE_DIR="$HOME/.claude"
  CLAUDE_MD="$CLAUDE_DIR/CLAUDE.md"
  HOOK_CMD_PATH="$CLAUDE_DIR/hooks/no-ai-attribution.sh"
  ID_DIR="$PWD"
fi

# Fall back to the current git identity, unless it's Claude's.
if [ -z "$NAME" ] || [ -z "$EMAIL" ]; then
  cur_name="$(git -C "$ID_DIR" config user.name 2>/dev/null || true)"
  cur_email="$(git -C "$ID_DIR" config user.email 2>/dev/null || true)"
  case "$cur_name <$cur_email>" in
    *noreply@anthropic.com*|"Claude <"*|" <>") ;;
    *) NAME="${NAME:-$cur_name}"; EMAIL="${EMAIL:-$cur_email}" ;;
  esac
fi

# 1. Skill
mkdir -p "$CLAUDE_DIR/skills"
rm -rf "$CLAUDE_DIR/skills/no-ai-attribution"
cp -r "$SRC/skills/no-ai-attribution" "$CLAUDE_DIR/skills/"
echo "✓ skill    -> $CLAUDE_DIR/skills/no-ai-attribution"

# 2. SessionStart hook script
mkdir -p "$CLAUDE_DIR/hooks"
cp "$SRC/hooks/no-ai-attribution.sh" "$CLAUDE_DIR/hooks/no-ai-attribution.sh"
chmod +x "$CLAUDE_DIR/hooks/no-ai-attribution.sh"
echo "✓ hook     -> $CLAUDE_DIR/hooks/no-ai-attribution.sh"

HOOK_CMD="sh \"$HOOK_CMD_PATH\""
if [ -n "$NAME" ] && [ -n "$EMAIL" ]; then
  HOOK_CMD="$HOOK_CMD \"$NAME\" \"$EMAIL\""
fi

# 3. settings.json: no built-in attribution + register the hook
SETTINGS="$CLAUDE_DIR/settings.json"
if command -v python3 >/dev/null 2>&1; then
  python3 - "$SETTINGS" "$HOOK_CMD" <<'EOF'
import json, os, sys
path, cmd = sys.argv[1], sys.argv[2]
data = {}
if os.path.exists(path):
    with open(path, encoding="utf-8") as f:
        text = f.read().strip()
    data = json.loads(text) if text else {}
data["attribution"] = {"commit": "", "pr": ""}
data["includeCoAuthoredBy"] = False
groups = data.setdefault("hooks", {}).setdefault("SessionStart", [])
for g in groups:  # drop an older registration of this hook
    g["hooks"] = [h for h in g.get("hooks", []) if "no-ai-attribution.sh" not in h.get("command", "")]
groups[:] = [g for g in groups if g.get("hooks")]
groups.append({"hooks": [{"type": "command", "command": cmd}]})
with open(path, "w", encoding="utf-8") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
    f.write("\n")
EOF
  echo "✓ settings -> $SETTINGS"
else
  echo "! python3 not found: merge examples/settings.json into $SETTINGS manually"
fi

# 4. CLAUDE.md rule (added once)
if [ -f "$CLAUDE_MD" ] && grep -q "no-ai-attribution" "$CLAUDE_MD"; then
  echo "✓ CLAUDE.md already contains the rule"
else
  [ -s "$CLAUDE_MD" ] && printf '\n' >> "$CLAUDE_MD"
  cat "$SRC/examples/CLAUDE.md" >> "$CLAUDE_MD"
  echo "✓ rule     -> $CLAUDE_MD"
fi

# 5. Apply to the target repository right away
if [ -n "$TARGET" ]; then
  CLAUDE_PROJECT_DIR="$ROOT" sh "$CLAUDE_DIR/hooks/no-ai-attribution.sh" "$NAME" "$EMAIL" >/dev/null
fi

if [ -n "$NAME" ] && [ -n "$EMAIL" ]; then
  echo "✓ author   -> $NAME <$EMAIL>"
else
  echo "! no author set. For cloud sessions, re-run with --name \"Your Name\" --email \"you@example.com\""
fi
echo "Done. Restart Claude Code to apply."
