<div align="center">

<h1>claude-no-ai-attribution</h1>

<p>Скилл для Claude Code, который не даёт Claude добавлять себя в соавторы ваших коммитов и в контрибьюторы на GitHub.</p>

<p>
<img src="https://flagcdn.com/20x15/gb.png" width="20" height="15" alt="gb"> <a href="README.md">English</a> |
<img src="https://flagcdn.com/20x15/ru.png" width="20" height="15" alt="ru"> <a href="README.ru.md"><b>Русский</b></a> |
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

## Зачем

По умолчанию Claude Code добавляет в конец каждого коммита строку:

```
Co-Authored-By: Claude <noreply@anthropic.com>
```

GitHub считает её соавторством. Из-за этого у коммитов появляется надпись **«вы and claude»**, а **claude** попадает в список **Contributors**. В некоторых окружениях, например в облачных сессиях, Claude ещё и коммитит под своим именем.

С этим скиллом автором остаётесь только вы.

## Что внутри

| Файл | Что делает |
|---|---|
| [`skills/no-ai-attribution/SKILL.md`](skills/no-ai-attribution/SKILL.md) | Сам скилл. Запрещает строки `Co-Authored-By`, `Claude-Session` и `Generated with Claude Code`, делает автором человека и проверяет коммиты перед каждым пушем. |
| [`examples/settings.json`](examples/settings.json) | Настройка Claude Code, которая выключает встроенную подпись. |
| [`examples/CLAUDE.md`](examples/CLAUDE.md) | Короткое правило для `CLAUDE.md`. Работает, даже если скилл не загрузился. |
| [`hooks/no-ai-attribution.sh`](hooks/no-ai-attribution.sh) | Запускается автоматически при старте сессии, даже если модель проигнорирует скилл. Ставит вас автором коммитов, вырезает строки подписи из каждого коммита блокирует коммиты от имени `Claude <noreply@anthropic.com>` и не даёт пушить ветки `claude/...`. В пустом репозитории сразу переключает работу на `main`. |
| [`install.sh`](install.sh) | Ставит всё одной командой. `--name` и `--email` задают автора коммитов. Они нужны для облачных сессий claude.ai/code, где git заранее настроен на имя Claude. |

> [!IMPORTANT]
> Одного скилла (например, загруженного в claude.ai) **недостаточно**. В облачных сессиях Claude считает настройки сессии («добавь Co-Authored-By», «работай в ветке `claude/...`») важнее скилла. А вот `CLAUDE.md` из репозитория он выполняет, а хуки срабатывают при любом решении модели. Поэтому ставьте всё в каждый репозиторий через `install.sh` (см. ниже) и коммитьте `.claude/` и `CLAUDE.md`.

## Установка

**Для всех проектов:**

```sh
git clone https://github.com/xreamm1/claude-no-ai-attribution
sh claude-no-ai-attribution/install.sh --name "Your Name" --email "you@example.com"
```

Скрипт копирует скилл в `~/.claude/skills/`, прописывает `"attribution": {"commit": "", "pr": ""}` в `~/.claude/settings.json` (остальные настройки сохраняются) и один раз добавляет правило в `~/.claude/CLAUDE.md`. После установки перезапустите Claude Code.

**Для одного репозитория:**

```sh
sh claude-no-ai-attribution/install.sh path/to/your-repo --name "Your Name" --email "you@example.com"
```

Затем закоммитьте `.claude/` и `CLAUDE.md`. Тогда правило действует и в облачных сессиях claude.ai/code, и у всех, кто работает с Claude в этом репозитории.

**Вручную:** скопируйте `skills/no-ai-attribution` в `~/.claude/skills/`, добавьте ключи из `examples/settings.json` в свой `settings.json`, а текст `examples/CLAUDE.md` — в свой `CLAUDE.md`.

## Claude уже есть в истории

Скилл действует только на новые коммиты. Старые нужно переписать: убрать строки `Co-Authored-By` и сменить автора, затем выполнить `git push --force`. Force-push заменяет историю на GitHub, поэтому заранее предупредите соавторов.

После этого GitHub ещё от нескольких часов до пары дней может показывать Claude в **Contributors**: список кэшируется. Новый коммит в основную ветку обычно ускоряет обновление.

## Лицензия

[MIT](LICENSE)
