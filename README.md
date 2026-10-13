<div align="center">

<h1>claude-no-ai-attribution</h1>

<p>A Claude Code skill that stops Claude from adding itself as a co-author to your commits and GitHub contributors.</p>

<h3>🧹 <code>/no-ai-attribution</code></h3>

<p><b>The cleanup command: type it in Claude Code and Claude disappears from your repository. Its <code>claude/...</code> branches move into <code>main</code>, and Claude is removed from authors, co-authors and commit messages.</b></p>

<p>
<img src="https://flagcdn.com/20x15/gb.png" width="20" height="15" alt="gb"> <a href="README.md"><b>English</b></a> |
<img src="https://flagcdn.com/20x15/ru.png" width="20" height="15" alt="ru"> <a href="README.ru.md">Русский</a> |
<img src="https://flagcdn.com/20x15/es.png" width="20" height="15" alt="es"> <a href="README.es.md">Español</a> |
<img src="https://flagcdn.com/20x15/cn.png" width="20" height="15" alt="cn"> <a href="README.zh-CN.md">简体中文</a> |
<img src="https://flagcdn.com/20x15/jp.png" width="20" height="15" alt="jp"> <a href="README.ja.md">日本語</a>
</p>

<p>
<a href="https://github.com/xreamm1/claude-no-ai-attribution/releases/latest"><img alt="Release" src="https://img.shields.io/github/v/release/xreamm1/claude-no-ai-attribution?style=for-the-badge&color=0a7bbb"></a>
<a href="https://code.claude.com"><img alt="Claude Code skill" src="https://img.shields.io/badge/Claude%20Code-skill-d97757?style=for-the-badge"></a>
<a href="install.sh"><img alt="Shell POSIX sh" src="https://img.shields.io/badge/shell-POSIX%20sh-4eaa25?style=for-the-badge&logo=gnubash&logoColor=white"></a>
<a href="LICENSE"><img alt="License MIT" src="https://img.shields.io/github/license/xreamm1/claude-no-ai-attribution?style=for-the-badge&color=6aa84f"></a>
<a href="https://github.com/xreamm1/claude-no-ai-attribution/stargazers"><img alt="Stars" src="https://img.shields.io/github/stars/xreamm1/claude-no-ai-attribution?style=for-the-badge&color=e3b341"></a>
</p>

</div>

## Why

By default, Claude Code ends every commit message with:

```
Co-Authored-By: Claude <noreply@anthropic.com>
```

GitHub treats that line as co-authorship. Your commits then show **"you and claude"**, and **claude** appears in the repository's **Contributors** list. In some environments, such as cloud sessions, Claude may also commit under its own name.

With this skill, only you are the author.

## Quick start: `/no-ai-attribution`

1. Download [`SKILL.md`](https://github.com/xreamm1/claude-no-ai-attribution/releases/latest/download/SKILL.md) and add it as a skill: upload it in claude.ai (**Settings → Capabilities → Skills**) or put it in `~/.claude/skills/no-ai-attribution/SKILL.md`.
2. Open a Claude Code session in your repository and type:

   ```
   /no-ai-attribution
   ```

That's it. Claude then:

- moves the work from every `claude/...` branch into **`main`** and deletes the `claude/...` branches;
- removes Claude from the history of **every branch** (`main`, `dev`, feature branches…). Commits authored by Claude become yours, and the `Co-Authored-By`, `Claude-Session` and "Generated with Claude Code" lines disappear. The code doesn't change;
- makes you the only author of all new commits and keeps working on `main`.

Typing the command is your consent to rewrite the history of your branches and force-push them, so Claude won't ask again. If the repository's default branch is still `claude/...`, Claude asks you to switch it to `main` (**Settings → General → Default branch**) and type the command once more. GitHub may keep showing the old **Contributors** list for a few hours, because it's cached.

## What's inside

| File | What it does |
|---|---|
| [`skills/no-ai-attribution/SKILL.md`](skills/no-ai-attribution/SKILL.md) | The skill. It forbids `Co-Authored-By`, `Claude-Session` and `Generated with Claude Code` lines, makes the human the commit author, and checks commits before every push. |
| [`examples/settings.json`](examples/settings.json) | Claude Code setting that turns off the built-in attribution. |
| [`examples/CLAUDE.md`](examples/CLAUDE.md) | A short rule for `CLAUDE.md`. It works even when the skill isn't loaded. |
| [`SKILL.md` → `.claude/hooks/no-ai-attribution.sh`](skills/no-ai-attribution/SKILL.md) | Runs automatically at session start, even if the model ignores the skill. It sets your name as the commit author, strips attribution lines from every commit message, blocks commits authored by `Claude <noreply@anthropic.com>`, and refuses to push `claude/...` branches. In an empty repository it starts work on `main`. |
| [`install.sh`](install.sh) | Installs everything with one command. `--name` and `--email` set the commit author. You need them for cloud sessions on claude.ai/code, where git is preconfigured as Claude. |

> [!IMPORTANT]
> The skill alone (for example, uploaded to claude.ai) is **not enough**. In cloud sessions, Claude treats the session settings ("add Co-Authored-By", "work on a `claude/...` branch") as more important than a skill. It does follow the repository's `CLAUDE.md`, and the hooks work no matter what the model decides. So install everything into each repository with `install.sh` (see below) and commit `.claude/` and `CLAUDE.md`.

## Install

**For all your projects:**

```sh
git clone https://github.com/xreamm1/claude-no-ai-attribution
sh claude-no-ai-attribution/install.sh --name "Your Name" --email "you@example.com"
```

The script copies the skill to `~/.claude/skills/`, sets `"attribution": {"commit": "", "pr": ""}` in `~/.claude/settings.json` (keeping your other settings), and appends the rule to `~/.claude/CLAUDE.md` once. Restart Claude Code afterwards.

**For one repository:**

```sh
sh claude-no-ai-attribution/install.sh path/to/your-repo --name "Your Name" --email "you@example.com"
```

Then commit `.claude/` and `CLAUDE.md`. The rule then also applies to cloud sessions on claude.ai/code and to everyone else who uses Claude in that repository.

**Manually:** copy `skills/no-ai-attribution` to `~/.claude/skills/`, add the keys from `examples/settings.json` to your `settings.json`, and add `examples/CLAUDE.md` to your `CLAUDE.md`.

## Claude is already in my history

The skill only affects new commits. To clean old ones, rewrite them: remove the `Co-Authored-By` lines and change the author, then run `git push --force`. A force-push replaces the history on GitHub, so warn your collaborators first.

After that, GitHub may keep showing Claude under **Contributors** for a few hours to a couple of days, because the list is cached. A new commit on the default branch usually makes it update sooner.

## License

[MIT](LICENSE)
