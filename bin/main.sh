#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

source "$PROJECT_ROOT/core/detection.sh"
source "$PROJECT_ROOT/core/utils.sh"
source "$PROJECT_ROOT/core/backup.sh"
source "$PROJECT_ROOT/core/logger.sh"
source "$PROJECT_ROOT/core/menu.sh"
source "$PROJECT_ROOT/core/installers.sh"

LOG_TOTAL=0
LOG_SUCCESS=0
LOG_FAILED=0

main() {
    log_init
    
    local os=$(detect_os)
    local pm=$(get_package_manager)
    
    log_info "Sistema detectado: $os"
    log_info "Gestor de paquetes: $pm"
    print_info "Directorio del proyecto: $PROJECT_ROOT"
    
    if [[ "$os" == "android" ]]; then
        if [[ ! -d "$HOME/storage" ]]; then
            print_warning "Permisos de almacenamiento no concedidos"
            print_info "Solicitando permisos de almacenamiento..."
            termux-setup-storage
            sleep 1
            if [[ ! -d "$HOME/storage" ]]; then
                print_warning "Permisos denegados. Continuando sin almacenamiento..."
                log_warning "Usuario denegó permisos de almacenamiento"
            else
                print_success "Permisos de almacenamiento concedidos"
                log_success "Storage permissions granted"
            fi
        fi
    fi
    
    if ! command -v tput &> /dev/null; then
        echo -e "\033[1;38;5;211m[INFO]\033[0m Instalando dependencias de interfaz (ncurses-utils)..."
        if [[ "$os" == "android" ]]; then
            pkg install ncurses-utils -y > /dev/null 2>&1
        else
            sudo apt-get install ncurses-bin -y > /dev/null 2>&1
        fi
    fi
    
    show_main_menu
}

main "$@"