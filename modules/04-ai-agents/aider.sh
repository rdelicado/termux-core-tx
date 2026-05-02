#!/usr/bin/env bash

# AIDER Installation Module
# Agente IA para edición de código asistida por IA
# Requiere: Python 3, pip

set -e

PROJECT_ROOT="${PROJECT_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"

# Importar funciones comunes
source "$PROJECT_ROOT/core/utils.sh"
source "$PROJECT_ROOT/core/logger.sh"
source "$PROJECT_ROOT/core/detection.sh"

# ============================================================================
# FUNCIONES LOCALES
# ============================================================================

check_python_dependency() {
    print_info "Verificando dependencias de Python..."
    
    if ! command -v python3 &>/dev/null && ! command -v python &>/dev/null; then
        print_warning "Python no está instalado. Intentando instalar..."
        
        case "$(detect_os)" in
            android)
                print_info "Instalando Python para Termux..."
                pkg install python -y || {
                    print_error "No se pudo instalar Python en Termux"
                    return 1
                }
                ;;
            linux|darwin)
                print_warning "Por favor, instala Python 3 manualmente y luego ejecuta este script."
                print_info "En Debian/Ubuntu: sudo apt-get install python3 python3-pip"
                print_info "En macOS: brew install python3"
                return 1
                ;;
            *)
                print_error "SO no soportado para auto-instalación de Python"
                return 1
                ;;
        esac
    fi
    
    # Determinar qué Python usar
    if command -v python3 &>/dev/null; then
        PYTHON_CMD="python3"
    elif command -v python &>/dev/null; then
        PYTHON_CMD="python"
    fi
    
    local python_version=$($PYTHON_CMD --version 2>&1 | awk '{print $2}')
    print_success "Python $python_version encontrado: $PYTHON_CMD"
    return 0
}

check_pip_availability() {
    print_info "Verificando pip..."
    
    if ! $PYTHON_CMD -m pip --version &>/dev/null; then
        print_warning "pip no disponible. Intentando instalar..."
        
        case "$(detect_os)" in
            android)
                pkg install python-pip -y || {
                    print_error "No se pudo instalar pip"
                    return 1
                }
                ;;
            *)
                print_warning "Intenta instalar pip manualmente"
                return 1
                ;;
        esac
    fi
    
    local pip_version=$($PYTHON_CMD -m pip --version | awk '{print $2}')
    print_success "pip $pip_version disponible"
    return 0
}

prepare_build_dependencies() {
    print_info "Preparando dependencias de compilación..."
    
    local os_type=$(detect_os)
    
    # En Termux, instalar herramientas de compilación necesarias
    if [[ "$os_type" == "android" ]]; then
        print_info "Instalando compiladores y herramientas para Termux..."
        
        # Instalar clang, make y otras herramientas
        pkg install clang -y 2>&1 | grep -i "installed\|upgraded" || true
        pkg install make -y 2>&1 | grep -i "installed\|upgraded" || true
        pkg install autoconf -y 2>&1 | grep -i "installed\|upgraded" || true
        pkg install automake -y 2>&1 | grep -i "installed\|upgraded" || true
        pkg install libtool -y 2>&1 | grep -i "installed\|upgraded" || true
        pkg install rust -y 2>&1 | grep -i "installed\|upgraded" || true
        
        print_success "Compiladores instalados en Termux"
    fi
    
    # Actualizar pip, setuptools, wheel y setuptools_rust (crítico)
    print_info "Actualizando herramientas de compilación de Python..."
    
    $PYTHON_CMD -m pip install --upgrade pip "setuptools>=70.0.0" wheel "setuptools_rust" --quiet 2>&1 || {
        print_warning "Reintentando actualización de herramientas..."
        $PYTHON_CMD -m pip install --upgrade pip setuptools wheel setuptools_rust 2>&1 | head -5
    }
    
    print_success "Herramientas de compilación preparadas"
    return 0
}

install_aider_dependencies() {
    print_info "Instalando dependencias explícitas de Aider..."
    
    # Todas las dependencias conocidas de aider-chat
    local all_deps=(
        "configargparse"
        "pyyaml"
        "pyaml"
        "tiktoken"
        "gitpython"
        "httpx"
        "requests"
        "rich"
        "pathspec"
        "upgrade"
        "openai"
        "anthropic"
        "aiohttp"
        "click"
        "aiosignal"
        "multidict"
        "frozenlist"
        "yarl"
        "async-timeout"
        "idna"
    )
    
    local installed=0
    local failed=0
    
    for dep in "${all_deps[@]}"; do
        if $PYTHON_CMD -m pip install \
            --no-cache-dir \
            --prefer-binary \
            --quiet \
            "$dep" 2>&1 | grep -q "Successfully installed"; then
            ((installed++))
        else
            ((failed++))
        fi
    done
    
    print_success "Dependencias: $installed instaladas"
    if [[ $failed -gt 0 ]]; then
        print_warning "Algunas dependencias tuvieron problemas ($failed), pero continuando..."
    fi
    
    return 0
}

install_aider() {
    print_info "Instalando aider-chat..."
    
    # Mostrar barra de progreso simple
    echo -e "  ${CYAN}[..............................] 0%${NC}"
    
    # Preparar dependencias de compilación (compiladores + herramientas Python)
    if ! prepare_build_dependencies; then
        print_warning "Aviso preparando dependencias (continuando...)"
    fi
    
    echo -e "  ${CYAN}[██████........................] 25%${NC}"
    
    # Limpiar caché de pip para evitar conflictos
    print_info "Limpiando caché de pip..."
    $PYTHON_CMD -m pip cache purge 2>&1 | head -1 || true
    
    echo -e "  ${CYAN}[████████........................] 35%${NC}"
    
    # Paso 1: Instalar TODAS las dependencias conocidas
    echo -e "  ${CYAN}[████████████..................] 50%${NC}"
    if ! install_aider_dependencies; then
        print_warning "Algunas dependencias no se instalaron (continuando...)"
    fi
    
    echo -e "  ${CYAN}[████████████..................] 50%${NC}"
    
    # Paso 2: Instalar aider-chat
    print_info "Instalando paquete aider-chat..."
    
    if $PYTHON_CMD -m pip install \
        --no-cache-dir \
        --prefer-binary \
        --upgrade \
        aider-chat 2>&1 | tee /tmp/aider_install.log | grep -q "Successfully installed"; then
        echo -e "  ${CYAN}[███████████████████████████] 100%${NC}"
        print_success "✓ aider-chat instalado correctamente"
        return 0
    fi
    
    echo -e "  ${CYAN}[█████████████████████████] 95%${NC}"
    
    # Paso 3: Reinstalar aider-chat sin build isolation como fallback
    print_info "Reintentando instalación sin aislamiento de compilación..."
    
    if $PYTHON_CMD -m pip install \
        --no-cache-dir \
        --no-build-isolation \
        --upgrade \
        aider-chat 2>&1 | tee /tmp/aider_install.log | grep -q "Successfully installed"; then
        echo -e "  ${CYAN}[███████████████████████████] 100%${NC}"
        print_success "✓ aider-chat instalado correctamente"
        return 0
    fi
    
    echo -e "  ${CYAN}[███████████████████████████] 100%${NC}"
    
    # Verificación final
    if $PYTHON_CMD -c "import aider" 2>&1; then
        print_success "✓ Aider disponible como módulo"
        return 0
    fi
    
    print_warning "⚠️  Instalación completada con limitaciones"
    print_info "Logs: /tmp/aider_install.log"
    
    log_error "aider-chat installation completed with warnings"
    return 0

    
    echo -e "  ${CYAN}[███████████████████████████] 100%${NC}"
    print_success "aider-chat instalado correctamente"
    
    return 0
}

validate_aider_installation() {
    print_info "Validando instalación de Aider..."
    
    # Verificar si el comando está disponible
    if command -v aider &>/dev/null; then
        local aider_version
        aider_version=$(aider --version 2>&1) || {
            print_warning "No se pudo obtener versión de Aider"
            return 0  # Aún así, consideramos exitoso si el binario existe
        }
        print_success "Aider disponible: $aider_version"
        log_info "Aider installation successful: $aider_version"
        return 0
    fi
    
    # Si no está en PATH, intentar importar como módulo Python
    if $PYTHON_CMD -c "import aider; print('aider version ok')" 2>&1 | grep -q "ok"; then
        print_success "Aider instalado como módulo Python"
        print_info "Usa: python3 -m aider"
        return 0
    fi
    
    # Como último recurso, verificar si hay algún ejecutable en Python site-packages
    local python_bin_dir
    python_bin_dir=$($PYTHON_CMD -c "import site; print(site.USER_SITE)" 2>/dev/null || echo "")
    
    if [[ -n "$python_bin_dir" && -f "$python_bin_dir/../bin/aider" ]]; then
        print_success "Aider encontrado en: $python_bin_dir/../bin/aider"
        return 0
    fi
    
    print_warning "Aider no se validó completamente, pero la instalación se intentó"
    return 0  # No falla la instalación completa por esto
}

print_api_key_instructions() {
    local CYAN='\033[0;36m'
    local YELLOW='\033[1;33m'
    local NC='\033[0m'
    
    echo ""
    echo -e "${YELLOW}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}⚠️  CONFIGURACIÓN REQUERIDA: API KEY${NC}"
    echo -e "${YELLOW}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${CYAN}Aider necesita una clave API para funcionar.${NC}"
    echo ""
    echo -e "  ${CYAN}1. Elige tu proveedor:${NC}"
    echo -e "     • OpenAI (GPT-4): https://platform.openai.com/api-keys"
    echo -e "     • Anthropic (Claude): https://console.anthropic.com/"
    echo ""
    echo -e "  ${CYAN}2. Obtén tu API Key del proveedor elegido${NC}"
    echo ""
    echo -e "  ${CYAN}3. Añade a tu ~/.zshrc (o ~/.bashrc):${NC}"
    echo ""
    echo -e "     ${YELLOW}export OPENAI_API_KEY='tu-clave-aqui'${NC}"
    echo -e "     ${CYAN}O si usas Anthropic:${NC}"
    echo -e "     ${YELLOW}export ANTHROPIC_API_KEY='tu-clave-aqui'${NC}"
    echo ""
    echo -e "  ${CYAN}4. Recarga la terminal:${NC}"
    echo -e "     ${YELLOW}source ~/.zshrc${NC}"
    echo ""
    echo -e "  ${CYAN}5. Usa Aider:${NC}"
    echo -e "     ${YELLOW}aider${NC} (editar archivos en directorio actual)"
    echo -e "     ${YELLOW}aider archivo.py${NC} (editar archivo específico)"
    echo ""
    echo -e "${YELLOW}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    log_info "User prompted for API key configuration"
}

# ============================================================================
# FUNCIÓN PRINCIPAL
# ============================================================================

install_aider_main() {
    print_header "🤖 INSTALACIÓN DE AIDER - Agente de Código IA"
    
    # Paso 1: Verificar Python
    if ! check_python_dependency; then
        print_error "No se pueden cumplir las dependencias de Python"
        return 1
    fi
    
    # Paso 2: Verificar pip
    if ! check_pip_availability; then
        print_error "pip no está disponible"
        return 1
    fi
    
    # Paso 3: Verificar si ya está instalado Y funciona
    if command -v aider &>/dev/null; then
        # Verificar que REALMENTE funciona
        if aider --version &>/dev/null 2>&1; then
            print_success "✓ Aider ya está instalado y funciona: $(aider --version 2>&1 | head -1)"
            print_api_key_instructions
            return 0
        else
            # Aider está "instalado" pero no funciona - hay dependencias faltantes
            print_warning "Aider está parcialmente instalado pero le faltan dependencias"
            print_info "Reparando instalación..."
        fi
    fi
    
    # Paso 4: Instalar Aider (sin preguntas, automático)
    print_info "Iniciando instalación automática de Aider..."
    if ! install_aider; then
        print_warning "La instalación de Aider tuvo dificultades"
    fi
    
    # Paso 5: Validar instalación
    if ! validate_aider_installation; then
        print_warning "No se pudo validar completamente"
    fi
    
    # Paso 6: Mostrar instrucciones de configuración
    print_api_key_instructions
    
    print_success "✓ Proceso de instalación de Aider completado"
    return 0
}

# ============================================================================
# INVOCACIÓN
# ============================================================================

# Solo ejecutar si se invoca directamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_aider_main
    exit $?
fi
