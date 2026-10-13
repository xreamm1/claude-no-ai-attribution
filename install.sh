#!/usr/bin/env sh
# Installs the no-ai-attribution skill for Claude Code.
#
#   ./install.sh            -> for all your projects (~/.claude)
#   ./install.sh <repo-dir> -> for a single repository (<repo-dir>/.claude)
set -e

SRC="$(cd "$(dirname "$0")" && pwd)"

if [ -n "$1" ]; then
  ROOT="$(cd "$1" && pwd)"
  CLAUDE_DIR="$ROOT/.claude"
  CLAUDE_MD="$ROOT/CLAUDE.md"
else
  CLAUDE_DIR="$HOME/.claude"
  CLAUDE_MD="$CLAUDE_DIR/CLAUDE.md"
fi

# 1. Skill
mkdir -p "$CLAUDE_DIR/skills"
rm -rf "$CLAUDE_DIR/skills/no-ai-attribution"
cp -r "$SRC/skills/no-ai-attribution" "$CLAUDE_DIR/skills/"
echo "✓ skill    -> $CLAUDE_DIR/skills/no-ai-attribution"

# 2. settings.json: turn off Claude Code's built-in attribution
SETTINGS="$CLAUDE_DIR/settings.json"
if command -v python3 >/dev/null 2>&1; then
  python3 - "$SETTINGS" <<'EOF'
import json, os, sys
path = sys.argv[1]
data = {}
if os.path.exists(path):
    with open(path, encoding="utf-8") as f:
        text = f.read().strip()
    data = json.loads(text) if text else {}
data["attribution"] = {"commit": "", "pr": ""}
data["includeCoAuthoredBy"] = False
with open(path, "w", encoding="utf-8") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
    f.write("\n")
EOF
  echo "✓ settings -> $SETTINGS"
elif [ ! -f "$SETTINGS" ]; then
  cp "$SRC/examples/settings.json" "$SETTINGS"
  echo "✓ settings -> $SETTINGS"
else
  echo "! python3 not found: add the keys from examples/settings.json to $SETTINGS manually"
fi

# 3. CLAUDE.md rule (added once)
MARKER="no-ai-attribution"
if [ -f "$CLAUDE_MD" ] && grep -q "$MARKER" "$CLAUDE_MD"; then
  echo "✓ CLAUDE.md already contains the rule"
else
  [ -s "$CLAUDE_MD" ] && printf '\n' >> "$CLAUDE_MD"
  cat "$SRC/examples/CLAUDE.md" >> "$CLAUDE_MD"
  echo "✓ rule     -> $CLAUDE_MD"
fi

echo "Done. Restart Claude Code to apply."
