#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="${PROJECT_ROOT:-$(cd "$SCRIPT_DIR/../.." && pwd)}"
export PROJECT_ROOT

source "$PROJECT_ROOT/core/detection.sh"
source "$PROJECT_ROOT/core/utils.sh"
source "$PROJECT_ROOT/core/menu.sh"

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

show_multiplexers_menu() {
    while true; do
        local options=(
            "Tmux             (Multiplexor de terminal)"
            "Volver           (Regresar al menú principal)"
        )
        local selected=0
        local key

        tput civis
        trap "tput cnorm; exit" INT TERM

        clear
        banner
        echo -e "  ${COLOR_TITLE}Multiplexers${RESET}\n"
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
            0) execute_action "source \"$PROJECT_ROOT/modules/04-multiplexers/install.sh\" && install_tmux" "tmux" ;;
            1) return ;;
        esac
    done
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    show_multiplexers_menu
fi
