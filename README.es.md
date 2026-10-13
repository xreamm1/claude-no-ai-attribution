<div align="center">

<h1>claude-no-ai-attribution</h1>

<p>Un skill de Claude Code que impide que Claude se añada como coautor de tus commits y como colaborador en GitHub.</p>

<p>
<img src="https://flagcdn.com/20x15/gb.png" width="20" height="15" alt="gb"> <a href="README.md">English</a> |
<img src="https://flagcdn.com/20x15/ru.png" width="20" height="15" alt="ru"> <a href="README.ru.md">Русский</a> |
<img src="https://flagcdn.com/20x15/es.png" width="20" height="15" alt="es"> <a href="README.es.md"><b>Español</b></a> |
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

## Por qué

Por defecto, Claude Code añade al final de cada mensaje de commit:

```
Co-Authored-By: Claude <noreply@anthropic.com>
```

GitHub interpreta esa línea como coautoría. Tus commits muestran **"tú and claude"** y **claude** aparece en la lista de **Contributors** del repositorio. En algunos entornos, como las sesiones en la nube, Claude también puede hacer commits con su propio nombre.

Con este skill, solo tú eres el autor.

## Contenido

| Archivo | Qué hace |
|---|---|
| [`skills/no-ai-attribution/SKILL.md`](skills/no-ai-attribution/SKILL.md) | El skill. Prohíbe las líneas `Co-Authored-By`, `Claude-Session` y `Generated with Claude Code`, hace que el autor sea la persona y revisa los commits antes de cada push. |
| [`examples/settings.json`](examples/settings.json) | Ajuste de Claude Code que desactiva la atribución integrada. |
| [`examples/CLAUDE.md`](examples/CLAUDE.md) | Una regla breve para `CLAUDE.md`. Funciona aunque el skill no se cargue. |
| [`install.sh`](install.sh) | Instala las tres partes con un solo comando. |

## Instalación

**Para todos tus proyectos:**

```sh
git clone https://github.com/xreamm1/claude-no-ai-attribution
sh claude-no-ai-attribution/install.sh
```

El script copia el skill a `~/.claude/skills/`, establece `"attribution": {"commit": "", "pr": ""}` en `~/.claude/settings.json` (conserva tus demás ajustes) y añade la regla a `~/.claude/CLAUDE.md` una sola vez. Después reinicia Claude Code.

**Para un solo repositorio:**

```sh
sh claude-no-ai-attribution/install.sh path/to/your-repo
```

Luego haz commit de `.claude/` y `CLAUDE.md`. Así la regla también se aplica a las sesiones en la nube de claude.ai/code y a cualquiera que use Claude en ese repositorio.

**Manualmente:** copia `skills/no-ai-attribution` a `~/.claude/skills/`, añade las claves de `examples/settings.json` a tu `settings.json` y el texto de `examples/CLAUDE.md` a tu `CLAUDE.md`.

## Claude ya está en mi historial

El skill solo afecta a los commits nuevos. Para limpiar los antiguos, reescríbelos: elimina las líneas `Co-Authored-By`, cambia el autor y ejecuta `git push --force`. Un force-push reemplaza el historial en GitHub, así que avisa antes a tus colaboradores.

Después, GitHub puede seguir mostrando a Claude en **Contributors** entre unas horas y un par de días, porque la lista se almacena en caché. Un commit nuevo en la rama principal suele acelerar la actualización.

## Licencia

[MIT](LICENSE)
