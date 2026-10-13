<div align="center">

<h1>claude-no-ai-attribution</h1>

<p>一个 Claude Code 技能（skill），阻止 Claude 把自己添加为提交的共同作者和 GitHub 贡献者。</p>

<p>
<img src="https://flagcdn.com/20x15/gb.png" width="20" height="15" alt="gb"> <a href="README.md">English</a> |
<img src="https://flagcdn.com/20x15/ru.png" width="20" height="15" alt="ru"> <a href="README.ru.md">Русский</a> |
<img src="https://flagcdn.com/20x15/es.png" width="20" height="15" alt="es"> <a href="README.es.md">Español</a> |
<img src="https://flagcdn.com/20x15/cn.png" width="20" height="15" alt="cn"> <a href="README.zh-CN.md"><b>简体中文</b></a> |
<img src="https://flagcdn.com/20x15/jp.png" width="20" height="15" alt="jp"> <a href="README.ja.md">日本語</a>
</p>

<p>
<a href="https://github.com/xreamm1/claude-no-ai-attribution/tags"><img alt="Release" src="https://img.shields.io/github/v/tag/xreamm1/claude-no-ai-attribution?label=release&style=for-the-badge&color=0a7bbb"></a>
<a href="https://code.claude.com"><img alt="Claude Code skill" src="https://img.shields.io/badge/Claude%20Code-skill-d97757?style=for-the-badge"></a>
<a href="install.sh"><img alt="Shell POSIX sh" src="https://img.shields.io/badge/shell-POSIX%20sh-4eaa25?style=for-the-badge&logo=gnubash&logoColor=white"></a>
<a href="LICENSE"><img alt="License MIT" src="https://img.shields.io/github/license/xreamm1/claude-no-ai-attribution?style=for-the-badge&color=6aa84f"></a>
<a href="https://github.com/xreamm1/claude-no-ai-attribution/stargazers"><img alt="Stars" src="https://img.shields.io/github/stars/xreamm1/claude-no-ai-attribution?style=for-the-badge&color=e3b341"></a>
</p>

</div>

## 为什么需要

默认情况下，Claude Code 会在每条提交信息末尾添加：

```
Co-Authored-By: Claude <noreply@anthropic.com>
```

GitHub 会把这一行视为共同作者。于是你的提交会显示 **"你 and claude"**，仓库的 **Contributors** 列表里也会出现 **claude**。在某些环境（例如云端会话）中，Claude 还可能以自己的名字提交。

使用这个技能后，作者只有你自己。

## 包含内容

| 文件 | 作用 |
|---|---|
| [`skills/no-ai-attribution/SKILL.md`](skills/no-ai-attribution/SKILL.md) | 技能本身。禁止 `Co-Authored-By`、`Claude-Session` 和 `Generated with Claude Code` 行，确保提交作者是人，并在每次推送前检查提交。 |
| [`examples/settings.json`](examples/settings.json) | 关闭 Claude Code 内置署名的设置。 |
| [`examples/CLAUDE.md`](examples/CLAUDE.md) | 写入 `CLAUDE.md` 的简短规则，即使技能未加载也能生效。 |
| [`install.sh`](install.sh) | 一条命令安装以上三部分。 |

## 安装

**用于所有项目：**

```sh
git clone https://github.com/xreamm1/claude-no-ai-attribution
sh claude-no-ai-attribution/install.sh
```

脚本会把技能复制到 `~/.claude/skills/`，在 `~/.claude/settings.json` 中设置 `"attribution": {"commit": "", "pr": ""}`（保留你的其他设置），并在 `~/.claude/CLAUDE.md` 中添加一次规则。安装后请重启 Claude Code。

**仅用于一个仓库：**

```sh
sh claude-no-ai-attribution/install.sh path/to/your-repo
```

然后提交 `.claude/` 和 `CLAUDE.md`。这样规则也会作用于 claude.ai/code 的云端会话，以及在该仓库中使用 Claude 的所有人。

**手动安装：** 把 `skills/no-ai-attribution` 复制到 `~/.claude/skills/`，把 `examples/settings.json` 中的键加入你的 `settings.json`，把 `examples/CLAUDE.md` 的内容加入你的 `CLAUDE.md`。

## 历史记录里已经有 Claude 了

技能只影响新的提交。要清理旧提交，需要重写它们：删除 `Co-Authored-By` 行并更改作者，然后执行 `git push --force`。强制推送会替换 GitHub 上的历史记录，请先通知协作者。

之后，由于列表有缓存，GitHub 可能还会在 **Contributors** 中显示 Claude 几个小时到几天。在默认分支上推送一个新提交通常能让它更快更新。

## 许可证

[MIT](LICENSE)
