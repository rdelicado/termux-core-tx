# Termux Toolkit — Agent Guide

> CORE-TX | Environment Manager para Termux

## 🎯 Proyecto

Instalador y gestor modular de entornos de desarrollo para Termux (Android). También compatible con Linux (testing) y macOS.

**Objetivo**: Que un usuario con Termux instale un entorno de desarrollo completo con un menú interactivo.

## 📐 Arquitectura

```
bin/
  main.sh              ← Punto de entrada (bootstrap + menú)
core/
  detection.sh         ← Detecta OS (android/linux/darwin) + package manager
  utils.sh             ← Banner, colores, funciones de instalación/desinstalación
  menu.sh              ← TUI interactivo con tput (todos los submenús)
  logger.sh            ← Logging con rotación por timestamp
  backup.sh            ← Backup de .zshrc y configs críticas
  installers.sh        ← Helpers de instalación genéricos
  updater.sh           ← Auto-actualización del toolkit
  uninstaller.sh       ← Desinstaladores con confirmación + cascada
modules/
  01-appearance/       ← ZSH, OMZ, Powerlevel10k, lsd, bat, fuentes
  02-base-tools/       ← Git, wget, openssh, fzf, btop/htop
  03-dev-env/          ← Neovim, Clang, Go, Python, Node.js
  04-multiplexers/     ← tmux
  05-proot/            ← proot-distro (Debian, Alpine)
  06-dotfiles/         ← Symlinks de dotfiles
```

## ️ Reglas Críticas

### 1. Termux Primero

Este proyecto se ejecuta **exclusivamente en Termux (Android)**. Linux es solo para testing.

- **Banner**: Siempre alineado a la izquierda (sin centrado). El centrado rompe el layout en pantallas de Termux.
- **TUI**: Usa `tput` — siempre disponible con `ncurses-utils`. No asumas que `dialog` o `whiptail` existen.
- **Permisos**: En Android, siempre verificar `$HOME/storage` y pedir `termux-setup-storage`.
- **Fuentes**: Termux usa fuentes monospace limitadas. Evitar caracteres Unicode complejos en el banner.

### 2. Shell Bash

- **Bash 5.0+** es el mínimo. No usar features de ZSH en los scripts.
- **Shebang**: `#!/usr/bin/env bash` (no `#!/bin/bash` — en Termux está en `/data/data/com.termux/files/usr/bin/bash`).
- **Compatibilidad**: No usar `[[ ... ]]` con regex complejas. Preferir `case` o `grep`.

### 3. Package Managers

| OS | Package Manager | Notas |
|----|----------------|-------|
| android | `pkg` | No requiere sudo. `pkg update` antes de instalar si falla |
| linux | `apt` | Requiere `sudo`. Usar `apt-get` para scripts |
| darwin | `brew` | No requiere sudo. `brew update` antes si falla |

**Regla**: Siempre usar `detect_os` + `get_package_manager` de `core/detection.sh`. No hardcodear.

### 4. Estructura de Módulos

Cada módulo en `modules/XX-nombre/` debe tener:

- `install.sh` — Contiene funciones de instalación (sourceable)
- Funciones nombradas como `install_<nombre>` (ej: `install_neovim`)
- No ejecutar nada al ser sourced — solo definir funciones

**Ejemplo correcto**:
```bash
# modules/02-base-tools/install.sh
install_all_basetools() {
    install_package "git"
    install_package "wget"
    # ...
}
```

### 5. TUI (Menu)

- El menú principal está en `core/menu.sh`
- Usa `tput smcup`/`tput rmcup` para pantalla alternativa
- Cursor invisible con `tput civis`/`tput cnorm`
- Navegación: `↑/↓` o `k/j`, `Enter` para seleccionar, `q` para salir
- **NO** usar `dialog`, `whiptail`, `fzf` para el menú principal
- El banner debe renderizarse ANTES de cada redraw del menú

### 6. Logging

- Logs en `$PROJECT_ROOT/logs/install_<timestamp>.log`
- Usar `log_info`, `log_success`, `log_warning`, `log_error` de `core/logger.sh`
- Cada log incluye timestamp, OS, usuario, hostname
- Resumen al final con `log_summary`

### 7. Backups

- **SIEMPRE** backup de `~/.zshrc` antes de modificarlo
- Usar `backup_zshrc` de `core/backup.sh`
- Backup automático con timestamp: `~/.zshrc.backup.YYYYMMDD_HHMMSS`

### 8. Desinstalación

- Cada herramienta tiene función `uninstall_<nombre>` en `core/uninstaller.sh`
- **Confirmación obligatoria** con `confirm_uninstall` antes de eliminar
- Git está PROTEGIDO — `uninstall_git` siempre retorna error
- Desinstaladores con cascada: ZSH cascade elimina OMZ, P10k, plugins, .zshrc

## 🔧 Comandos Útiles

```bash
# Ejecutar el toolkit
bash bin/main.sh

# Sourcear un módulo para testing
source modules/01-appearance/install.sh
install_all_appearance

# Ver logs recientes
bash bin/main.sh  # -> Ver Logs
```

## 🎨 Convenciones de Código

### Colores

Usar las variables definidas en `core/utils.sh`:
- `RED`, `GREEN`, `YELLOW`, `BLUE`, `CYAN`, `MAGENTA`
- `BOLD`, `GRAY`, `NC` (no color)
- Colores del menú en `core/menu.sh`: `COLOR_TITLE`, `COLOR_SELECTED`, etc.

### Mensajes

Usar las funciones de `core/utils.sh`:
- `print_info "Mensaje"`
- `print_success "Mensaje"`
- `print_warning "Mensaje"`
- `print_error "Mensaje"`
- `print_header "Título"`

### Funciones

- Nombres en `snake_case`
- Prefijos claros: `install_`, `uninstall_`, `show_`, `detect_`, `get_`, `log_`
- Retornar 0 en éxito, 1 en error
- No usar `exit` dentro de funciones (usar `return`)

##  Testing

No hay framework de tests automatizados. Testing manual:

1. **En Termux**: Probar instalación completa, verificar que todo funcione
2. **En Linux**: Probar que `detect_os` retorna "linux", que `apt` se usa correctamente
3. **Verificar logs**: `cat logs/*.log` después de cada instalación

## 🚫 Anti-Patrones

- ❌ Hardcodear paths (`/usr/bin/bash`, `/data/data/...`)
- ❌ Usar `sudo` en Termux (no existe)
-  Modificar `~/.zshrc` sin backup
- ❌ Usar caracteres Unicode complejos en el banner
- ❌ Centrar el banner (rompe en Termux)
- ❌ Usar `dialog`/`whiptail` (no están disponibles)
- ❌ Ejecutar código al sourcear módulos
- ❌ Usar `exit` en funciones (rompe el menú)
- ❌ Olvidar `return 1` en errores

##  Checklist para Nuevos Módulos

- [ ] Carpeta `modules/XX-nombre/` con número correcto
- [ ] `install.sh` con funciones `install_<nombre>`
- [ ] Funciones no ejecutan al ser sourced
- [ ] Usa `install_package` de `core/utils.sh`
- [ ] Logging con `log_info`/`log_success`/`log_error`
- [ ] Confirmación antes de acciones destructivas
- [ ] Backup de configs si modifica `.zshrc` o similares
- [ ] Entrada en el menú principal (`core/menu.sh`)
- [ ] Entrada en el desinstalador (`core/uninstaller.sh`)
- [ ] Probado en Termux y Linux

## 🔗 Enlaces

- [Termux Wiki](https://wiki.termux.com/wiki/Main_Page)
- [proot-distro](https://github.com/termux/proot-distro)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
