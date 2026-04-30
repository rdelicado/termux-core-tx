#!/usr/bin/env bash

source "$PROJECT_ROOT/core/logger.sh"
source "$PROJECT_ROOT/modules/01-appearance/install.sh"
source "$PROJECT_ROOT/modules/02-base-tools/install.sh"
source "$PROJECT_ROOT/modules/03-dev-env/install.sh"

is_installed() {
    local tool="$1"
    command -v "$tool" &>/dev/null && return 0 || return 1
}

get_tool_status() {
    local tool="$1"
    if is_installed "$tool"; then
        echo "INSTALADO"
    else
        echo "FALTA"
    fi
}

print_tool_option() {
    local num="$1"
    local name="$2"
    local desc="$3"
    local status="$4"
    
    local color="${GREEN}"
    local status_color="${GREEN}"
    
    [[ "$status" == "FALTA" ]] && status_color="${YELLOW}"
    [[ "$status" == "INSTALADO" ]] && status_color="${GREEN}"
    
    echo -e "${GREEN}$num)${NC} ${BOLD}$name${NC} ${status_color}[$status]${NC}"
    echo -e "   ${CYAN}$desc${NC}"
}

show_appearance_menu() {
    while true; do
        banner
        echo ""
        echo -e "${CYAN}═══════════════════════════════════════════${NC}"
        echo -e "${BOLD}       ▸ APARIENCIA ◂${NC}"
        echo -e "${CYAN}═══════════════════════════════════════════${NC}"
        
        print_tool_option "1" "ZSH" "Shell avanzada y personalizable" "$(get_tool_status zsh)"
        print_tool_option "2" "Powerlevel10k" "Tema ultra-rápido con iconos" "$(get_tool_status p10k)"
        print_tool_option "3" "Autosuggestions" "Sugiere comandos de tu historial" "$(get_tool_status zsh)"
        print_tool_option "4" "Syntax Highlighting" "Colorea comandos en tiempo real" "$(get_tool_status zsh)"
        print_tool_option "5" "LSD" "El 'ls' con esteroides e iconos" "$(get_tool_status lsd)"
        print_tool_option "6" "Bat" "El 'cat' con sintaxis y números" "$(get_tool_status bat)"
        
        echo ""
        echo -e "${GREEN}A)${NC} Instalar todas"
        echo -e "${GREEN}B)${NC} Volver al menú principal"
        
        echo -ne "\n${YELLOW}▸ Selecciona:${NC} "
        read -r choice
        
        case "$choice" in
            1) install_zsh 2>/dev/null; install_oh_my_zsh 2>/dev/null ;;
            2) install_powerlevel10k 2>/dev/null ;;
            3) install_zsh_plugins 2>/dev/null ;;
            4) install_zsh_plugins 2>/dev/null ;;
            5) install_lsd 2>/dev/null ;;
            6) install_bat 2>/dev/null ;;
            A|a) 
                print_info "Instalando apariencia..."
                install_zsh 2>/dev/null; install_oh_my_zsh 2>/dev/null
                install_powerlevel10k 2>/dev/null
                install_zsh_plugins 2>/dev/null
                install_lsd 2>/dev/null; install_bat 2>/dev/null
                print_success "Apariencia completada"
                read -p "Presiona Enter para continuar..."
                ;;
            B|b) return ;;
            *) print_error "Opción inválida" ;;
        esac
    done
}

show_basetools_menu() {
    while true; do
        banner
        echo ""
        echo -e "${CYAN}═══════════════════════════════════════════${NC}"
        echo -e "${BOLD}       ▸ HERRAMIENTAS BASE ◂${NC}"
        echo -e "${CYAN}═══════════════════════════════════════════${NC}"
        
        print_tool_option "1" "Git" "Control de versiones" "$(get_tool_status git)"
        print_tool_option "2" "Wget" "Descargador de archivos" "$(get_tool_status wget)"
        print_tool_option "3" "OpenSSH" "Conexión remota segura" "$(get_tool_status ssh)"
        print_tool_option "4" "FZF" "Buscador difuso fuzzy" "$(get_tool_status fzf)"
        print_tool_option "5" "Zoxide" "CD inteligente que aprende" "$(get_tool_status zoxide)"
        print_tool_option "6" "Lazygit" "UI de git en terminal" "$(get_tool_status lazygit)"
        print_tool_option "7" "Btop" "Monitor de recursos" "$(get_tool_status btop)"
        
        echo ""
        echo -e "${GREEN}A)${NC} Instalar todas"
        echo -e "${GREEN}B)${NC} Volver al menú principal"
        
        echo -ne "\n${YELLOW}▸ Selecciona:${NC} "
        read -r choice
        
        case "$choice" in
            1) install_git 2>/dev/null ;;
            2) install_wget 2>/dev/null ;;
            3) install_openssh 2>/dev/null ;;
            4) install_fzf 2>/dev/null ;;
            5) install_zoxide 2>/dev/null ;;
            6) install_lazygit 2>/dev/null ;;
            7) install_btop 2>/dev/null ;;
            A|a) 
                print_info "Instalando herramientas base..."
                install_git 2>/dev/null; install_wget 2>/dev/null; install_openssh 2>/dev/null
                install_fzf 2>/dev/null; install_zoxide 2>/dev/null
                install_lazygit 2>/dev/null; install_btop 2>/dev/null
                print_success "Herramientas base completadas"
                read -p "Presiona Enter para continuar..."
                ;;
            B|b) return ;;
            *) print_error "Opción inválida" ;;
        esac
    done
}

show_devenv_menu() {
    while true; do
        banner
        echo ""
        echo -e "${CYAN}═══════════════════════════════════════════${NC}"
        echo -e "${BOLD}       ▸ ENTORNOS DE DESARROLLO ◂${NC}"
        echo -e "${CYAN}═══════════════════════════════════════════${NC}"
        
        print_tool_option "1" "Neovim" "Editor vim moderno" "$(get_tool_status nvim)"
        print_tool_option "2" "C/C++ (Clang)" "Compilador para C/C++" "$(get_tool_status clang)"
        print_tool_option "3" "Go" "Lenguaje de Google" "$(get_tool_status go)"
        print_tool_option "4" "Python" "Lenguaje interpretado" "$(get_tool_status python3)"
        print_tool_option "5" "Node.js" "JS del lado del servidor" "$(get_tool_status node)"
        
        echo ""
        echo -e "${GREEN}A)${NC} Instalar todas"
        echo -e "${GREEN}B)${NC} Volver al menú principal"
        
        echo -ne "\n${YELLOW}▸ Selecciona:${NC} "
        read -r choice
        
        case "$choice" in
            1) install_neovim 2>/dev/null ;;
            2) install_c_cpp 2>/dev/null ;;
            3) install_go 2>/dev/null ;;
            4) install_python 2>/dev/null ;;
            5) install_nodejs 2>/dev/null ;;
            A|a) 
                print_info "Instalando entornos..."
                install_neovim 2>/dev/null; install_c_cpp 2>/dev/null
                install_go 2>/dev/null; install_python 2>/dev/null
                install_nodejs 2>/dev/null
                print_success "Entornos de desarrollo completados"
                read -p "Presiona Enter para continuar..."
                ;;
            B|b) return ;;
            *) print_error "Opción inválida" ;;
        esac
    done
}

show_main_menu() {
    banner
    echo ""
    echo ""
    echo -e "${GREEN}1)${NC} Apariencia       (zsh, p10k, plugins, lsd, bat)"
    echo -e "${GREEN}2)${NC} Herramientas Base (git, fzf, zoxide, lazygit, btop)"
    echo -e "${GREEN}3)${NC} Entornos Dev     (Neovim, C/C++, Go, Python, Node)"
    echo -e "${GREEN}4)${NC} Instalar Todo    (todo lo que falte)"
    echo -e "${GREEN}5)${NC} Ver Estado       (herramientas instaladas)"
    echo -e "${GREEN}6)${NC} Ver Logs"
    echo -e "${GREEN}0)${NC} Salir"
    echo ""
    echo -ne "${YELLOW}▸ Selecciona:${NC} "
}

handle_main_menu() {
    local choice
    read -r choice
    
    case "$choice" in
        1) show_appearance_menu ;;
        2) show_basetools_menu ;;
        3) show_devenv_menu ;;
        4) install_all ;;
        5) show_status; read -p "Presiona Enter para continuar..." ;;
        6) show_logs; read -p "Presiona Enter para continuar..." ;;
        0) 
            log_info "Sesión finalizada"
            print_info "¡Hasta luego!"
            exit 0
            ;;
        *) 
            print_error "Opción inválida"
            ;;
    esac
}

show_status() {
    clear
    print_header "Estado de Herramientas"
    
    local tools=("zsh" "git" "fzf" "nvim" "go" "btop" "bat" "lsd" "clang" "python3" "node")
    local installed=0
    local missing=0
    
    for tool in "${tools[@]}"; do
        if is_installed "$tool"; then
            echo -e "  ${GREEN}✔${NC} $tool ${GREEN}[INSTALADO]${NC}"
            ((installed++))
        else
            echo -e "  ${YELLOW}✖${NC} $tool ${YELLOW}[FALTA]${NC}"
            ((missing++))
        fi
    done
    
    echo ""
    print_info "Instaladas: $installed | Faltantes: $missing"
}

show_logs() {
    clear
    print_header "Logs Recientes"
    local log_dir="$PROJECT_ROOT/logs"
    
    if [[ -d "$log_dir" ]] && [[ -n "$(ls -A "$log_dir" 2>/dev/null)" ]]; then
        ls -1t "$log_dir" | head -5 | while read -r log; do
            echo -e "  ${CYAN}📄${NC} $log"
        done
        echo ""
        read -p "Ver log más reciente? [s/N]: " resp
        if [[ "$resp" == "s" || "$resp" == "S" ]]; then
            local latest=$(ls -1t "$log_dir" | head -1)
            cat "$log_dir/$latest"
        fi
    else
        print_warning "No hay logs disponibles"
    fi
}

log_install_result() {
    local tool="$1"
    local status="$2"
    local path="${3:-N/A}"
    
    ((LOG_TOTAL++))
    
    if [[ "$status" == "success" ]]; then
        ((LOG_SUCCESS++))
        log_install "$tool" "success" "$path"
    else
        ((LOG_FAILED++))
        log_install "$tool" "failed" "$path"
    fi
}

install_all() {
    LOG_TOTAL=0
    LOG_SUCCESS=0
    LOG_FAILED=0
    
    print_header "Instalando Todo..."
    log_info "Iniciando instalación completa..."
    
    print_info "Módulo Apariencia..."
    install_zsh 2>/dev/null; install_oh_my_zsh 2>/dev/null
    install_powerlevel10k 2>/dev/null
    install_zsh_plugins 2>/dev/null
    install_lsd 2>/dev/null; install_bat 2>/dev/null
    
    print_info "Módulo Herramientas Base..."
    install_git 2>/dev/null; install_wget 2>/dev/null; install_openssh 2>/dev/null
    install_fzf 2>/dev/null; install_zoxide 2>/dev/null
    install_lazygit 2>/dev/null; install_btop 2>/dev/null
    
    print_info "Módulo Entornos Dev..."
    install_neovim 2>/dev/null; install_c_cpp 2>/dev/null
    install_go 2>/dev/null; install_python 2>/dev/null
    install_nodejs 2>/dev/null
    
    log_summary "$LOG_TOTAL" "$LOG_SUCCESS" "$LOG_FAILED"
    print_success "Instalación completa!"
    read -p "Presiona Enter para continuar..."
}