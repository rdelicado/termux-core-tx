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
    local cols rows pad left_margin current_os

    cols=$(tput cols 2>/dev/null || echo 80)
    rows=$(tput lines 2>/dev/null || echo 24)
    current_os=$(uname -o 2>/dev/null || uname -s)

    if [[ $cols -lt 72 || $rows -lt 22 ]]; then
        left_margin=0
        if [[ $cols -gt 24 ]]; then
            left_margin=$(((cols - 24) / 2))
        fi

        printf '%*s%s\n' "$left_margin" '' "${c1}CORE-TX${reset} ${dim}•${reset} ${m1}Gestor de Entornos${reset}"
        printf '%*s%s\n' "$left_margin" '' "${c3}Termux / Android${reset}"
        printf '%*s%s\n' "$left_margin" '' "${c1}OS:${reset} ${current_os}   ${dim}│${reset}   ${c3}USER:${reset} ${USER}"
        printf '\n'
        return
    fi

    pad=$(((cols - 46) / 2))
    if [[ $pad -lt 0 ]]; then
        pad=0
    fi

    # Logo CORE TX perfectamente alineado y simétrico
    printf '%*s%s\n' "$pad" '' "${c1}   ______  ____  ____  ______     ${m1} _______  __ ${reset}"
    printf '%*s%s\n' "$pad" '' "${c2}  / ____/ / __ \\/ __ \\/ ____/    ${m1} /_  __/ |/ / ${reset}"
    printf '%*s%s\n' "$pad" '' "${c3} / /     / / / / /_/ / __/       ${m1}  / /  |   /  ${reset}"
    printf '%*s%s\n' "$pad" '' "${c4}/ /___  / /_/ / _, _/ /___       ${m1} / /  /   |   ${reset}"
    printf '%*s%s\n' "$pad" '' "${c5}\\____/  \\____/_/ |_/_____/       ${m1}/_/  /_/|_|   ${reset}"
    echo ""
    
    # Info Bar simplificada (Sin líneas divisorias)
    printf '%*s%s\n' "$pad" '' "${c1}OS:${reset} ${current_os}   ${dim}│${reset}   ${c3}USER:${reset} $USER"
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

confirm_uninstall() {
    local package="$1"
    local dependencies="$2"
    
    tput cnorm
    echo ""
    if [[ -n "$dependencies" ]]; then
        echo -e "${YELLOW}⚠️  ATENCIÓN: Vas a desinstalar $package${NC}"
        echo -e "${YELLOW}Esto también eliminará: $dependencies${NC}"
    else
        echo -e "${YELLOW}⚠️  Vas a desinstalar $package${NC}"
    fi
    echo -e "${CYAN}¿Deseas continuar? [S/n]: ${NC}"
    read -r response
    
    tput civis
    
    if [[ "$response" =~ ^[Ss]$ ]] || [[ -z "$response" ]]; then
        return 0
    else
        print_info "Desinstalación cancelada"
        return 1
    fi
}

uninstall_package() {
    local pkg=$1
    local pm=$(get_package_manager)
    
    case "$pm" in
        pkg)
            pkg uninstall -y "$pkg"
            ;;
        apt)
            sudo apt-get remove -y --purge "$pkg"
            ;;
        brew)
            brew uninstall "$pkg"
            ;;
        *)
            print_error "Gestor de paquetes desconocido"
            return 1
            ;;
    esac
    
    return $?
}