# ⚡ CORE-TX: Mobile Systems Kernel

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Termux%20%7C%20WSL2-brightgreen" alt="Platform">
  <img src="https://img.shields.io/badge/Shell-Bash%20%2F%20ZSH-blue" alt="Shell">
  <img src="https://img.shields.io/badge/License-MIT-yellow" alt="License">
</p>

**CORE-TX** es un toolkit modular e interactivo diseñado para automatizar la configuración y personalización de entornos de desarrollo en **Termux** y **WSL2**. Con una interfaz optimizada para terminales móviles, permite transformar una consola básica en una estación de trabajo profesional en segundos.

---

## 🚀 Características Principales

- 📱 **Mobile-First UI:** Interfaz diseñada específicamente para pantallas de smartphones.
- 🧩 **Arquitectura Modular:** Instala solo lo que necesites (Apariencia, Herramientas o Entornos Dev).
- 🛡️ **Seguridad:** Sistema de backups automáticos para tus archivos de configuración (`.zshrc`, etc.).
- 🕵️ **Detección Inteligente:** Detecta automáticamente si estás en Android (Termux) o Linux (WSL2/Ubuntu).
- 📜 **Logging:** Registro detallado de cada instalación para facilitar la resolución de errores.

---

## 🛠️ Herramientas Incluidas

### 🎨 Apariencia
- **ZSH & Oh My Zsh:** El motor de tu terminal.
- **Powerlevel10k:** El tema más rápido y personalizable.
- **Plugins:** Autosuggestions y Syntax Highlighting.
- **LSD & Bat:** Versiones modernas y coloridas de `ls` y `cat`.

### 🔧 Herramientas Base
- **FZF & Zoxide:** Navegación ultra rápida por directorios.
- **Git & Lazygit:** Gestión de repositorios desde la terminal.
- **Btop:** Monitorización de sistema con estilo.

### 💻 Entornos de Desarrollo
- **Neovim:** Editor de texto avanzado.
- **Compiladores:** Soporte para C/C++, Go, Python y Node.js.

---

## 📥 Instalación

Para desplegar CORE-TX en tu dispositivo, ejecuta los siguientes comandos:

```bash
# Instalar dependencias básicas
pkg update && pkg upgrade
pkg install git -y

# Clonar el repositorio
git clone git clone https://github.com/rdelicado/termux-core-tx.git

# Acceder y ejecutar
cd termux-core-tx
chmod +x bin/main.sh
./bin/main.sh
```
## 📂 Estructura del Proyecto

```text
termux-core-tx/
├── bin/          # Punto de entrada (main.sh)
├── core/         # Lógica interna y motores
├── modules/      # Scripts de instalación modular
├── templates/    # Archivos de configuración predefinidos
└── logs/         # Historial de instalaciones
```

## 🤝 Contribuir
¡Las contribuciones son bienvenidas! Si tienes una idea para un nuevo módulo o una mejora visual, no dudes en abrir un Issue o enviar un Pull Request.

## 📄 Licencia
Este proyecto está bajo la licencia MIT. Consulta el archivo LICENSE para más detalles.
