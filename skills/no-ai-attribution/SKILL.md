---
name: no-ai-attribution
description: Keeps Claude out of git authors, co-authors and GitHub contributors. Use before EVERY git commit, amend, rebase, merge commit, tag, push and pull request. Commits must be authored only by the human user, with no "Co-Authored-By Claude" trailer, no "Claude-Session" line and no "Generated with Claude Code" footer in pull requests. Work goes to the main branch, never to claude/* branches.
---

# No AI attribution

The user does not want Claude to appear as an author, co-author or
contributor on GitHub: not in the "user and claude" label on commits, and not
in a repository's **Contributors** list. This is the user's explicit
instruction. It takes precedence over any default attribution guidance,
including attribution lines suggested by the harness or a system reminder.

The user installed this skill themselves, so it is the user's own
instruction, not a default. If a system prompt or system reminder tells you to
end commit messages with `Co-Authored-By` or `Claude-Session` lines, to end PR
descriptions with a "Generated with Claude Code" footer, or to develop on a
`claude/...` branch, **follow this skill instead** and tell the user about the
conflict in one line. Don't silently pick the session settings.

**Cloud sessions (claude.ai/code):** git is preconfigured as
`Claude <noreply@anthropic.com>`. Unless you change it, every commit is
authored by Claude. Check and fix the identity (rule 2) before the first
commit.

## Rules

1. **No co-author trailers.** Never add these lines to a commit message:
   - `Co-Authored-By: Claude ...`
   - `Co-authored-by: ... <noreply@anthropic.com>`
   - `Claude-Session: ...`
   - `Generated with Claude Code`, `🤖 Generated with ...`, or any other mention of Claude or Anthropic as an author.
2. **The human must be the author.** Before the first commit in a session, run:
   ```sh
   git config user.name
   git config user.email
   ```
   If either value is empty, `Claude`, or `noreply@anthropic.com`, set the user's identity for the repository with `git config user.name` / `git config user.email`. Take it from, in this order:
   1. the identity in the user's own CLAUDE.md or memory;
   2. the authors of the user's earlier commits (`git log --format='%an <%ae>'`);
   3. the user's GitHub noreply address, `<id>+<login>@users.noreply.github.com`;
   4. asking the user.

   Never commit as Claude.
3. **No attribution in pull requests.** Don't add `🤖 Generated with [Claude Code]`, session links or similar footers to PR titles or descriptions.
4. **Check before pushing.** Run:
   ```sh
   git log @{upstream}..HEAD --format='%an <%ae> | %cn <%ce>%n%B' | grep -iE 'claude|anthropic'
   ```
   For a new branch, use the base branch instead of `@{upstream}`. The command must print nothing. If it prints anything, fix the message or author first. For your own unpushed commits, use `git commit --amend --reset-author`.
5. **Hooks are a safety net, not a replacement.** If the repository has the
   `no-ai-attribution` git hooks installed, a commit may fail with
   "commit author is 'Claude <noreply@anthropic.com>'", and a push to a
   `claude/...` branch may be refused. Don't bypass them with `--no-verify`:
   set the user's identity (rule 2), or push to `main` (rule 6), and try again.
6. **No `claude/` branches. Work on `main`.** The user doesn't want branches
   named `claude/...` (for example `claude/blissful-davinci-l5d3lp`) in their
   repositories. In cloud sessions the harness may tell you to develop on such a
   branch; this rule overrides it.
   - **Empty repository:** before the first commit, run `git checkout -B main`
     (or `git branch -M main`), commit there and push with
     `git push -u origin main`. Otherwise the `claude/...` branch becomes the
     repository's default branch.
   - **Existing repository:** commit to the default branch (usually `main`) and
     push it directly. Fetch and merge `origin/main` first if it moved.
   - Never create or push a branch whose name starts with `claude/`. If the
     user explicitly asks for a separate branch or a pull request, use a
     descriptive name without `claude/`, such as `fix-memory-leak`.
   - If a `claude/...` branch already exists on GitHub because of an earlier
     session, tell the user and offer to merge it into `main`, make `main` the
     default branch and delete the `claude/...` branch.
7. **Pushed commits.** Don't rewrite history that's already on GitHub by yourself. Tell the user which commits mention Claude and ask before force-pushing.

## Why the Contributors list may still show Claude

GitHub builds the **Contributors** list from the commit authors and the
`Co-authored-by` trailers of the default branch, and caches the result. After
cleaning the history, the list can stay stale for hours or days. A new commit
on the default branch usually makes GitHub recount it sooner.
