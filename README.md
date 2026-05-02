```
 ██████╗ ██████╗ ██████╗ ███████╗    ████████╗██╗  ██╗
██╔════╝██╔═══██╗██╔══██╗██╔════╝    ╚══██╔══╝╚██╗██╔╝
██║     ██║   ██║██████╔╝█████╗ █████╗██║   ███╔╝█╗
██║     ██║   ██║██╔══██╗██╔══╝ ╚════╝██║   ██╔═╝███║
╚██████╗╚██████╔╝██║  ██║███████╗    ██║   ██║   ╚██║
 ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝    ╚═╝   ╚═╝    ╚═╝

Environment Manager for Termux & WSL2
```

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Termux%20%7C%20Linux%20%7C%20WSL2-brightgreen?style=flat-square" alt="Platform">
  <img src="https://img.shields.io/badge/Shell-Bash%205.0%2B-blue?style=flat-square" alt="Shell">
  <img src="https://img.shields.io/badge/License-MIT-yellow?style=flat-square" alt="License">
  <img src="https://img.shields.io/badge/Status-Production%20Ready-success?style=flat-square" alt="Status">
</p>

---

## 📋 Descripción

**CORE-TX** es un gestor de entornos profesional diseñado para automatizar la configuración, instalación y gestión de pilas de desarrollo completas en **Termux** (Android), **Linux** y **WSL2**. 

Transforma tu terminal móvil o portátil en una estación de trabajo de desarrollador completamente funcional en minutos, con un sistema de instalación inteligente, desinstalación en cascada, y una interfaz TUI fluida sin parpadeos.

---

## ✨ Características Principales

### 🖥️ **TUI Zero-Flicker**
Interfaz gráfica de terminal moderna y fluida, optimizada para dispositivos móviles y WSL2. Navegación responsiva sin parpadeos mediante:
- Flechas direccionales (↑ ↓)
- Atajos Vim (j/k para navegar)
- Enter para seleccionar
- q para salir

### 🎨 **Gestor de Fuentes (Nerd Fonts)**
Instalación automática de fuentes parcheadas y aplicación en caliente:
- Meslo, Hack, JetBrains Mono, FiraCode
- `termux-reload-settings` integrado
- Compatibilidad con emojis y símbolos Unicode

### 🧹 **Desinstalador Inteligente (Smart Uninstaller)**
Resolución automática de dependencias en cascada:
- Borrar ZSH → limpia plugins, themes, restaura Bash
- Protección de herramientas críticas (Git, OpenSSH)
- Rollback seguro de configuraciones

### 📊 **Monitor de Estado Visual**
Pantalla limpia y en tiempo real que evalúa:
- ✅ Herramientas instaladas
- ❌ Herramientas faltantes
- Categorización por módulo
- Código de colores intuitivo

### 💾 **Sistema de Backups Automáticos**
Respaldos automáticos de configuraciones sensibles:
- `.zshrc`, `.bashrc`, archivos de dotfiles
- Historial de cambios para rollback
- Compresión e historial versionado

### 📦 **Instalaciones Masivas**
- Botones "Instalar Todo" por categoría
- Instalación global con un click
- Resolución automática de dependencias
- Logs detallados de cada operación

### 🕵️ **Detección Inteligente de SO**
Adaptación automática según plataforma:
- Android (Termux)
- Linux (Debian, Ubuntu, Alpine)
- macOS (Darwin)
- WSL2

---

## 🧩 Módulos Disponibles

### 🎨 **Apariencia & Personalización**
Crea una terminal visualmente atractiva y altamente productiva:
- **ZSH** con Oh My Zsh desatendido
- **Powerlevel10k** - Tema ultrarrápido y personalizable
- **Plugins Esenciales** - Autosuggestions, Syntax Highlighting
- **LSD** - Versión moderna y colorida de `ls`
- **Bat** - Visor de código con resaltado de sintaxis
- **Nerd Fonts** - Fuentes parcheadas para emojis y símbolos

### 🔧 **Herramientas Base & Utilidades**
Herramientas fundamentales para desarrolladores:
- **Git** - Control de versiones
- **Wget** - Descarga de archivos
- **OpenSSH** - Conexiones remotas seguras
- **FZF** - Buscador de archivos borroso y rápido
- **Btop/Htop** - Monitorización de recursos del sistema

### 💻 **Entornos de Desarrollo**
Compiladores y runtimes listos para producción:
- **Neovim** - Editor de texto avanzado y extensible
- **Clang/GCC** - Compiladores C/C++ profesionales
- **Go** - Lenguaje de programación compilado
- **Python 3** - Soporte completo con pip
- **Node.js** - Runtime y npm para JavaScript

---

## 🚀 Inicio Rápido

### 1. Instalación

```bash
# Clonar el repositorio
git clone https://github.com/rdelicado/termux-core-tx.git

# Acceder al directorio
cd termux-core-tx

# Hacer ejecutable el script principal
chmod +x bin/main.sh

# Ejecutar CORE-TX
./bin/main.sh
```

### 2. Navegación & Uso

Una vez dentro de la interfaz:

| Acción | Tecla(s) |
|--------|----------|
| Navegar arriba | `↑` o `k` |
| Navegar abajo | `↓` o `j` |
| Seleccionar | `Enter` / `Space` |
| Salir/Atrás | `q` / `Esc` |
| Instalar Todo (categoría) | `A` |

### 3. Menú Principal

```
┌─────────────────────────────────────┐
│  CORE-TX • Gestor de Entornos      │
├─────────────────────────────────────┤
│ 1. Apariencia                      │
│ 2. Herramientas Base               │
│ 3. Entornos de Desarrollo          │
│ 4. Instalar Todo                   │
│ 5. Ver Estado                      │
│ 6. Ver Logs                        │
│ 0. Salir                           │
└─────────────────────────────────────┘
```

---

## 📂 Estructura del Proyecto

```
termux-core-tx/
├── bin/
│   └── main.sh               # Punto de entrada principal
├── core/
│   ├── detection.sh          # Detección de SO (Android/Linux/macOS)
│   ├── utils.sh              # Funciones auxiliares y colores
│   ├── menu.sh               # Motor de menús TUI
│   ├── backup.sh             # Sistema de backups automáticos
│   ├── logger.sh             # Sistema de logging
│   ├── installers.sh         # Instaladores base
│   └── uninstaller.sh        # Desinstalador inteligente
├── modules/
│   ├── 01-appearance/        # Módulo de Apariencia
│   │   ├── install.sh        # Instalador principal
│   │   ├── zsh.sh           # Configuración de ZSH
│   │   └── fonts.sh         # Gestor de Nerd Fonts
│   ├── 02-base-tools/        # Herramientas Base
│   │   └── install.sh        # Instalador de utilidades
│   └── 03-dev-env/           # Entornos de Desarrollo
│       └── install.sh        # Instalador de compiladores/runtimes
├── templates/                # Dotfiles y configs predefinidas
├── backups/                  # Backups automáticos de configuración
├── logs/                     # Historial de instalaciones
├── AGENTS.md                 # Documentación de arquitectura
├── README.md                 # Este archivo
└── LICENSE                   # Licencia MIT

```

### Descripción de Directorios

| Carpeta | Propósito |
|---------|-----------|
| `bin/` | Punto de entrada y ejecutables principales |
| `core/` | Motor interno: detección, menús, backups, logging |
| `modules/` | Scripts de instalación modular y categorizados |
| `templates/` | Archivos de configuración predefinida (dotfiles) |
| `backups/` | Respaldos automáticos de configuraciones |
| `logs/` | Registro detallado de todas las operaciones |

---

## 🔄 Flujo de Trabajo Típico

1. **Iniciar** → `./bin/main.sh`
2. **Seleccionar módulo** → Navegar con flechas o j/k
3. **Ver estado** → Opción 5 muestra qué está instalado
4. **Instalar** → Seleccionar herramienta o "Instalar Todo"
5. **Verificar logs** → Opción 6 muestra detalles de ejecución
6. **Desinstalar (opcional)** → Sistema en cascada que limpia dependencias

---

## 📊 Requisitos Previos

- **Termux** (Android 7+) o **Linux** (Debian/Ubuntu/Alpine) o **WSL2**
- **Bash 5.0+**
- **Git** (se instala automáticamente si falta)
- ~500 MB de espacio disponible (depende de módulos)

---

## 🛠️ Desarrollo & Extensión

### Crear un Nuevo Módulo

1. Crear directorio: `modules/04-my-tools/`
2. Implementar `install.sh` con función `install_module()`
3. Registrar en `core/menu.sh`

### Sistema de Logging

Todos los eventos se registran automáticamente en `logs/` para auditoría y debugging.

---

## 📝 Licencia

© 2025 **rdelicado**

CORE-TX está bajo la licencia **MIT**. Eres libre de usar, modificar y distribuir este software con fines comerciales y personales, siempre que incluyas la atribución original.

Véase [LICENSE](./LICENSE) para más detalles.

---

## 🤝 Contribuir

¡Las contribuciones son bienvenidas y valoradas! 

Cómo participar:
1. Fork el repositorio
2. Crea una rama para tu feature (`git checkout -b feature/nueva-herramienta`)
3. Commit tus cambios (`git commit -m 'Add: nueva herramienta'`)
4. Push a la rama (`git push origin feature/nueva-herramienta`)
5. Abre un Pull Request

---

## 📧 Soporte

¿Problemas o preguntas?

- Abre un [Issue en GitHub](https://github.com/rdelicado/termux-core-tx/issues)
- Revisa los logs: `cat logs/install.log`
- Consulta [AGENTS.md](./AGENTS.md) para arquitectura detallada

---

## 🙏 Agradecimientos

CORE-TX fue inspirado en las necesidades de desarrolladores móviles y WSL2 que buscan un entorno profesional sin complicaciones.

---

**Hecho con ❤️ para la comunidad de Termux y Linux**
