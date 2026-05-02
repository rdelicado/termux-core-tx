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
            3) install_all ;;
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
            0) execute_action "bash modules/01-appearance/zsh.sh" "ZSH + Oh My Zsh" ;;
            1) execute_action "bash modules/01-appearance/install.sh" "Powerlevel10k" ;;
            2) execute_action "bash modules/01-appearance/install.sh" "Plugins ZSH" ;;
            3) execute_action "bash modules/01-appearance/install.sh" "Plugins ZSH" ;;
            4) execute_action "pkg install lsd -y" "LSD" ;;
            5) execute_action "pkg install bat -y" "Bat" ;;
            6) execute_action "bash modules/01-appearance/install.sh" "Instalación Completa Apariencia" ;;
            7) return ;;
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
            5) return ;;
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
            5) execute_action "source \$PROJECT_ROOT/modules/03-dev-env/install.sh && install_neovim && install_c_cpp && install_go && install_python && install_nodejs" "Instalar Todos los Entornos" ;;
            6) return ;;
        esac
    done
}

is_installed() {
    command -v "$1" &>/dev/null && return 0 || return 1
}

show_status() {
    local tools=("zsh" "git" "fzf" "nvim" "go" "btop" "bat" "lsd" "clang" "python3" "node")
    local installed=0
    local missing=0
    
    clear
    banner
    echo -e "  ${COLOR_TITLE}Estado de Herramientas${RESET}\n"
    
    for tool in "${tools[@]}"; do
        if is_installed "$tool"; then
            echo -e "    ${COLOR_SELECTED}✔${RESET} ${tool} ${COLOR_UNSELECTED}[INSTALADO]${RESET}"
            ((installed++))
        else
            echo -e "    ${COLOR_MUTED}✖${RESET} ${tool} ${COLOR_MUTED}[FALTA]${RESET}"
            ((missing++))
        fi
    done
    
    echo -e "\n  ${COLOR_SELECTED}Instaladas: $installed${RESET}  ${COLOR_MUTED}|${RESET}  ${COLOR_TITLE}Faltantes: $missing${RESET}"
    echo -e "\n  ${COLOR_MUTED}Presiona cualquier tecla para volver...${RESET}"
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