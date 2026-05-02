# 🤖 Agentes IA - Módulo CORE-TX

## Aider: Editor Asistido por Inteligencia Artificial

Módulo para instalar y configurar **Aider**, un agente de IA que edita código automáticamente basado en instrucciones en lenguaje natural.

---

## 📋 Tabla de Contenidos

- [¿Qué es Aider?](#qué-es-aider)
- [Requisitos](#requisitos)
- [Instalación](#instalación)
- [Configuración](#configuración)
- [Uso](#uso)
- [Ejemplos Prácticos](#ejemplos-prácticos)
- [Troubleshooting](#troubleshooting)
- [Estructura del Módulo](#estructura-del-módulo)

---

## ¿Qué es Aider?

**Aider** es un agente de programación impulsado por inteligencia artificial que:

- 🔧 **Edita código automáticamente** basado en instrucciones en lenguaje natural
- 📖 **Lee y entiende** el contexto completo de tu proyecto
- 💾 **Aplica cambios** directamente en tus archivos
- 🎯 **Refactoriza, corrige bugs, mejora código**
- ⚡ **Funciona en terminal** - sin GUI ni complicaciones

### Casos de Uso

| Caso | Descripción |
|------|------------|
| **Refactorización** | "Convierte este código a más pythónico" |
| **Generación de Tests** | "Escribe tests unitarios para este módulo" |
| **Bug Fixing** | "Hay un error en la lógica de autenticación, corrígelo" |
| **Documentación** | "Añade docstrings a todas las funciones" |
| **Migración** | "Migra este código de Python 2 a Python 3" |
| **Optimización** | "Mejora el rendimiento de esta consulta" |

---

## Requisitos

### Requisitos del Sistema

- **Python 3.7+** (con pip)
- **Conexión a Internet** estable
- **~200 MB** de espacio en disco
- **Linux, macOS, Termux (Android)** o **WSL2**

### Requisitos de API

Debes tener una clave API de uno de estos proveedores:

1. **OpenAI** (Recomendado - GPT-4)
   - URL: https://platform.openai.com/api-keys
   - Requiere tarjeta de crédito
   - $0.03/1K tokens (aproximadamente)

2. **Anthropic** (Claude)
   - URL: https://console.anthropic.com/
   - Alternativa a OpenAI
   - Precios similares

---

## Instalación

### Método 1: Desde CORE-TX (Recomendado)

```bash
cd ~/proyectos/termux/termux-toolkit
./bin/main.sh

# En el menú principal:
# Opción 4: "Agentes IA"
# Opción 1: "Aider (Editor asistido por IA)"
```

El instalador automáticamente:
1. ✅ Verifica que Python 3 esté instalado
2. ✅ Verifica que pip esté disponible
3. ✅ Instala `aider-chat` via pip
4. ✅ Valida la instalación
5. ✅ Muestra instrucciones de configuración

### Método 2: Instalación Manual

```bash
# Instalar aider-chat
pip install aider-chat

# Verificar instalación
aider --version
```

---

## Configuración

### Paso 1: Obtener API Key

#### OpenAI (GPT-4)

1. Ve a: https://platform.openai.com/api-keys
2. Click en **"Create new secret key"**
3. Copia la clave (formato: `sk-...`)
4. Guárdala en lugar seguro

#### Anthropic (Claude)

1. Ve a: https://console.anthropic.com/
2. Navega a **API Keys**
3. Click en **"Create Key"**
4. Copia la clave (formato: `sk-ant-...`)
5. Guárdala en lugar seguro

### Paso 2: Configurar Variable de Entorno

#### Opción A: En ZSH (.zshrc)

```bash
# Editar ~/.zshrc
nano ~/.zshrc

# Añadir una de estas líneas al final:

# Para OpenAI:
export OPENAI_API_KEY='sk-...'

# O para Anthropic:
export ANTHROPIC_API_KEY='sk-ant-...'

# Guardar: Ctrl+O, Ctrl+X
```

Luego recargar:
```bash
source ~/.zshrc
```

#### Opción B: En Bash (.bashrc)

```bash
# Editar ~/.bashrc
nano ~/.bashrc

# Añadir la variable
export OPENAI_API_KEY='sk-...'

# Recargar
source ~/.bashrc
```

### Paso 3: Verificar Configuración

```bash
# Verificar que la variable existe
echo $OPENAI_API_KEY

# Debe mostrar: sk-... (primeros caracteres de tu clave)

# Verificar que aider puede acceder
aider --version
```

---

## Uso

### Comando Básico

```bash
# Iniciar sesión interactiva en directorio actual
aider

# Editar archivo específico
aider archivo.py

# Editar múltiples archivos
aider src/utils.py src/main.py

# Editar carpeta completa
aider src/
```

### Dentro de Aider

Una vez dentro de la sesión:

```
Enter one or more files or a directory:
> archivo.py

Then type prompts to edit the code...
> Añade docstrings a todas las funciones

Aider> 
```

### Flujo Típico

1. **Specify files** - Dile a Aider qué archivos editar
2. **Write prompt** - Describe qué quieres que haga
3. **Review changes** - Aider muestra los diffs propuestos
4. **Accept/Reject** - Presiona `y` para aceptar o `n` para rechazar
5. **Continue** - Haz más cambios o escribe `exit` para salir

---

## Ejemplos Prácticos

### Ejemplo 1: Añadir Docstrings

```bash
$ aider app.py

Enter files to edit:
> app.py

Aider> Añade docstrings en formato NumPy a todas las funciones

# Aider analiza el código y propone cambios
# Presiona 'y' para aceptar

✓ Docstrings añadidos
```

### Ejemplo 2: Refactorizar a Async/Await

```bash
$ aider database.py

Aider> Convierte todas las funciones de IO bloqueantes a async/await con asyncio

# Propone cambios significativos
# Presiona 'y' para aceptar
```

### Ejemplo 3: Escribir Tests

```bash
$ aider src/ test/

Aider> Escribe tests unitarios con pytest para todas las funciones en src/

# Crea archivo test_*.py con cobertura
```

### Ejemplo 4: Bugfix

```bash
$ aider calculator.py

Aider> Hay un bug en la división por cero. El código debería lanzar ValueError si divisor es 0.

# Aider identifica el lugar y añade validación
```

### Ejemplo 5: Migración de Dependencias

```bash
$ aider requirements.txt app.py

Aider> Actualiza a Django 5.0 y adapta todo el código accordingly

# Actualiza imports, cambios de API, etc.
```

---

## Atajos y Comandos en Sesión

| Comando | Efecto |
|---------|--------|
| `/exit` o `/quit` | Salir de Aider |
| `/add archivo.py` | Añadir archivo a sesión |
| `/drop archivo.py` | Remover archivo de sesión |
| `/help` | Mostrar ayuda interna |
| `/model gpt-3.5-turbo` | Cambiar modelo IA |
| `y` | Aceptar cambios propuestos |
| `n` | Rechazar cambios |

---

## Troubleshooting

### Error: "API key not found"

**Solución:**
```bash
# Verificar que la variable está definida
echo $OPENAI_API_KEY

# Si está vacía, recargar shell
source ~/.zshrc

# Reintentar
aider --version
```

### Error: "Connection timeout"

**Solución:**
- Verificar conexión a Internet: `ping google.com`
- Algunos países/ISPs bloquean APIs OpenAI
- Intentar con VPN: `export HTTP_PROXY=http://...`
- Usar Anthropic en lugar de OpenAI

### Error: "Module not found"

**Solución:**
```bash
# Reinstalar aider
pip install --upgrade aider-chat

# O desde CORE-TX
./bin/main.sh → Agentes IA → Aider
```

### Respuestas muy lentas

**Causas y soluciones:**

| Problema | Solución |
|----------|----------|
| GPT-4 es lento | Usar GPT-3.5: `export AIDER_MODEL=gpt-3.5-turbo` |
| Red lenta | Verificar ancho de banda disponible |
| Proyecto muy grande | Editar archivos específicos, no carpetas enteras |

### Cambios no se aplican

**Solución:**
```bash
# Verificar permisos de archivo
ls -la archivo.py
chmod +w archivo.py  # Si es necesario

# Intentar de nuevo
aider archivo.py
# Presionar 'y' para confirmar (no 'n')
```

### Python/pip no encontrado

**Para Termux:**
```bash
pkg install python -y
pkg install python-pip -y

# O desde CORE-TX (auto-instala)
./bin/main.sh → Agentes IA → Aider
```

**Para Linux:**
```bash
sudo apt update
sudo apt install python3 python3-pip -y
```

---

## Estructura del Módulo

```
modules/04-ai-agents/
├── aider.sh              # Script de instalación (✓ ejecutable)
├── README.md             # Este archivo
└── .gitkeep              # Placeholder para versión control
```

### Archivo: `aider.sh`

**Funciones principales:**

- `check_python_dependency()` - Verifica/instala Python
- `check_pip_availability()` - Verifica/instala pip
- `install_aider()` - Instala aider-chat
- `validate_aider_installation()` - Valida post-instalación
- `print_api_key_instructions()` - Muestra instrucciones coloridas
- `install_aider_main()` - Función orquestadora

**Características de seguridad:**

✅ No oculta errores (sin `2>/dev/null`)
✅ Detecta automáticamente SO (Android/Linux/macOS)
✅ Usa `$PROJECT_ROOT` para rutas relativas
✅ Validación de cada paso
✅ Logs en `$PROJECT_ROOT/logs/`

---

## Integración con CORE-TX

### Menú Principal

```
Opción 4: "Agentes IA"
├─ Opción 1: "Aider (Editor asistido por IA)"
└─ Volver
```

### Vista de Estado

```bash
./bin/main.sh → Opción 5: "Ver Estado"

# Mostará:
AGENTES IA
  ✅ aider [INSTALADO]    # Si está instalado
  ❌ aider [FALTA]        # Si no está instalado
```

### Logs

Todas las instalaciones se registran en:
```
logs/install.log
logs/aider_*.log
```

---

## Mejores Prácticas

### 1. Edita Archivos Específicos

```bash
# ✅ BIEN - archivos específicos
aider src/utils.py src/main.py

# ❌ EVITAR - carpeta completa (lento)
aider src/
```

### 2. Prompts Claros y Concisos

```bash
# ✅ BIEN
Aider> Añade type hints en formato PEP 484 a todas las funciones

# ❌ EVITAR - vago
Aider> Mejora esto
```

### 3. Review de Cambios Antes de Aceptar

```bash
# Aider siempre muestra diffs antes de aplicar
# Revisa cuidadosamente antes de presionar 'y'
# Puedes rechazar con 'n' y reintentar con instrucciones diferentes
```

### 4. Usa Commits de Git

```bash
# Antes de usar Aider
git add .
git commit -m "Before Aider: estado inicial"

# Después de cambios importantes
git add .
git commit -m "Aider: refactor functions to async"

# Si algo sale mal, puedes hacer rollback
git revert HEAD
```

### 5. Empieza Pequeño

```bash
# Primero: editar un archivo pequeño
aider src/utils.py

# Luego: tareas más complejas
aider src/
```

---

## Costos Estimados

### OpenAI (GPT-4)

- **Input:** $0.03 por 1K tokens
- **Output:** $0.06 por 1K tokens
- **Estimación:** $0.10 - $1.00 por sesión típica

### Anthropic (Claude)

- **Input:** $0.003 por 1K tokens
- **Output:** $0.015 por 1K tokens
- **Estimación:** $0.01 - $0.50 por sesión típica

**Consejo:** Usa `export AIDER_MODEL=gpt-3.5-turbo` para reducir costos 10x.

---

## Recursos Adicionales

- 📚 **Documentación Oficial:** https://aider.chat/
- 🐛 **Reportar Bugs:** https://github.com/paul-gauthier/aider/issues
- 💬 **Comunidad Discord:** https://discord.gg/aider
- 📖 **Guía Completa:** https://aider.chat/docs/

---

## FAQ

### ¿Puedo usar Aider sin API Key?

No. Aider requiere una API Key válida de OpenAI o Anthropic para funcionar.

### ¿Es seguro poner la API Key en .zshrc?

Relativamente seguro si tu máquina es personal. Para producción, considera:
- Variables de entorno del sistema
- Gestor de secretos (pass, 1Password)
- Variables cifradas en CI/CD

### ¿Qué pasa si excedo mi cuota API?

OpenAI/Anthropic bloquearán requests. Deberás recargar tu cuenta o reducir uso.

### ¿Funciona offline?

No. Aider requiere conexión para acceder a los modelos IA en la nube.

### ¿Puedo usar Aider con modelos locales?

Sí, pero requerirá configuración manual. Ver: https://aider.chat/docs/local-mode.html

---

## Soporte

Para problemas o preguntas:

1. **Dentro de CORE-TX:** `./bin/main.sh` → Ver Logs
2. **Help Local:** `bash core/help_tips.sh aider`
3. **Documentación:** https://aider.chat/
4. **Issues del Proyecto:** GitHub de termux-core-tx

---

**Última actualización:** Mayo 2026

Creado con ❤️ para CORE-TX - Environment Manager para Termux
