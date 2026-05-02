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
    - Ubic.: ~/.zsh/plugins/

  LSD & Bat
    - LSD: 'ls' moderno con iconos y colores
    - Bat: 'cat' con resaltado de sintaxis
    - Alias útil: alias ls='lsd', alias cat='bat'


🔧 HERRAMIENTAS BASE
─────────────────────────────────────────────────────────────────────────────

  Git
    - Control de versiones
    - Config inicial: git config --global user.name "Nombre"
    - Genera clave SSH: ssh-keygen -t ed25519 -C "email@example.com"

  Wget
    - Descargador de archivos desde línea de comandos
    - Uso: wget https://ejemplo.com/archivo.tar.gz

  OpenSSH
    - Conexiones SSH remota y segura
    - Servidor SSH: sshd (en Termux requiere servicio)
    - Cliente: ssh usuario@host

  FZF
    - Buscador fuzzy interactivo de archivos
    - Ctrl+R: búsqueda en historial
    - Ctrl+T: insertar nombre de archivo en comando

  Btop/Htop
    - Monitores de recursos del sistema
    - Btop: Más moderno y visual
    - Htop: Fallback si btop no está disponible


💻 ENTORNOS DE DESARROLLO
─────────────────────────────────────────────────────────────────────────────

  Neovim
    - Editor vim moderno y extensible
    - Instalación config: ~/.config/nvim/init.vim
    - Comando: nvim archivo.txt

  Clang (C/C++)
    - Compilador de C/C++ de LLVM
    - Compile: clang -o programa programa.c
    - C++: clang++ -o programa programa.cpp

  Go
    - Lenguaje compilado para aplicaciones rápidas
    - Workspace: ~/go/
    - Compilar: go build main.go

  Python
    - Lenguaje interpretado versátil
    - Gestor paquetes: pip install paquete
    - Virtual env: python3 -m venv venv

  Node.js
    - Runtime JavaScript en servidor
    - Gestor paquetes: npm
    - Framework popular: Express, Next.js


🤖 AGENTES IA
─────────────────────────────────────────────────────────────────────────────

  AIDER - Editor Asistido por IA
    ──────────────────────────────
    
    ¿Qué es?
      - Agente de IA que edita archivos de código automáticamente
      - Entiende contexto completo del proyecto
      - Genera cambios, refactorización, fixes automáticos

    Requisitos
      ✓ Python 3 (con pip)
      ✓ Conexión a Internet
      ✓ API Key de OpenAI (GPT-4) o Anthropic (Claude)

    Instalación
      $ ./bin/main.sh → Agentes IA → Aider
      El instalador:
        1. Verifica Python y pip
        2. Instala aider-chat
        3. Valida la instalación
        4. Guía configuración de API Key

    Configuración de API Key
      ────────────────────────
      
      Opción 1: OpenAI (GPT-4)
        1. Ve a: https://platform.openai.com/api-keys
        2. Crea una API Key nueva
        3. Copia la clave
        4. Añade a ~/.zshrc:
           export OPENAI_API_KEY='sk-...'
        5. Recarga: source ~/.zshrc

      Opción 2: Anthropic (Claude)
        1. Ve a: https://console.anthropic.com/
        2. Obtén tu API Key
        3. Añade a ~/.zshrc:
           export ANTHROPIC_API_KEY='sk-ant-...'
        4. Recarga: source ~/.zshrc

    Uso Básico
      ──────────
      $ aider                      # Editar archivos en directorio actual
      $ aider archivo.py           # Editar archivo específico
      $ aider src/                 # Editar carpeta completa
      
      En la sesión de Aider:
        - Describe qué quieres que haga
        - Aider lee todos los archivos
        - Hace cambios automáticos
        - Muestra diffs antes de aplicar
        - Presiona 'y' para aceptar cambios

    Ejemplos Prácticos
      ──────────────────
      
      "Añade docstrings a todas las funciones"
      "Refactoriza este código para ser más pythónico"
      "Corrige este bug en la lógica de autenticación"
      "Mejora el rendimiento de esta consulta"
      "Escribe tests unitarios para este módulo"

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
        → Intenta: export AIDER_MODEL=gpt-3.5-turbo

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

tip_aider() {
    cat << 'EOF'

╔════════════════════════════════════════════════════════════════════════════╗
║                     TIP: AIDER - Editor IA                                ║
╚════════════════════════════════════════════════════════════════════════════╝

Aider es un agente de IA que edita código automáticamente basado en tus
instrucciones en lenguaje natural.

✓ REQUIERE CONFIGURACIÓN:
  • Obtén una API Key (OpenAI o Anthropic)
  • Configura en ~/.zshrc: export OPENAI_API_KEY='tu-clave'
  • Recarga: source ~/.zshrc

✓ USO BÁSICO:
  $ aider                         # Sesión interactiva
  $ aider archivo.py otro.js      # Editar múltiples archivos
  $ aider src/                    # Editar carpeta completa

✓ EJEMPLOS:
  • "Añade type hints a todas las funciones"
  • "Refactoriza para mejor legibilidad"
  • "Escribe tests unitarios"
  • "Corrige este error de lógica"

✓ SOLUCIONAR PROBLEMAS:
  $ aider --version              # Verificar instalación
  $ echo $OPENAI_API_KEY         # Verificar API Key
  $ source ~/.zshrc              # Recargar variables

Más info: https://aider.chat/

EOF
}

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
            aider) tip_aider ;;
            zsh) tip_zsh ;;
            git) tip_git ;;
            neovim|nvim) tip_neovim ;;
            *) show_help ;;
        esac
    else
        show_help
    fi
fi
