#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="${PROJECT_ROOT:-$(cd "$SCRIPT_DIR/../.." && pwd)}"
export PROJECT_ROOT

source "$PROJECT_ROOT/core/detection.sh"
source "$PROJECT_ROOT/core/utils.sh"
source "$PROJECT_ROOT/core/menu.sh"

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

show_proot_menu() {
    while true; do
        local options=(
            "Instalar proot-distro    (Paquete base)"
            "Instalar Debian          (Distribución Debian)"
            "Instalar Alpine          (Distribución Alpine)"
            "Login Debian             (Entrar al contenedor)"
            "Login Alpine             (Entrar al contenedor)"
            "Eliminar Debian          (Borrar contenedor)"
            "Eliminar Alpine          (Borrar contenedor)"
            "Volver                   (Regresar al menú principal)"
        )
        local selected=0
        local key

        tput civis
        trap "tput cnorm; exit" INT TERM

        clear
        banner
        echo -e "  ${COLOR_TITLE}PRoot Distro${RESET}\n"
        tput sc

        while true; do
            tput rc

            for i in "${!options[@]}"; do
                if [[ $i -eq $selected ]]; then
                    echo -e "\e[K  ${COLOR_SELECTED}▸ ${options[$i]}${RESET}"
                else
                    echo -e "\e[K      ${COLOR_UNSELECTED}${options[$i]}${RESET}"
                fi
            done

            echo -e "\e[K"
            echo -e "\e[K  ${COLOR_MUTED}j/k o flechas: navegar  •  enter: seleccionar  •  q: salir${RESET}"

            read -rsn1 key

            case "$key" in
                $'\e')
                    read -rsn2 key
                    case "$key" in
                        '[A') ((selected--)) ;;
                        '[B') ((selected++)) ;;
                    esac
                    ;;
                'k') ((selected--)) ;;
                'j') ((selected++)) ;;
                'q') tput cnorm; return ;;
                "") break ;;
            esac

            if [[ $selected -lt 0 ]]; then
                selected=$((${#options[@]} - 1))
            elif [[ $selected -ge ${#options[@]} ]]; then
                selected=0
            fi
        done

        tput cnorm

        case $selected in
            0) execute_action "source \"$PROJECT_ROOT/modules/05-proot/install.sh\" && install_proot_distro" "proot-distro" ;;
            1) execute_action "source \"$PROJECT_ROOT/modules/05-proot/install.sh\" && install_proot_debian" "Debian" ;;
            2) execute_action "source \"$PROJECT_ROOT/modules/05-proot/install.sh\" && install_proot_alpine" "Alpine" ;;
            3) execute_action "source \"$PROJECT_ROOT/modules/05-proot/install.sh\" && login_proot_debian" "Login Debian" ;;
            4) execute_action "source \"$PROJECT_ROOT/modules/05-proot/install.sh\" && login_proot_alpine" "Login Alpine" ;;
            5) execute_action "source \"$PROJECT_ROOT/modules/05-proot/install.sh\" && delete_proot_debian" "Eliminar Debian" ;;
            6) execute_action "source \"$PROJECT_ROOT/modules/05-proot/install.sh\" && delete_proot_alpine" "Eliminar Alpine" ;;
            7) return ;;
        esac
    done
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    show_proot_menu
fi
