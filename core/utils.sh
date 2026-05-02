#!/usr/bin/env bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
GRAY='\033[90m'
PURPLE_DEEP='\033[38;5;239m'
NEON_GREEN='\033[38;2;57;255;57m'
CYAN_BRIGHT='\033[38;2;0;255;255m'
NC='\033[0m'

FIRST_RUN=true

print_error()   { echo -e "${RED}[ERROR]${NC} $1"; }
print_success() { echo -e "${GREEN}[OK]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARN]${NC} $1"; }
print_info()    { echo -e "${CYAN}[INFO]${NC} $1"; }
print_header()  { echo -e "\n${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n${BOLD}$1${NC}\n${GRAY}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"; }

banner() {
    local c1='\033[38;5;51m'   # Cyan claro
    local c2='\033[38;5;45m'
    local c3='\033[38;5;39m'   # Cyan medio
    local c4='\033[38;5;33m'
    local c5='\033[38;5;27m'   # Azul oscuro
    local m1='\033[38;5;199m'  # Magenta brillante
    local dim='\033[2m'        # Texto tenue
    local reset='\033[0m'

    # Logo CORE TX perfectamente alineado y simétrico
    echo -e "${c1}   ______  ____  ____  ______     ${m1} _______  __ ${reset}"
    echo -e "${c2}  / ____/ / __ \\/ __ \\/ ____/    ${m1} /_  __/ |/ / ${reset}"
    echo -e "${c3} / /     / / / / /_/ / __/       ${m1}  / /  |   /  ${reset}"
    echo -e "${c4}/ /___  / /_/ / _, _/ /___       ${m1} / /  /   |   ${reset}"
    echo -e "${c5}\\____/  \\____/_/ |_/_____/       ${m1}/_/  /_/|_|   ${reset}"
    echo ""
    
    # Info Bar simplificada (Sin líneas divisorias)
    local current_os=$(uname -o 2>/dev/null || uname -s)
    echo -e "       ${c1}OS:${reset} ${current_os}   ${dim}│${reset}   ${c3}USER:${reset} $USER"
    echo ""
}

install_package() {
    local pkg=$1
    local pm
    pm=$(get_package_manager)
    local retry=0
    local max_retries=1
    
    while [[ $retry -le $max_retries ]]; do
        case "$pm" in
            pkg)
                if [[ $retry -eq 1 ]]; then
                    print_info "Actualizando repositorios..."
                    pkg update -y
                fi
                print_info "Instalando $pkg..."
                pkg install -y "$pkg"
                ;;
            apt)
                if [[ $retry -eq 1 ]]; then
                    print_info "Actualizando repositorios..."
                    sudo apt-get update -y
                fi
                print_info "Instalando $pkg..."
                sudo apt-get install -y "$pkg"
                ;;
            brew)
                if [[ $retry -eq 1 ]]; then
                    print_info "Actualizando..."
                    brew update
                fi
                print_info "Instalando $pkg..."
                brew install "$pkg"
                ;;
            *)
                print_error "Gestor de paquetes desconocido"
                return 1
                ;;
        esac
        
        if [[ $? -eq 0 ]]; then
            return 0
        fi
        
        ((retry++))
        if [[ $retry -le $max_retries ]]; then
            print_warning "Error instalando $pkg, reintentando..."
        fi
    done
    
    if [[ "$pkg" == "btop" ]]; then
        print_warning "btop no disponible, instalando htop como alternativa..."
        log_warning "btop not found, falling back to htop"
        
        case "$pm" in
            pkg) pkg install -y htop ;;
            apt) sudo apt-get install -y htop ;;
            brew) brew install htop ;;
        esac
        
        if [[ $? -eq 0 ]]; then
            print_success "htop instalado como alternativa"
            log_success "htop installed as fallback for btop"
            return 0
        fi
    fi
    
    print_error "Error al instalar $pkg tras $max_retries reintentos"
    log_error "Failed to install $pkg after $max_retries attempts"
    return 1
}