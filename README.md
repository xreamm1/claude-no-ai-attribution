# claude-no-ai-attribution

A [Claude Code](https://code.claude.com) skill that stops Claude from adding itself to your commits.

Without it, GitHub shows **"you and claude"** on commits and lists **claude** under the repository's **Contributors**. With it, only you are the author.

> 🇷🇺 *Описание на русском — ниже.*

## Why Claude shows up as a contributor

By default, Claude Code ends every commit message with:

```
Co-Authored-By: Claude <noreply@anthropic.com>
```

GitHub treats that line as co-authorship. In some environments, such as cloud sessions, Claude may also commit under its own name: `Claude <noreply@anthropic.com>`.

## What's inside

| File | What it does |
|---|---|
| `skills/no-ai-attribution/SKILL.md` | The skill. It forbids `Co-Authored-By`, `Claude-Session` and `Generated with Claude Code` lines, makes the human the commit author, and checks commits before every push. |
| `examples/settings.json` | Claude Code setting that turns off the built-in attribution. |
| `examples/CLAUDE.md` | A short rule for `CLAUDE.md`. It works even when the skill isn't loaded. |
| `install.sh` | Installs all three parts with one command. |

The setting turns off Claude Code's own attribution. The skill and the `CLAUDE.md` rule cover the cases where the attribution comes from elsewhere, such as an environment's instructions. Install all three.

## Install

### For all your projects

```sh
git clone https://github.com/xreamm1/claude-no-ai-attribution
sh claude-no-ai-attribution/install.sh
```

The script:

- copies the skill to `~/.claude/skills/`;
- sets `"attribution": {"commit": "", "pr": ""}` in `~/.claude/settings.json` and keeps your other settings;
- appends the rule to `~/.claude/CLAUDE.md` (only once).

Restart Claude Code afterwards.

### For one repository

```sh
sh claude-no-ai-attribution/install.sh path/to/your-repo
```

Then commit `.claude/` and `CLAUDE.md` in that repository. This also works for cloud sessions on claude.ai/code and for everyone else who uses Claude in that repository.

### Manually

1. Copy `skills/no-ai-attribution` to `~/.claude/skills/` or `<repo>/.claude/skills/`.
2. Add the keys from `examples/settings.json` to your `settings.json`.
3. Add the text from `examples/CLAUDE.md` to your `CLAUDE.md`.

## Claude is already in my history

The skill only affects new commits. To clean old ones, rewrite them: remove the `Co-Authored-By` lines and change the author, then run `git push --force`. A force-push replaces the history on GitHub, so warn your collaborators first.

After that, GitHub may keep showing Claude under **Contributors** for a while. The list is cached and can take from a few hours to a couple of days to update. A new commit on the default branch usually makes it update sooner.

## License

[MIT](LICENSE). Use, copy and share it freely.

---

## 🇷🇺 На русском

Скилл для Claude Code, который не даёт Claude добавлять себя в соавторы коммитов. С ним у коммитов на GitHub не появляется надпись «… **and claude**», а в списке **Contributors** — `claude`.

**Установка для всех проектов:**

```sh
git clone https://github.com/xreamm1/claude-no-ai-attribution
sh claude-no-ai-attribution/install.sh
```

**Для одного репозитория:** `sh claude-no-ai-attribution/install.sh путь/к/репозиторию`. Затем закоммитьте `.claude/` и `CLAUDE.md`.

Скрипт делает три вещи:

- копирует скилл в `.claude/skills/`;
- выключает встроенную подпись Claude Code в `settings.json` и сохраняет остальные ваши настройки;
- добавляет правило в `CLAUDE.md`.

Скилл действует только на новые коммиты. Если Claude уже есть в истории, коммиты нужно переписать и сделать force-push. После этого GitHub ещё какое-то время показывает старый список **Contributors**: он кэшируется, обновление может занять от нескольких часов до пары дней.
