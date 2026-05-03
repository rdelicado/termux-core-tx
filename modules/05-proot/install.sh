#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="${PROJECT_ROOT:-$(cd "$SCRIPT_DIR/../.." && pwd)}"
export PROJECT_ROOT

source "$PROJECT_ROOT/core/detection.sh"
source "$PROJECT_ROOT/core/utils.sh"

ensure_proot_distro_support() {
    if [[ "$(detect_os)" != "android" ]]; then
        print_warning "proot-distro es solo para Termux/Android"
        return 1
    fi

    return 0
}

is_proot_installed() {
    local distro="$1"
    # Validamos verificando si existe el directorio rootfs de la distro instalada en Termux
    local rootfs="${PREFIX:-/data/data/com.termux/files/usr}/var/lib/proot-distro/installed-rootfs/${distro}"
    if [[ -d "$rootfs" ]]; then
        return 0
    else
        return 1
    fi
}

install_proot_distro() {
    print_info "Instalando proot-distro..."

    if ! ensure_proot_distro_support; then
        return 1
    fi

    if command -v proot-distro &>/dev/null; then
        print_warning "proot-distro ya instalado"
        return 0
    fi

    install_package "proot-distro"

    if command -v proot-distro &>/dev/null; then
        print_success "proot-distro instalado"
    else
        print_error "Error al instalar proot-distro"
        return 1
    fi
}

install_proot_debian() {
    print_info "Instalando Debian en proot-distro..."

    if ! ensure_proot_distro_support; then
        return 1
    fi

    install_proot_distro || return 1

    if is_proot_installed "debian"; then
        print_warning "Debian ya está instalado en proot-distro"
        return 0
    fi

    proot-distro install debian

    if is_proot_installed "debian"; then
        print_success "Debian instalado en proot-distro"
    else
        print_error "Error al instalar Debian"
        return 1
    fi
}

install_proot_alpine() {
    print_info "Instalando Alpine en proot-distro..."

    if ! ensure_proot_distro_support; then
        return 1
    fi

    install_proot_distro || return 1

    if is_proot_installed "alpine"; then
        print_warning "Alpine ya está instalado en proot-distro"
        return 0
    fi

    proot-distro install alpine

    if is_proot_installed "alpine"; then
        print_success "Alpine instalado en proot-distro"
    else
        print_error "Error al instalar Alpine"
        return 1
    fi
}

login_proot_debian() {
    print_info "Abriendo Debian con proot-distro..."

    if ! ensure_proot_distro_support; then
        return 1
    fi

    if ! command -v proot-distro &>/dev/null; then
        print_error "proot-distro no está instalado"
        return 1
    fi

    proot-distro login debian
}

login_proot_alpine() {
    print_info "Abriendo Alpine con proot-distro..."

    if ! ensure_proot_distro_support; then
        return 1
    fi

    if ! command -v proot-distro &>/dev/null; then
        print_error "proot-distro no está instalado"
        return 1
    fi

    proot-distro login alpine
}

delete_proot_debian() {
    if ! ensure_proot_distro_support; then
        return 1
    fi

    if ! confirm_uninstall "Debian (proot-distro)" "rootfs y datos del contenedor"; then
        return 1
    fi

    if ! command -v proot-distro &>/dev/null; then
        print_error "proot-distro no está instalado"
        return 1
    fi

    proot-distro remove debian

    if is_proot_installed "debian"; then
        print_error "Debian sigue instalado"
        return 1
    fi

    print_success "Debian eliminado"
}

delete_proot_alpine() {
    if ! ensure_proot_distro_support; then
        return 1
    fi

    if ! confirm_uninstall "Alpine (proot-distro)" "rootfs y datos del contenedor"; then
        return 1
    fi

    if ! command -v proot-distro &>/dev/null; then
        print_error "proot-distro no está instalado"
        return 1
    fi

    proot-distro remove alpine

    if is_proot_installed "alpine"; then
        print_error "Alpine sigue instalado"
        return 1
    fi

    print_success "Alpine eliminado"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo "Este módulo debe ser cargado desde el instalador principal (bin/main.sh)."
    echo "Uso directo: source modules/05-proot/install.sh && install_proot_distro"
fi
