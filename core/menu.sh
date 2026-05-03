#!/usr/bin/env bash

COLOR_TITLE='\033[1;38;5;51m'
COLOR_SELECTED='\033[1;38;5;231m'
COLOR_UNSELECTED='\033[38;5;245m'
COLOR_MUTED='\033[38;5;240m'
RESET='\033[0m'
COLOR_ACCENT='\033[1;38;5;51m'
COLOR_BG_SEL='\033[48;5;236m'
COLOR_SIZE='\033[38;5;213m'

enter_tui() {
    tput smcup 2>/dev/null
    tput civis
    trap "tput rmcup 2>/dev/null; tput cnorm; exit" INT TERM
}

leave_tui() {
    tput rmcup 2>/dev/null
    tput cnorm
}

get_banner_height() {
    echo 6  # 5 lines ASCII + 1 line subtitle
}

draw_menu_header() {
    clear
    banner
}

draw_options() {
    local -n _options=$1
    local _selected=$2
    local opt_start=$(get_banner_height)
    tput cup "$opt_start" 0
    for i in "${!_options[@]}"; do
        IFS='|' read -r name size <<< "${_options[$i]}"
        if [[ $i -eq $_selected ]]; then
            printf "\e[K  ${COLOR_ACCENT}┃${COLOR_BG_SEL} ${COLOR_SELECTED}%-26s ${COLOR_SIZE}%7s ${RESET}\n" "$name" "$size"
        else
            printf "\e[K    ${COLOR_UNSELECTED}%-26s ${COLOR_MUTED}%7s ${RESET}\n" "$name" "$size"
        fi
    done
    printf "\e[K\n"
    printf "\e[K  ${COLOR_MUTED}  ↑/↓ navega   ↵ selecciona   q salir${RESET}\n"
    tput ed
}

read_key() {
    local key
    read -rsn1 key
    case "$key" in
        $'\e')
            read -rsn2 key
            case "$key" in
                '[A') echo "UP" ;;
                '[B') echo "DOWN" ;;
                *) echo "" ;;
            esac
            ;;
        'k') echo "UP" ;;
        'j') echo "DOWN" ;;
        'q') echo "QUIT" ;;
        "") echo "ENTER" ;;
        *) echo "" ;;
    esac
}

clamp_selected() {
    local sel=$1 max=$2
    if [[ $sel -lt 0 ]]; then
        echo $((max - 1))
    elif [[ $sel -ge $max ]]; then
        echo 0
    else
        echo $sel
    fi
}

execute_action() {
    local command="$1"
    local action_name="$2"
    
    leave_tui
    clear
    banner
    echo -e "\n  ${COLOR_TITLE}[  EJECUTANDO: $action_name ]${RESET}\n"
    
    bash -c "$command"
    
    echo -e "\n  ${COLOR_MUTED}Presiona ENTER para volver al menú...${RESET}"
    read -r
    
    enter_tui
}

# ============================================================
# MAIN MENU
# ============================================================
show_main_menu() {
    enter_tui
    local options=(
        "Apariencia|~150MB"
        "Herramientas Base|~40MB"
        "Entornos Dev|~900MB"
        "Multiplexers|~5MB"
        "PRoot Distro|~150MB"
        "Dotfiles Manager|~1MB"
        "Instalar Todo|~1.2GB"
        "Ver Estado|"
        "Update CORE-TX|"
        "Desinstalador|"
        "Ver Logs|"
        "Salir|"
    )
    local selected=0

    while true; do
        draw_menu_header

        while true; do
            draw_options options selected
            local action
            action=$(read_key)

            case "$action" in
                UP)    selected=$(clamp_selected $((selected - 1)) ${#options[@]}) ;;
                DOWN)  selected=$(clamp_selected $((selected + 1)) ${#options[@]}) ;;
                QUIT)  leave_tui; clear; exit 0 ;;
                ENTER) break ;;
            esac
        done

        case $selected in
            0)  show_appearance_menu ;;
            1)  show_basetools_menu ;;
            2)  show_devenv_menu ;;
            3)  show_multiplexers_menu ;;
            4)  show_proot_menu ;;
            5)  source "$PROJECT_ROOT/modules/06-dotfiles/install.sh" && show_dotfiles_menu ;;
            6)  execute_action "source \"\$PROJECT_ROOT/modules/01-appearance/install.sh\" && install_all_appearance && source \"\$PROJECT_ROOT/modules/02-base-tools/install.sh\" && install_all_basetools && source \"\$PROJECT_ROOT/modules/03-dev-env/install.sh\" && install_all_devenvs && source \"\$PROJECT_ROOT/modules/04-multiplexers/install.sh\" && install_tmux && source \"\$PROJECT_ROOT/modules/05-proot/install.sh\" && install_proot_distro && install_proot_alpine" "Instalación de TODO el sistema" ;;
            7)  show_status ;;
            8)  source "$PROJECT_ROOT/core/updater.sh" && update_core_tx ;;
            9)  show_uninstall_menu ;;
            10) show_logs ;;
            11) leave_tui; clear; exit 0 ;;
        esac
    done
}

# ============================================================
# APPEARANCE MENU
# ============================================================
show_appearance_menu() {
    local options=(
        "ZSH + Oh My Zsh|"
        "Powerlevel10k|"
        "Autosuggestions|"
        "Syntax Highlight|"
        "LSD|"
        "Bat|"
        "Fuentes|"
        "Instalar Todo|"
        "Volver|"
    )
    local selected=0

    while true; do
        draw_menu_header

        while true; do
            draw_options options selected
            local action
            action=$(read_key)

            case "$action" in
                UP)    selected=$(clamp_selected $((selected - 1)) ${#options[@]}) ;;
                DOWN)  selected=$(clamp_selected $((selected + 1)) ${#options[@]}) ;;
                QUIT)  return ;;
                ENTER) break ;;
            esac
        done

        case $selected in
            0) execute_action "bash \"\$PROJECT_ROOT/modules/01-appearance/zsh.sh\"" "ZSH + Oh My Zsh" ;;
            1) execute_action "bash \"\$PROJECT_ROOT/modules/01-appearance/install.sh\"" "Powerlevel10k" ;;
            2) execute_action "bash \"\$PROJECT_ROOT/modules/01-appearance/install.sh\"" "Plugins ZSH" ;;
            3) execute_action "bash \"\$PROJECT_ROOT/modules/01-appearance/install.sh\"" "Plugins ZSH" ;;
            4) execute_action "pkg install lsd -y" "LSD" ;;
            5) execute_action "pkg install bat -y" "Bat" ;;
            6) show_fonts_menu ;;
            7) execute_action "bash \"\$PROJECT_ROOT/modules/01-appearance/install.sh\"" "Instalación Completa Apariencia" ;;
            8) return ;;
        esac
    done
}

# ============================================================
# FONTS MENU
# ============================================================
show_fonts_menu() {
    local options=(
        "MesloLGS|"
        "Hack Nerd Font|"
        "JetBrains Mono|"
        "Fira Code|"
        "Volver|"
    )
    local selected=0

    while true; do
        draw_menu_header

        while true; do
            draw_options options selected
            local action
            action=$(read_key)

            case "$action" in
                UP)    selected=$(clamp_selected $((selected - 1)) ${#options[@]}) ;;
                DOWN)  selected=$(clamp_selected $((selected + 1)) ${#options[@]}) ;;
                QUIT)  return ;;
                ENTER) break ;;
            esac
        done

        case $selected in
            0) execute_action "bash \"\$PROJECT_ROOT/modules/01-appearance/fonts.sh\" Meslo" "Fuente MesloLGS" ;;
            1) execute_action "bash \"\$PROJECT_ROOT/modules/01-appearance/fonts.sh\" Hack" "Fuente Hack Nerd Font" ;;
            2) execute_action "bash \"\$PROJECT_ROOT/modules/01-appearance/fonts.sh\" JetBrainsMono" "Fuente JetBrains Mono" ;;
            3) execute_action "bash \"\$PROJECT_ROOT/modules/01-appearance/fonts.sh\" FiraCode" "Fuente Fira Code" ;;
            4) return ;;
        esac
    done
}

# ============================================================
# BASE TOOLS MENU
# ============================================================
show_basetools_menu() {
    local options=(
        "Git|"
        "Wget|"
        "OpenSSH|"
        "FZF|"
        "Btop/Htop|"
        "Instalar Todo|"
        "Volver|"
    )
    local selected=0

    while true; do
        draw_menu_header

        while true; do
            draw_options options selected
            local action
            action=$(read_key)

            case "$action" in
                UP)    selected=$(clamp_selected $((selected - 1)) ${#options[@]}) ;;
                DOWN)  selected=$(clamp_selected $((selected + 1)) ${#options[@]}) ;;
                QUIT)  return ;;
                ENTER) break ;;
            esac
        done

        case $selected in
            0) execute_action "pkg install git -y" "Git" ;;
            1) execute_action "pkg install wget -y" "Wget" ;;
            2) execute_action "pkg install openssh -y" "OpenSSH" ;;
            3) execute_action "pkg install fzf -y" "FZF" ;;
            4) execute_action "pkg install btop -y || pkg install htop -y" "Btop/Htop" ;;
            5) execute_action "source \"\$PROJECT_ROOT/modules/02-base-tools/install.sh\" && install_all_basetools" "Instalación Masiva: Herramientas Base" ;;
            6) return ;;
        esac
    done
}

# ============================================================
# DEV ENV MENU
# ============================================================
show_devenv_menu() {
    local options=(
        "Neovim|"
        "C/C++|"
        "Go|"
        "Python|"
        "Node.js|"
        "Instalar Todo|"
        "Volver|"
    )
    local selected=0

    while true; do
        draw_menu_header

        while true; do
            draw_options options selected
            local action
            action=$(read_key)

            case "$action" in
                UP)    selected=$(clamp_selected $((selected - 1)) ${#options[@]}) ;;
                DOWN)  selected=$(clamp_selected $((selected + 1)) ${#options[@]}) ;;
                QUIT)  return ;;
                ENTER) break ;;
            esac
        done

        case $selected in
            0) execute_action "source \$PROJECT_ROOT/modules/03-dev-env/install.sh && install_neovim" "Neovim" ;;
            1) execute_action "source \$PROJECT_ROOT/modules/03-dev-env/install.sh && install_c_cpp" "C/C++ (Clang)" ;;
            2) execute_action "source \$PROJECT_ROOT/modules/03-dev-env/install.sh && install_go" "Go" ;;
            3) execute_action "source \$PROJECT_ROOT/modules/03-dev-env/install.sh && install_python" "Python" ;;
            4) execute_action "source \$PROJECT_ROOT/modules/03-dev-env/install.sh && install_nodejs" "Node.js" ;;
            5) execute_action "source \"\$PROJECT_ROOT/modules/03-dev-env/install.sh\" && install_all_devenvs" "Instalación Masiva: Entornos Dev" ;;
            6) return ;;
        esac
    done
}

# ============================================================
# MULTIPLEXERS MENU
# ============================================================
show_multiplexers_menu() {
    local options=(
        "Tmux|"
        "Volver|"
    )
    local selected=0

    while true; do
        draw_menu_header

        while true; do
            draw_options options selected
            local action
            action=$(read_key)

            case "$action" in
                UP)    selected=$(clamp_selected $((selected - 1)) ${#options[@]}) ;;
                DOWN)  selected=$(clamp_selected $((selected + 1)) ${#options[@]}) ;;
                QUIT)  return ;;
                ENTER) break ;;
            esac
        done

        case $selected in
            0) execute_action "source \"$PROJECT_ROOT/modules/04-multiplexers/install.sh\" && install_tmux" "tmux" ;;
            1) return ;;
        esac
    done
}

# ============================================================
# PROOT MENU
# ============================================================
show_proot_menu() {
    local options=(
        "Instalar proot-distro|"
        "Instalar Debian|"
        "Instalar Alpine|"
        "Login Debian|"
        "Login Alpine|"
        "Eliminar Debian|"
        "Eliminar Alpine|"
        "Volver|"
    )
    local selected=0

    while true; do
        draw_menu_header

        while true; do
            draw_options options selected
            local action
            action=$(read_key)

            case "$action" in
                UP)    selected=$(clamp_selected $((selected - 1)) ${#options[@]}) ;;
                DOWN)  selected=$(clamp_selected $((selected + 1)) ${#options[@]}) ;;
                QUIT)  return ;;
                ENTER) break ;;
            esac
        done

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

# ============================================================
# STATUS
# ============================================================
is_installed() {
    command -v "$1" &>/dev/null && return 0 || return 1
}

show_status() {
    leave_tui
    local installed=0
    local missing=0
    local GREEN='\033[1;32m'
    local RED='\033[1;31m'
    local PINK='\033[1;38;5;51m'
    local NC='\033[0m'
    
    clear
    banner
    echo -e "  ${PINK}Estado de Herramientas${NC}\n"
    
    echo -e "\n${PINK}APARIENCIA${NC}"
    if is_installed "zsh"; then echo -e "  ${GREEN}zsh [INSTALADO]${NC}"; ((installed++)); else echo -e "  ${RED}zsh [FALTA]${NC}"; ((missing++)); fi
    if is_installed "lsd"; then echo -e "  ${GREEN}lsd [INSTALADO]${NC}"; ((installed++)); else echo -e "  ${RED}lsd [FALTA]${NC}"; ((missing++)); fi
    if is_installed "bat"; then echo -e "  ${GREEN}bat [INSTALADO]${NC}"; ((installed++)); else echo -e "  ${RED}bat [FALTA]${NC}"; ((missing++)); fi
    if [[ -d "$HOME/.oh-my-zsh" ]]; then echo -e "  ${GREEN}Oh My Zsh [INSTALADO]${NC}"; ((installed++)); else echo -e "  ${RED}Oh My Zsh [FALTA]${NC}"; ((missing++)); fi
    if [[ -d "$HOME/powerlevel10k" ]]; then echo -e "  ${GREEN}Powerlevel10k [INSTALADO]${NC}"; ((installed++)); else echo -e "  ${RED}Powerlevel10k [FALTA]${NC}"; ((missing++)); fi
    if [[ -d "$HOME/.zsh/plugins/zsh-autosuggestions" ]]; then echo -e "  ${GREEN}zsh-autosuggestions [INSTALADO]${NC}"; ((installed++)); else echo -e "  ${RED}zsh-autosuggestions [FALTA]${NC}"; ((missing++)); fi
    if [[ -d "$HOME/.zsh/plugins/zsh-syntax-highlighting" ]]; then echo -e "  ${GREEN}zsh-syntax-highlighting [INSTALADO]${NC}"; ((installed++)); else echo -e "  ${RED}zsh-syntax-highlighting [FALTA]${NC}"; ((missing++)); fi
    
    echo -e "\n${PINK}HERRAMIENTAS BASE${NC}"
    if is_installed "git"; then echo -e "  ${GREEN}git [INSTALADO]${NC}"; ((installed++)); else echo -e "  ${RED}git [FALTA]${NC}"; ((missing++)); fi
    if is_installed "wget"; then echo -e "  ${GREEN}wget [INSTALADO]${NC}"; ((installed++)); else echo -e "  ${RED}wget [FALTA]${NC}"; ((missing++)); fi
    if is_installed "ssh"; then echo -e "  ${GREEN}openssh [INSTALADO]${NC}"; ((installed++)); else echo -e "  ${RED}openssh [FALTA]${NC}"; ((missing++)); fi
    if is_installed "fzf"; then echo -e "  ${GREEN}fzf [INSTALADO]${NC}"; ((installed++)); else echo -e "  ${RED}fzf [FALTA]${NC}"; ((missing++)); fi
    if is_installed "btop"; then echo -e "  ${GREEN}btop [INSTALADO]${NC}"; ((installed++)); elif is_installed "htop"; then echo -e "  ${GREEN}htop (fallback) [INSTALADO]${NC}"; ((installed++)); else echo -e "  ${RED}btop/htop [FALTA]${NC}"; ((missing++)); fi
    
    echo -e "\n${PINK}ENTORNOS DEV${NC}"
    if is_installed "nvim"; then echo -e "  ${GREEN}neovim [INSTALADO]${NC}"; ((installed++)); else echo -e "  ${RED}neovim [FALTA]${NC}"; ((missing++)); fi
    if is_installed "clang"; then echo -e "  ${GREEN}clang (C/C++) [INSTALADO]${NC}"; ((installed++)); else echo -e "  ${RED}clang (C/C++) [FALTA]${NC}"; ((missing++)); fi
    if is_installed "go"; then echo -e "  ${GREEN}go [INSTALADO]${NC}"; ((installed++)); else echo -e "  ${RED}go [FALTA]${NC}"; ((missing++)); fi
    if is_installed "python3" || is_installed "python"; then echo -e "  ${GREEN}python [INSTALADO]${NC}"; ((installed++)); else echo -e "  ${RED}python [FALTA]${NC}"; ((missing++)); fi
    if is_installed "node"; then echo -e "  ${GREEN}node.js [INSTALADO]${NC}"; ((installed++)); else echo -e "  ${RED}node.js [FALTA]${NC}"; ((missing++)); fi

    echo -e "\n${PINK}MULTIPLEXERS${NC}"
    if is_installed "tmux"; then echo -e "  ${GREEN}tmux [INSTALADO]${NC}"; ((installed++)); else echo -e "  ${RED}tmux [FALTA]${NC}"; ((missing++)); fi

    echo -e "\n${PINK}PROOT DISTRO${NC}"
    if is_installed "proot-distro"; then echo -e "  ${GREEN}proot-distro [INSTALADO]${NC}"; ((installed++)); else echo -e "  ${RED}proot-distro [FALTA]${NC}"; ((missing++)); fi
    
    echo -e "\n  ${GREEN}Instaladas: $installed${NC}   ${RED}Faltantes: $missing${NC}"
    echo -e "\n  ${COLOR_MUTED}Presiona cualquier tecla para volver...${NC}"
    read -rsn1
    enter_tui
}

# ============================================================
# LOGS
# ============================================================
show_logs() {
    leave_tui
    local log_dir="$PROJECT_ROOT/logs"
    clear
    banner
    echo -e "  ${COLOR_TITLE}Logs Recientes${RESET}\n"
    
    if [[ -d "$log_dir" ]] && [[ -n "$(ls -A "$log_dir" 2>/dev/null)" ]]; then
        ls -1t "$log_dir" | head -5 | while read -r log; do
            echo -e "    ${COLOR_UNSELECTED}$log${RESET}"
        done
    else
        echo -e "    ${COLOR_MUTED}No hay logs disponibles${RESET}"
    fi
    
    echo -e "\n  ${COLOR_MUTED}Presiona cualquier tecla para volver...${RESET}"
    read -rsn1
    enter_tui
}

# ============================================================
# UNINSTALL MAIN
# ============================================================
show_uninstall_menu() {
    local options=(
        "Apariencia|"
        "Herramientas Base|"
        "Entornos Dev|"
        "Multiplexers|"
        "PRoot Distro|"
        "Dotfiles Manager|"
        "Master Wipe|"
        "Volver|"
    )
    local selected=0

    while true; do
        draw_menu_header

        while true; do
            draw_options options selected
            local action
            action=$(read_key)

            case "$action" in
                UP)    selected=$(clamp_selected $((selected - 1)) ${#options[@]}) ;;
                DOWN)  selected=$(clamp_selected $((selected + 1)) ${#options[@]}) ;;
                QUIT)  return ;;
                ENTER) break ;;
            esac
        done

        case $selected in
            0) show_uninstall_appearance ;;
            1) show_uninstall_basetools ;;
            2) show_uninstall_devenv ;;
            3) show_uninstall_multiplexers ;;
            4) show_uninstall_proot ;;
            5) execute_action "source \"\$PROJECT_ROOT/core/uninstaller.sh\" && uninstall_dotfiles" "Desinstalar Dotfiles" ;;
            6) execute_action "source \"\$PROJECT_ROOT/core/uninstaller.sh\" && uninstall_master_wipe" "Master Wipe" ;;
            7) return ;;
        esac
    done
}

# ============================================================
# UNINSTALL MULTIPLEXERS
# ============================================================
show_uninstall_multiplexers() {
    local options=(
        "Tmux|"
        "Volver|"
    )
    local selected=0

    while true; do
        draw_menu_header

        while true; do
            draw_options options selected
            local action
            action=$(read_key)

            case "$action" in
                UP)    selected=$(clamp_selected $((selected - 1)) ${#options[@]}) ;;
                DOWN)  selected=$(clamp_selected $((selected + 1)) ${#options[@]}) ;;
                QUIT)  return ;;
                ENTER) break ;;
            esac
        done

        case $selected in
            0) execute_action "source \"$PROJECT_ROOT/core/uninstaller.sh\" && uninstall_tmux" "Desinstalar tmux" ;;
            1) return ;;
        esac
    done
}

# ============================================================
# UNINSTALL PROOT
# ============================================================
show_uninstall_proot() {
    local options=(
        "Debian|"
        "Alpine|"
        "Todo|"
        "Volver|"
    )
    local selected=0

    while true; do
        draw_menu_header

        while true; do
            draw_options options selected
            local action
            action=$(read_key)

            case "$action" in
                UP)    selected=$(clamp_selected $((selected - 1)) ${#options[@]}) ;;
                DOWN)  selected=$(clamp_selected $((selected + 1)) ${#options[@]}) ;;
                QUIT)  return ;;
                ENTER) break ;;
            esac
        done

        case $selected in
            0) execute_action "source \"$PROJECT_ROOT/core/uninstaller.sh\" && uninstall_proot_debian" "Eliminar Debian" ;;
            1) execute_action "source \"$PROJECT_ROOT/core/uninstaller.sh\" && uninstall_proot_alpine" "Eliminar Alpine" ;;
            2) execute_action "source \"$PROJECT_ROOT/core/uninstaller.sh\" && uninstall_proot_distro" "Desinstalar proot-distro" ;;
            3) return ;;
        esac
    done
}

# ============================================================
# UNINSTALL APPEARANCE
# ============================================================
show_uninstall_appearance() {
    local options=(
        "ZSH Completo|"
        "Oh My Zsh|"
        "Powerlevel10k|"
        "Plugins ZSH|"
        "LSD|"
        "Bat|"
        "Desinstalar Todo|"
        "Volver|"
    )
    local selected=0

    while true; do
        draw_menu_header

        while true; do
            draw_options options selected
            local action
            action=$(read_key)

            case "$action" in
                UP)    selected=$(clamp_selected $((selected - 1)) ${#options[@]}) ;;
                DOWN)  selected=$(clamp_selected $((selected + 1)) ${#options[@]}) ;;
                QUIT)  return ;;
                ENTER) break ;;
            esac
        done

        case $selected in
            0) execute_action "source \"\$PROJECT_ROOT/core/uninstaller.sh\" && uninstall_zsh_cascade" "Desinstalar ZSH (con cascada)" ;;
            1) execute_action "source \"\$PROJECT_ROOT/core/uninstaller.sh\" && uninstall_oh_my_zsh_only" "Desinstalar Oh My Zsh" ;;
            2) execute_action "source \"\$PROJECT_ROOT/core/uninstaller.sh\" && uninstall_powerlevel10k" "Desinstalar Powerlevel10k" ;;
            3) execute_action "source \"\$PROJECT_ROOT/core/uninstaller.sh\" && uninstall_zsh_plugins" "Desinstalar Plugins ZSH" ;;
            4) execute_action "source \"\$PROJECT_ROOT/core/uninstaller.sh\" && uninstall_lsd" "Desinstalar LSD" ;;
            5) execute_action "source \"\$PROJECT_ROOT/core/uninstaller.sh\" && uninstall_bat" "Desinstalar Bat" ;;
            6) execute_action "source \"\$PROJECT_ROOT/core/uninstaller.sh\" && uninstall_all_appearance" "Desinstalar Toda la Apariencia" ;;
            7) return ;;
        esac
    done
}

# ============================================================
# UNINSTALL BASE TOOLS
# ============================================================
show_uninstall_basetools() {
    local options=(
        "Wget|"
        "OpenSSH|"
        "FZF|"
        "Btop/Htop|"
        "Desinstalar Todo|"
        "Volver|"
    )
    local selected=0

    while true; do
        draw_menu_header

        while true; do
            draw_options options selected
            local action
            action=$(read_key)

            case "$action" in
                UP)    selected=$(clamp_selected $((selected - 1)) ${#options[@]}) ;;
                DOWN)  selected=$(clamp_selected $((selected + 1)) ${#options[@]}) ;;
                QUIT)  return ;;
                ENTER) break ;;
            esac
        done

        case $selected in
            0) execute_action "source \"\$PROJECT_ROOT/core/uninstaller.sh\" && uninstall_wget" "Desinstalar Wget" ;;
            1) execute_action "source \"\$PROJECT_ROOT/core/uninstaller.sh\" && uninstall_openssh" "Desinstalar OpenSSH" ;;
            2) execute_action "source \"\$PROJECT_ROOT/core/uninstaller.sh\" && uninstall_fzf" "Desinstalar FZF" ;;
            3) execute_action "source \"\$PROJECT_ROOT/core/uninstaller.sh\" && uninstall_btop_htop" "Desinstalar Btop/Htop" ;;
            4) execute_action "source \"\$PROJECT_ROOT/core/uninstaller.sh\" && uninstall_all_basetools" "Desinstalar Todo" ;;
            5) return ;;
        esac
    done
}

# ============================================================
# UNINSTALL DEV ENV
# ============================================================
show_uninstall_devenv() {
    local options=(
        "Neovim|"
        "C/C++|"
        "Go|"
        "Python|"
        "Node.js|"
        "Desinstalar Todo|"
        "Volver|"
    )
    local selected=0

    while true; do
        draw_menu_header

        while true; do
            draw_options options selected
            local action
            action=$(read_key)

            case "$action" in
                UP)    selected=$(clamp_selected $((selected - 1)) ${#options[@]}) ;;
                DOWN)  selected=$(clamp_selected $((selected + 1)) ${#options[@]}) ;;
                QUIT)  return ;;
                ENTER) break ;;
            esac
        done

        case $selected in
            0) execute_action "source \"\$PROJECT_ROOT/core/uninstaller.sh\" && uninstall_neovim" "Desinstalar Neovim" ;;
            1) execute_action "source \"\$PROJECT_ROOT/core/uninstaller.sh\" && uninstall_clang" "Desinstalar Clang" ;;
            2) execute_action "source \"\$PROJECT_ROOT/core/uninstaller.sh\" && uninstall_go" "Desinstalar Go" ;;
            3) execute_action "source \"\$PROJECT_ROOT/core/uninstaller.sh\" && uninstall_python" "Desinstalar Python" ;;
            4) execute_action "source \"\$PROJECT_ROOT/core/uninstaller.sh\" && uninstall_nodejs" "Desinstalar Node.js" ;;
            5) execute_action "source \"\$PROJECT_ROOT/core/uninstaller.sh\" && uninstall_all_devenvs" "Desinstalar Todos" ;;
            6) return ;;
        esac
    done
}
