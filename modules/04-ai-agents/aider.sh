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
    
    # Actualizar pip, setuptools y wheel
    print_info "Actualizando pip, setuptools y wheel..."
    
    if ! $PYTHON_CMD -m pip install --upgrade pip "setuptools>=70.0.0" wheel --quiet 2>&1 | tee -a /dev/null; then
        print_warning "Aviso al actualizar herramientas de compilación (continuando...)"
    else
        print_success "Herramientas de compilación actualizadas"
    fi
    
    return 0
}

install_aider() {
    print_info "Instalando aider-chat..."
    
    # Mostrar barra de progreso simple
    echo -e "  ${CYAN}[..............................] 0%${NC}"
    
    if $PYTHON_CMD -m pip install --upgrade pip --quiet 2>&1 | grep -v "already satisfied" > /dev/null; then
        echo -e "  ${CYAN}[██████........................] 25%${NC}"
    fi
    
    # Preparar dependencias de compilación (setuptools, wheel)
    if ! prepare_build_dependencies; then
        print_error "No se pudieron preparar las dependencias de compilación"
        return 1
    fi
    
    echo -e "  ${CYAN}[████████████..................] 50%${NC}"
    
    # Instalación principal - SIN silenciar errores
    # Usar --only-binary para evitar compilar numpy/cryptography en Termux
    print_info "Ejecutando: $PYTHON_CMD -m pip install --only-binary :all: aider-chat"
    
    if ! $PYTHON_CMD -m pip install --only-binary :all: aider-chat; then
        # Si falla con --only-binary, intentar sin esa opción pero con build isolation deshabilitado
        print_warning "Reintentando sin restricción de compilación..."
        
        if ! $PYTHON_CMD -m pip install --no-build-isolation aider-chat; then
            print_error "Error durante la instalación de aider-chat"
            print_info "Posibles soluciones:"
            print_info "  • Verifica tu conexión a Internet"
            print_info "  • Intenta: $PYTHON_CMD -m pip install --upgrade aider-chat"
            print_info "  • Libera espacio en disco (~200 MB necesarios)"
            log_error "aider-chat installation failed"
            return 1
        fi
    fi
    
    echo -e "  ${CYAN}[███████████████████████████] 100%${NC}"
    print_success "aider-chat instalado correctamente"
    
    return 0
}

validate_aider_installation() {
    print_info "Validando instalación de Aider..."
    
    if ! command -v aider &>/dev/null; then
        # Intenta encontrarlo en bin de Python
        local python_bin_dir=$($PYTHON_CMD -c "import site; print(site.USER_SITE)" 2>/dev/null || echo "")
        
        if [[ -z "$python_bin_dir" ]]; then
            print_warning "No se pudo verificar ubicación de aider"
            return 1
        fi
    fi
    
    # Verificar versión
    local aider_version
    aider_version=$(aider --version 2>&1) || {
        print_error "No se pudo obtener versión de Aider"
        return 1
    }
    
    print_success "Aider validado: $aider_version"
    log_info "Aider installation successful: $aider_version"
    return 0
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
    
    # Paso 3: Verificar si ya está instalado
    if command -v aider &>/dev/null; then
        print_warning "Aider ya está instalado: $(aider --version 2>&1)"
        read -p "¿Deseas reinstalar/actualizar? [s/N]: " resp
        [[ "$resp" != "s" && "$resp" != "S" ]] && return 0
        print_info "Procediendo con actualización..."
    fi
    
    # Paso 4: Instalar Aider
    if ! install_aider; then
        return 1
    fi
    
    # Paso 5: Validar instalación
    if ! validate_aider_installation; then
        print_warning "Instalación completada pero la validación falló"
        print_info "Intenta: aider --version en una nueva terminal"
    fi
    
    # Paso 6: Mostrar instrucciones de configuración
    print_api_key_instructions
    
    print_success "✓ Instalación de Aider completada"
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
