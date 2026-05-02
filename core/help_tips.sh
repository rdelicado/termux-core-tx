#!/usr/bin/env bash

# CORE-TX Help Tips & Documentation
# Archivo de soporte con tips, guías y documentación de herramientas

# ============================================================================
# COLORES
# ============================================================================

CYAN='\033[0;36m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BOLD='\033[1m'
NC='\033[0m'

# ============================================================================
# AYUDA GENERAL
# ============================================================================

show_help() {
    cat << 'EOF'

╔════════════════════════════════════════════════════════════════════════════╗
║                  CORE-TX - AYUDA Y GUÍAS DE HERRAMIENTAS                  ║
╚════════════════════════════════════════════════════════════════════════════╝

🎨 APARIENCIA
─────────────────────────────────────────────────────────────────────────────

  ZSH + Oh My Zsh
    - Shell interactivo más avanzado que Bash
    - Oh My Zsh: Framework con plugins y temas
    - Para cambiar shell: chsh -s $(which zsh)

  Powerlevel10k
    - Tema rápido y personalizable para ZSH
    - Instalación automática: ejecuta 'p10k configure'
    - Requiere Nerd Fonts para ver iconos

  Nerd Fonts
    - Fuentes parcheadas con iconos y símbolos Unicode
    - Recomendada para usar con Powerlevel10k
    - Opciones: MesloLGS, Hack, JetBrains Mono, FiraCode

  Plugins ZSH
    - zsh-autosuggestions: Sugiere comandos del historial
    - zsh-syntax-highlighting: Colores en tiempo real mientras escribes

    Solución de Problemas
      ──────────────────
      
      Error: "API key not found"
        → Verifica que la variable de entorno esté definida
        → Recargar terminal: source ~/.zshrc
        → Verifica: echo $OPENAI_API_KEY

      Error: "Connection timeout"
        → Verifica conexión a Internet
        → Algunos países/redes bloquean APIs de IA

      Respuestas lentas
        → Normal para GPT-4 (5-30 segundos)
        → GPT-3.5 es más rápido pero menos preciso

      Cambios no se aplican
        → Revisa que hayas presionado 'y' para confirmar
        → Verifica permisos de archivo: chmod +w archivo


╔════════════════════════════════════════════════════════════════════════════╗
║                          KEYBOARD SHORTCUTS                               ║
╚════════════════════════════════════════════════════════════════════════════╝

j/k o ↑↓        → Navegar menús
Enter/Space     → Seleccionar opción
q/Esc           → Volver/Salir
A               → Instalar todo (en submenús)
Ctrl+C          → Interrumpir instalación

EOF
}

# ============================================================================
# TIPS POR HERRAMIENTA
# ============================================================================

tip_zsh() {
    cat << 'EOF'

╔════════════════════════════════════════════════════════════════════════════╗
║                   TIP: ZSH - Shell Interactivo                            ║
╚════════════════════════════════════════════════════════════════════════════╝

ZSH es un shell POSIX más avanzado que Bash con mejor autocompletado y
características interactivas.

✓ CAMBIAR A ZSH:
  $ chsh -s $(which zsh)
  (Requiere reiniciar la sesión)

✓ PRIMEROS PASOS:
  - Copiar archivo .zshrc de muestra: cp ~/.zshrc.pre-oh-my-zsh ~/.zshrc
  - O ejecutar: zsh
  - Seguir asistente interactivo

✓ ATAJOS ÚTILES:
  Alt+.           → Última palabra del comando anterior
  Ctrl+[/]        → Navegar directorios con flechas
  Ctrl+a/e        → Inicio/fin de línea
  Ctrl+w          → Eliminar palabra anterior

✓ CARACTERÍSTICAS:
  - Globbing avanzado: ls **/*.txt (recursivo)
  - Corrección de faltas en directorios
  - Autocompletado contextual
  - Extensiones con Oh My Zsh

EOF
}

tip_git() {
    cat << 'EOF'

╔════════════════════════════════════════════════════════════════════════════╗
║                   TIP: GIT - Control de Versiones                         ║
╚════════════════════════════════════════════════════════════════════════════╝

Git es el sistema de control de versiones más popular.

✓ CONFIGURACIÓN INICIAL:
  $ git config --global user.name "Tu Nombre"
  $ git config --global user.email "tu@email.com"

✓ GENERAR CLAVE SSH:
  $ ssh-keygen -t ed25519 -C "tu@email.com"
  $ cat ~/.ssh/id_ed25519.pub
  (Copiar a GitHub, GitLab, etc.)

✓ COMANDOS BÁSICOS:
  $ git init                      # Inicializar repo
  $ git clone URL                 # Clonar repositorio
  $ git add .                     # Preparar cambios
  $ git commit -m "mensaje"       # Hacer commit
  $ git push                      # Enviar a remoto
  $ git pull                      # Recibir cambios

✓ TIPS:
  - Usa commits pequeños y descriptivos
  - .gitignore para ignorar archivos
  - git status para ver estado actual
  - git log para ver historial

EOF
}

tip_neovim() {
    cat << 'EOF'

╔════════════════════════════════════════════════════════════════════════════╗
║                   TIP: NEOVIM - Editor Modal                              ║
╚════════════════════════════════════════════════════════════════════════════╝

Neovim es una versión moderna de Vim optimizada y extensible.

✓ MODOS PRINCIPALES:
  - Normal:   Navegación y comandos (Esc para entrar)
  - Insert:   Escribir texto (i, a, o para entrar)
  - Visual:   Seleccionar texto (v para entrar)
  - Command:  Ejecutar comandos (: para entrar)

✓ ATAJOS BÁSICOS (modo Normal):
  i, a, o     → Insertar texto
  h, j, k, l  → Mover cursor (← ↓ ↑ →)
  w, b, e     → Navegar palabras
  dd          → Eliminar línea
  yy          → Copiar línea
  p, P        → Pegar
  /, ?        → Buscar
  %, {, }     → Navegar bloques

✓ PRIMEROS PASOS:
  $ nvim archivo.txt              # Abrir archivo
  i (escribir) Esc :wq            # Guardar y salir

✓ CONFIGURACIÓN:
  ~/.config/nvim/init.vim         # Archivo de config
  ~/.config/nvim/init.lua         # O en Lua (recomendado)

EOF
}

# ============================================================================
# FUNCIÓN PRINCIPAL - MOSTRAR AYUDA
# ============================================================================

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if [[ -n "$1" ]]; then
        case "$1" in
            zsh) tip_zsh ;;
            git) tip_git ;;
            neovim|nvim) tip_neovim ;;
            *) show_help ;;
        esac
    else
        show_help
    fi
fi
