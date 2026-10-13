<div align="center">

<h1>claude-no-ai-attribution</h1>

<p>Claude がコミットの共同作成者や GitHub のコントリビューターとして自分を追加しないようにする Claude Code スキルです。</p>

<h3>🧹 <code>/no-ai-attribution</code></h3>

<p><b>クリーンアップコマンドです。Claude Code で入力すると、Claude がリポジトリから消えます。<code>claude/...</code> ブランチは <code>main</code> に移り、Claude は作成者、共同作成者、コミットメッセージから削除されます。</b></p>

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

## クイックスタート：`/no-ai-attribution`

1. [`SKILL.md`](https://github.com/xreamm1/claude-no-ai-attribution/releases/latest/download/SKILL.md) をダウンロードしてスキルとして追加します。claude.ai でアップロードする（**Settings → Capabilities → Skills**）か、`~/.claude/skills/no-ai-attribution/SKILL.md` に置きます。
2. リポジトリで Claude Code のセッションを開き、次のように入力します。

   ```
   /no-ai-attribution
   ```

これだけです。Claude は次のことを行います。

- すべての `claude/...` ブランチの作業を **`main`** に移し、`claude/...` ブランチを削除します。
- **すべてのブランチ**（`main`、`dev` など）の履歴から Claude を取り除きます。Claude が作成者のコミットはあなたのものになり、`Co-Authored-By`、`Claude-Session`、「Generated with Claude Code」の行は消えます。コード自体は変わりません。
- 以降のすべてのコミットの作成者をあなただけにし、`main` で作業を続けます。

このコマンドを入力すると、ブランチの履歴の書き換えと強制プッシュに同意したことになるため、Claude は改めて確認しません。リポジトリのデフォルトブランチがまだ `claude/...` の場合、Claude は `main` に切り替える（**Settings → General → Default branch**）よう依頼するので、もう一度コマンドを入力してください。**Contributors** のリストはキャッシュされているため、GitHub では数時間ほど古い表示が残ることがあります。

## 内容

| ファイル | 役割 |
|---|---|
| [`skills/no-ai-attribution/SKILL.md`](skills/no-ai-attribution/SKILL.md) | スキル本体。`Co-Authored-By`、`Claude-Session`、`Generated with Claude Code` の行を禁止し、コミットの作成者を人間にして、プッシュ前にコミットを確認します。 |
| [`examples/settings.json`](examples/settings.json) | Claude Code の組み込みの署名をオフにする設定です。 |
| [`examples/CLAUDE.md`](examples/CLAUDE.md) | `CLAUDE.md` 用の短いルールです。スキルが読み込まれなくても機能します。 |
| [`SKILL.md` → `.claude/hooks/no-ai-attribution.sh`](skills/no-ai-attribution/SKILL.md) | セッション開始時に自動で実行され、モデルがスキルを無視しても機能します。コミットの作成者をあなたに設定し、すべてのコミットメッセージから署名行を削除し、`Claude <noreply@anthropic.com>` が作成者のコミットをブロックし、`claude/...` ブランチのプッシュを拒否します。空のリポジトリでは最初から `main` で作業します。 |
| [`install.sh`](install.sh) | すべてを 1 つのコマンドでインストールします。`--name` と `--email` でコミットの作成者を指定します。git が Claude として事前設定されている claude.ai/code のクラウドセッションでは必須です。 |

> [!IMPORTANT]
> スキルだけ（たとえば claude.ai にアップロードしたもの）では**不十分**です。クラウドセッションでは、Claude はセッションの設定（「Co-Authored-By を追加」「`claude/...` ブランチで作業」）をスキルより優先します。一方、リポジトリの `CLAUDE.md` には従い、フックはモデルの判断に関係なく動作します。そのため、`install.sh`（下記参照）で各リポジトリにすべてをインストールし、`.claude/` と `CLAUDE.md` をコミットしてください。

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
