#!/bin/bash

COLOR_TITLE='\033[1;38;5;211m'
COLOR_SELECTED='\033[1;38;5;225m'
COLOR_UNSELECTED='\033[38;5;250m'
COLOR_MUTED='\033[38;5;240m'
RESET='\033[0m'

execute_action() {
    local command="$1"
    local action_name="$2"
    
    tput cnorm
    clear
    banner
    echo -e "\n  ${COLOR_TITLE}[ ⚡ EJECUTANDO: $action_name ]${RESET}\n"
    
    eval "$command"
    
    echo -e "\n  ${COLOR_MUTED}Presiona ENTER para volver al menú...${RESET}"
    read -r
    
    tput civis
}

show_main_menu() {
    while true; do
        local options=(
            "Apariencia        (zsh, p10k, plugins, lsd, bat)"
            "Herramientas Base (git, fzf, zoxide, lazygit, btop)"
            "Entornos Dev      (Neovim, C/C++, Go, Python, Node)"
            "Instalar Todo     (todo lo que falte)"
            "Ver Estado        (herramientas instaladas)"
            "Ver Logs"
            "Salir"
        )
        local selected=0
        local key

        tput civis
        trap "tput cnorm; exit" INT TERM

        clear
        banner
        echo -e "  ${COLOR_TITLE}Actions${RESET}\n"
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
                        '[A') ((selected--));;
                        '[B') ((selected++));;
                    esac
                    ;;
                'k') ((selected--));;
                'j') ((selected++));;
                'q') tput cnorm; clear; exit 0 ;;
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
            0) show_appearance_menu ;;
            1) show_basetools_menu ;;
            2) show_devenv_menu ;;
            3) execute_action "source \"\$PROJECT_ROOT/modules/01-appearance/install.sh\" && install_all_appearance && source \"\$PROJECT_ROOT/modules/02-base-tools/install.sh\" && install_all_basetools && source \"\$PROJECT_ROOT/modules/03-dev-env/install.sh\" && install_all_devenvs" "Instalación de TODO el sistema" ;;
            4) show_status ;;
            5) show_logs ;;
            6) clear; exit 0 ;;
        esac
    done
}

show_appearance_menu() {
    while true; do
        local options=(
            "ZSH + Oh My Zsh    (Motor de terminal avanzado)"
            "Powerlevel10k     (Tema con icons y segmentos)"
            "Autosuggestions   (Sugiere comandos del historial)"
            "Syntax Highlight  (Colorea comandos en tiempo real)"
            "LSD               (ls moderno con iconos)"
            "Bat               (cat con syntax highlighting)"
            "Fuentes           (Nerd Fonts para iconos de p10k)"
            "Instalar Todo     (Instalar toda la apariencia)"
            "Volver            (Regresar al menú principal)"
        )
        local selected=0
        local key

        tput civis
        trap "tput cnorm; exit" INT TERM

        clear
        banner
        echo -e "  ${COLOR_TITLE}Apariencia${RESET}\n"
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
                        '[A') ((selected--));;
                        '[B') ((selected++));;
                    esac
                    ;;
                'k') ((selected--));;
                'j') ((selected++));;
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

show_fonts_menu() {
    while true; do
        local options=(
            "MesloLGS          (Recomendada para p10k)"
            "Hack Nerd Font    (Popular y completa)"
            "JetBrains Mono    (Con ligaduras)"
            "Fira Code         (Ligaduras y moderna)"
            "Volver            (Regresar al menú)"
        )
        local selected=0
        local key

        tput civis
        trap "tput cnorm; exit" INT TERM

        clear
        banner
        echo -e "  ${COLOR_TITLE}Fuentes Nerd Fonts${RESET}\n"
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
                        '[A') ((selected--));;
                        '[B') ((selected++));;
                    esac
                    ;;
                'k') ((selected--));;
                'j') ((selected++));;
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
            0) execute_action "bash \"\$PROJECT_ROOT/modules/01-appearance/fonts.sh\" Meslo" "Fuente MesloLGS" ;;
            1) execute_action "bash \"\$PROJECT_ROOT/modules/01-appearance/fonts.sh\" Hack" "Fuente Hack Nerd Font" ;;
            2) execute_action "bash \"\$PROJECT_ROOT/modules/01-appearance/fonts.sh\" JetBrainsMono" "Fuente JetBrains Mono" ;;
            3) execute_action "bash \"\$PROJECT_ROOT/modules/01-appearance/fonts.sh\" FiraCode" "Fuente Fira Code" ;;
            4) return ;;
        esac
    done
}

show_basetools_menu() {
    while true; do
        local options=(
            "Git               (Control de versiones)"
            "Wget              (Descargador de archivos)"
            "OpenSSH           (Conexión remota segura)"
            "FZF               (Buscador fuzzy interactivo)"
            "Btop/Htop         (Monitor de recursos del sistema)"
            "Instalar Todo     (Todas las herramientas base)"
            "Volver            (Regresar al menú principal)"
        )
        local selected=0
        local key

        tput civis
        trap "tput cnorm; exit" INT TERM

        clear
        banner
        echo -e "  ${COLOR_TITLE}Herramientas Base${RESET}\n"
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
                        '[A') ((selected--));;
                        '[B') ((selected++));;
                    esac
                    ;;
                'k') ((selected--));;
                'j') ((selected++));;
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

show_devenv_menu() {
    while true; do
        local options=(
            "Neovim            (Editor vim moderno)"
            "C/C++ (Clang)    (Compilador para C/C++)"
            "Go               (Lenguaje de Google)"
            "Python           (Lenguaje interpretado)"
            "Node.js          (JS del lado del servidor)"
            "Instalar Todo    (Instalar todos los entornos)"
            "Volver           (Regresar al menú principal)"
        )
        local selected=0
        local key

        tput civis
        trap "tput cnorm; exit" INT TERM

        clear
        banner
        echo -e "  ${COLOR_TITLE}Entornos de Desarrollo${RESET}\n"
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
                        '[A') ((selected--));;
                        '[B') ((selected++));;
                    esac
                    ;;
                'k') ((selected--));;
                'j') ((selected++));;
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

is_installed() {
    command -v "$1" &>/dev/null && return 0 || return 1
}

show_status() {
    local installed=0
    local missing=0
    local GREEN='\033[1;32m'
    local RED='\033[1;31m'
    local PINK='\033[1;38;5;211m'
    local NC='\033[0m'
    
    clear
    banner
    echo -e "  ${PINK}Estado de Herramientas${NC}\n"
    
    # APARIENCIA
    echo -e "\n${PINK}APARIENCIA${NC}"
    
    if is_installed "zsh"; then
        echo -e "  ${GREEN}zsh [INSTALADO]${NC}"
        ((installed++))
    else
        echo -e "  ${RED}zsh [FALTA]${NC}"
        ((missing++))
    fi
    
    if is_installed "lsd"; then
        echo -e "  ${GREEN}lsd [INSTALADO]${NC}"
        ((installed++))
    else
        echo -e "  ${RED}lsd [FALTA]${NC}"
        ((missing++))
    fi
    
    if is_installed "bat"; then
        echo -e "  ${GREEN}bat [INSTALADO]${NC}"
        ((installed++))
    else
        echo -e "  ${RED}bat [FALTA]${NC}"
        ((missing++))
    fi
    
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        echo -e "  ${GREEN}Oh My Zsh [INSTALADO]${NC}"
        ((installed++))
    else
        echo -e "  ${RED}Oh My Zsh [FALTA]${NC}"
        ((missing++))
    fi
    
    if [[ -d "$HOME/powerlevel10k" ]]; then
        echo -e "  ${GREEN}Powerlevel10k [INSTALADO]${NC}"
        ((installed++))
    else
        echo -e "  ${RED}Powerlevel10k [FALTA]${NC}"
        ((missing++))
    fi
    
    if [[ -d "$HOME/.zsh/plugins/zsh-autosuggestions" ]]; then
        echo -e "  ${GREEN}zsh-autosuggestions [INSTALADO]${NC}"
        ((installed++))
    else
        echo -e "  ${RED}zsh-autosuggestions [FALTA]${NC}"
        ((missing++))
    fi
    
    if [[ -d "$HOME/.zsh/plugins/zsh-syntax-highlighting" ]]; then
        echo -e "  ${GREEN}zsh-syntax-highlighting [INSTALADO]${NC}"
        ((installed++))
    else
        echo -e "  ${RED}zsh-syntax-highlighting [FALTA]${NC}"
        ((missing++))
    fi
    
    # HERRAMIENTAS BASE
    echo -e "\n${PINK}HERRAMIENTAS BASE${NC}"
    
    if is_installed "git"; then
        echo -e "  ${GREEN}git [INSTALADO]${NC}"
        ((installed++))
    else
        echo -e "  ${RED}git [FALTA]${NC}"
        ((missing++))
    fi
    
    if is_installed "wget"; then
        echo -e "  ${GREEN}wget [INSTALADO]${NC}"
        ((installed++))
    else
        echo -e "  ${RED}wget [FALTA]${NC}"
        ((missing++))
    fi
    
    if is_installed "ssh"; then
        echo -e "  ${GREEN}openssh [INSTALADO]${NC}"
        ((installed++))
    else
        echo -e "  ${RED}openssh [FALTA]${NC}"
        ((missing++))
    fi
    
    if is_installed "fzf"; then
        echo -e "  ${GREEN}fzf [INSTALADO]${NC}"
        ((installed++))
    else
        echo -e "  ${RED}fzf [FALTA]${NC}"
        ((missing++))
    fi
    
    if is_installed "btop"; then
        echo -e "  ${GREEN}btop [INSTALADO]${NC}"
        ((installed++))
    elif is_installed "htop"; then
        echo -e "  ${GREEN}htop (fallback) [INSTALADO]${NC}"
        ((installed++))
    else
        echo -e "  ${RED}btop/htop [FALTA]${NC}"
        ((missing++))
    fi
    
    # ENTORNOS DEV
    echo -e "\n${PINK}ENTORNOS DEV${NC}"
    
    if is_installed "nvim"; then
        echo -e "  ${GREEN}neovim [INSTALADO]${NC}"
        ((installed++))
    else
        echo -e "  ${RED}neovim [FALTA]${NC}"
        ((missing++))
    fi
    
    if is_installed "clang"; then
        echo -e "  ${GREEN}clang (C/C++) [INSTALADO]${NC}"
        ((installed++))
    else
        echo -e "  ${RED}clang (C/C++) [FALTA]${NC}"
        ((missing++))
    fi
    
    if is_installed "go"; then
        echo -e "  ${GREEN}go [INSTALADO]${NC}"
        ((installed++))
    else
        echo -e "  ${RED}go [FALTA]${NC}"
        ((missing++))
    fi
    
    if is_installed "python3" || is_installed "python"; then
        echo -e "  ${GREEN}python [INSTALADO]${NC}"
        ((installed++))
    else
        echo -e "  ${RED}python [FALTA]${NC}"
        ((missing++))
    fi
    
    if is_installed "node"; then
        echo -e "  ${GREEN}node.js [INSTALADO]${NC}"
        ((installed++))
    else
        echo -e "  ${RED}node.js [FALTA]${NC}"
        ((missing++))
    fi
    
    echo -e "\n  ${GREEN}Instaladas: $installed${NC}   ${RED}Faltantes: $missing${NC}"
    echo -e "\n  ${COLOR_MUTED}Presiona cualquier tecla para volver...${NC}"
    read -rsn1
}

show_logs() {
    local log_dir="$PROJECT_ROOT/logs"
    
    clear
    banner
    echo -e "  ${COLOR_TITLE}Logs Recientes${RESET}\n"
    
    if [[ -d "$log_dir" ]] && [[ -n "$(ls -A "$log_dir" 2>/dev/null)" ]]; then
        ls -1t "$log_dir" | head -5 | while read -r log; do
            echo -e "    ${COLOR_UNSELECTED}📄 $log${RESET}"
        done
    else
        echo -e "    ${COLOR_MUTED}No hay logs disponibles${RESET}"
    fi
    
    echo -e "\n  ${COLOR_MUTED}Presiona cualquier tecla para volver...${RESET}"
    read -rsn1
}