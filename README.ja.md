<div align="center">

<h1>claude-no-ai-attribution</h1>

<p>Claude がコミットの共同作成者や GitHub のコントリビューターとして自分を追加しないようにする Claude Code スキルです。</p>

<p>
<img src="https://flagcdn.com/20x15/gb.png" width="20" height="15" alt="gb"> <a href="README.md">English</a> |
<img src="https://flagcdn.com/20x15/ru.png" width="20" height="15" alt="ru"> <a href="README.ru.md">Русский</a> |
<img src="https://flagcdn.com/20x15/es.png" width="20" height="15" alt="es"> <a href="README.es.md">Español</a> |
<img src="https://flagcdn.com/20x15/cn.png" width="20" height="15" alt="cn"> <a href="README.zh-CN.md">简体中文</a> |
<img src="https://flagcdn.com/20x15/jp.png" width="20" height="15" alt="jp"> <a href="README.ja.md"><b>日本語</b></a>
</p>

<p>
<a href="https://github.com/xreamm1/claude-no-ai-attribution/releases/latest"><img alt="Release" src="https://img.shields.io/github/v/release/xreamm1/claude-no-ai-attribution?style=for-the-badge&color=0a7bbb"></a>
<a href="https://code.claude.com"><img alt="Claude Code skill" src="https://img.shields.io/badge/Claude%20Code-skill-d97757?style=for-the-badge"></a>
<a href="install.sh"><img alt="Shell POSIX sh" src="https://img.shields.io/badge/shell-POSIX%20sh-4eaa25?style=for-the-badge&logo=gnubash&logoColor=white"></a>
<a href="LICENSE"><img alt="License MIT" src="https://img.shields.io/github/license/xreamm1/claude-no-ai-attribution?style=for-the-badge&color=6aa84f"></a>
<a href="https://github.com/xreamm1/claude-no-ai-attribution/stargazers"><img alt="Stars" src="https://img.shields.io/github/stars/xreamm1/claude-no-ai-attribution?style=for-the-badge&color=e3b341"></a>
</p>

</div>

## なぜ必要か

Claude Code はデフォルトで、すべてのコミットメッセージの末尾に次の行を追加します。

```
Co-Authored-By: Claude <noreply@anthropic.com>
```

GitHub はこの行を共同作成者として扱います。その結果、コミットには **「あなた and claude」** と表示され、リポジトリの **Contributors** に **claude** が載ります。クラウドセッションなど一部の環境では、Claude が自分の名前でコミットすることもあります。

このスキルを使えば、作成者はあなただけになります。

## 内容

| ファイル | 役割 |
|---|---|
| [`skills/no-ai-attribution/SKILL.md`](skills/no-ai-attribution/SKILL.md) | スキル本体。`Co-Authored-By`、`Claude-Session`、`Generated with Claude Code` の行を禁止し、コミットの作成者を人間にして、プッシュ前にコミットを確認します。 |
| [`examples/settings.json`](examples/settings.json) | Claude Code の組み込みの署名をオフにする設定です。 |
| [`examples/CLAUDE.md`](examples/CLAUDE.md) | `CLAUDE.md` 用の短いルールです。スキルが読み込まれなくても機能します。 |
| [`hooks/no-ai-attribution.sh`](hooks/no-ai-attribution.sh) | セッション開始時に自動で実行され、モデルがスキルを無視しても機能します。コミットの作成者をあなたに設定し、すべてのコミットメッセージから署名行を削除し、`Claude <noreply@anthropic.com>` が作成者のコミットをブロックし、`claude/...` ブランチのプッシュを拒否します。空のリポジトリでは最初から `main` で作業します。 |
| [`install.sh`](install.sh) | すべてを 1 つのコマンドでインストールします。`--name` と `--email` でコミットの作成者を指定します。git が Claude として事前設定されている claude.ai/code のクラウドセッションでは必須です。 |

## インストール

**すべてのプロジェクトに適用：**

```sh
git clone https://github.com/xreamm1/claude-no-ai-attribution
sh claude-no-ai-attribution/install.sh --name "Your Name" --email "you@example.com"
```

スクリプトはスキルを `~/.claude/skills/` にコピーし、`~/.claude/settings.json` に `"attribution": {"commit": "", "pr": ""}` を設定し（ほかの設定はそのまま残ります）、`~/.claude/CLAUDE.md` にルールを一度だけ追加します。その後 Claude Code を再起動してください。

**1 つのリポジトリだけに適用：**

```sh
sh claude-no-ai-attribution/install.sh path/to/your-repo --name "Your Name" --email "you@example.com"
```

その後 `.claude/` と `CLAUDE.md` をコミットします。これで claude.ai/code のクラウドセッションや、そのリポジトリで Claude を使う全員にもルールが適用されます。

**手動：** `skills/no-ai-attribution` を `~/.claude/skills/` にコピーし、`examples/settings.json` のキーを自分の `settings.json` に、`examples/CLAUDE.md` の内容を自分の `CLAUDE.md` に追加します。

## 履歴にすでに Claude がいる場合

スキルが効くのは新しいコミットだけです。古いコミットは書き換える必要があります。`Co-Authored-By` の行を削除して作成者を変更し、`git push --force` を実行してください。強制プッシュは GitHub 上の履歴を置き換えるので、事前に共同作業者に知らせてください。

その後もリストがキャッシュされているため、GitHub の **Contributors** には数時間から数日ほど Claude が表示されることがあります。デフォルトブランチに新しいコミットをプッシュすると、たいてい早く更新されます。

## ライセンス

[MIT](LICENSE)
