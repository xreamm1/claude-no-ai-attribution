# claude-no-ai-attribution

Скилл для [Claude Code](https://code.claude.com), который не даёт Claude добавлять себя в авторы коммитов. С ним на GitHub не появляются надпись «you **and claude**» у коммита и `claude` в списке **Contributors**.

> 🇬🇧 *English summary below.*

## Почему Claude попадает в контрибьюторы

По умолчанию Claude Code добавляет в конец каждого коммита строку:

```
Co-Authored-By: Claude <noreply@anthropic.com>
```

GitHub считает такую строку соавторством. В облачных сессиях Claude иногда ещё и коммитит под своим именем: `Claude <noreply@anthropic.com>`.

## Что внутри

| Файл | Что делает |
|---|---|
| `skills/no-ai-attribution/SKILL.md` | Сам скилл. Запрещает строки `Co-Authored-By`, `Claude-Session` и `Generated with Claude Code`, требует, чтобы автором был человек, и проверять коммиты перед пушем. |
| `examples/settings.json` | Настройка Claude Code, которая полностью выключает автоматическую подпись. |
| `examples/CLAUDE.md` | Короткое правило для `CLAUDE.md`. Действует, даже если скилл не загрузился. |

Для надёжности ставьте все три части: настройка выключает подпись, а скилл и `CLAUDE.md` закрывают случаи, когда подпись добавляет не Claude Code, а инструкция окружения (например, в облачных сессиях).

## Установка

### Для всех проектов (рекомендуется)

```sh
git clone https://github.com/xreamm1/claude-no-ai-attribution
mkdir -p ~/.claude/skills
cp -r claude-no-ai-attribution/skills/no-ai-attribution ~/.claude/skills/
```

Добавьте в `~/.claude/settings.json` (если файл уже есть, просто допишите эти ключи):

```json
{
  "attribution": { "commit": "", "pr": "" },
  "includeCoAuthoredBy": false
}
```

Добавьте содержимое `examples/CLAUDE.md` в `~/.claude/CLAUDE.md`.

### Для одного репозитория

Скопируйте файлы в репозиторий и закоммитьте их. Тогда правило будет работать и в облачных сессиях claude.ai/code:

```
.claude/skills/no-ai-attribution/SKILL.md
.claude/settings.json
CLAUDE.md
```

## Если Claude уже есть в истории

Скилл действует только на новые коммиты. Старые нужно переписать: удалить строки `Co-Authored-By` и сменить автора, а затем сделать `git push --force`. Учтите, что force-push заменяет историю на GitHub.

После этого GitHub ещё какое-то время показывает Claude в **Contributors**: список кэшируется, обновление может занять от нескольких часов до пары дней. Новый коммит в основную ветку обычно ускоряет пересчёт.

## Лицензия

[MIT](LICENSE)

---

## English summary

This is a Claude Code skill that keeps Claude out of your git history. With it, Claude doesn't add `Co-Authored-By: Claude`, `Claude-Session` or `Generated with Claude Code` lines, and doesn't commit as `Claude <noreply@anthropic.com>`. Your commits stop showing "and claude", and Claude doesn't appear in a repository's Contributors list.

To install it, copy `skills/no-ai-attribution` to `~/.claude/skills/`. Then set `"attribution": {"commit": "", "pr": ""}` in `~/.claude/settings.json` and append `examples/CLAUDE.md` to your `~/.claude/CLAUDE.md`.
