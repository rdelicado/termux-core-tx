#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="${PROJECT_ROOT:-$(cd "$SCRIPT_DIR/../.." && pwd)}"
export PROJECT_ROOT

source "$PROJECT_ROOT/core/detection.sh"
source "$PROJECT_ROOT/core/utils.sh"

install_tmux() {
    print_info "Instalando tmux..."

    if command -v tmux &>/dev/null; then
        print_warning "tmux ya instalado: $(tmux -V)"
        return 0
    fi

    install_package "tmux"

    if command -v tmux &>/dev/null; then
        print_success "tmux instalado"
    else
        print_error "Error al instalar tmux"
        return 1
    fi
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    install_tmux "$@"
fi
