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
    
    while true; do
        show_main_menu
        handle_main_menu
    done
}

main "$@"