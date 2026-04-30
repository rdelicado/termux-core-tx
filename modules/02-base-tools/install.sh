#!/usr/bin/env bash

source "$PROJECT_ROOT/core/detection.sh"
source "$PROJECT_ROOT/core/utils.sh"

install_git() {
    print_info "Instalando git..."
    if command -v git &>/dev/null; then
        print_warning "git ya instalado: $(git --version)"
        return 0
    fi
    
    install_package "git"
    
    if command -v git &>/dev/null; then
        print_success "git instalado: $(git --version)"
        
        print_info "Configurando git..."
        read -p "Nombre para git: " git_name
        read -p "Email para git: " git_email
        
        if [[ -n "$git_name" ]]; then
            git config --global user.name "$git_name"
        fi
        if [[ -n "$git_email" ]]; then
            git config --global user.email "$git_email"
        fi
        
        print_success "git configurado"
    else
        print_error "Error al instalar git"
    fi
}

install_wget() {
    print_info "Instalando wget..."
    if command -v wget &>/dev/null; then
        print_warning "wget ya instalado: $(wget --version | head -1)"
        return 0
    fi
    
    install_package "wget"
    command -v wget &>/dev/null && print_success "wget instalado" || print_error "Error"
}

install_openssh() {
    print_info "Instalando openssh..."
    if command -v ssh &>/dev/null; then
        print_warning "ssh ya instalado: $(ssh -V 2>&1)"
        return 0
    fi
    
    install_package "openssh"
    
    if command -v ssh &>/dev/null; then
        print_success "openssh instalado"
        print_info "Para usar ssh: genera keys con ssh-keygen"
    else
        print_error "Error al instalar openssh"
    fi
}

install_fzf() {
    print_info "Instalando fzf..."
    if command -v fzf &>/dev/null; then
        print_warning "fzf ya instalado"
        return 0
    fi
    
    install_package "fzf"
    
    if command -v fzf &>/dev/null; then
        print_success "fzf instalado"
        
        local fzf_dir="$HOME/.fzf"
        if [[ -d "$fzf_dir" ]]; then
            if ! grep -q "fzf" "$HOME/.zshrc" 2>/dev/null; then
                echo "" >> "$HOME/.zshrc"
                echo "# FZF" >> "$HOME/.zshrc"
                echo "[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh" >> "$HOME/.zshrc"
            fi
        fi
    else
        print_error "Error al instalar fzf"
    fi
}

install_zoxide() {
    print_info "Instalando zoxide..."
    if command -v zoxide &>/dev/null; then
        print_warning "zoxide ya instalado: $(zoxide --version)"
        return 0
    fi
    
    local os=$(detect_os)
    local arch=$(uname -m)
    local ext=""
    
    case "$os" in
        android) ext="aarch64" ;;
        linux)  [[ "$arch" == "x86_64" ]] && ext="x86_64" || ext="aarch64" ;;
        darwin) [[ "$arch" == "x86_64" ]] && ext="x86_64" || ext="arm64" ;;
    esac
    
    local version="0.9.0"
    local url="https://github.com/ajeetdsouza/zoxide/releases/download/v${version}/zoxide-v${version}-${ext}-unknown-linux-musl.tar.gz"
    
    cd /tmp
    if curl -sSL "$url" -o zoxide.tar.gz; then
        tar -xzf zoxide.tar.gz
        sudo mv zoxide /usr/local/bin/
        rm zoxide.tar.gz
        
        if command -v zoxide &>/dev/null; then
            print_success "zoxide instalado"
            
            echo "" >> "$HOME/.zshrc"
            echo "# Zoxide" >> "$HOME/.zshrc"
            echo 'eval "$(zoxide init zsh)"' >> "$HOME/.zshrc"
            
            print_info "Añadido init a .zshrc"
        fi
    else
        install_package "zoxide" 2>/dev/null || print_error "Error instalando zoxide"
    fi
}

install_lazygit() {
    print_info "Instalando lazygit..."
    if command -v lazygit &>/dev/null; then
        print_warning "lazygit ya instalado: $(lazygit --version)"
        return 0
    fi
    
    install_package "lazygit"
    command -v lazygit &>/dev/null && print_success "lazygit instalado" || print_error "Error"
}

install_btop() {
    print_info "Instalando btop..."
    if command -v btop &>/dev/null; then
        print_warning "btop ya instalado: $(btop --version)"
        return 0
    fi
    
    install_package "btop"
    command -v btop &>/dev/null && print_success "btop instalado" || print_error "Error"
}

run_basetools_module() {
    local choice
    show_basetools_menu
    read -r choice
    
    case "$choice" in
        1) install_git ;;
        2) install_wget ;;
        3) install_openssh ;;
        4) install_fzf ;;
        5) install_zoxide ;;
        6) install_lazygit ;;
        7) install_btop ;;
        8) 
            print_info "Instalando herramientas base..."
            install_git
            install_wget
            install_openssh
            install_fzf
            install_zoxide
            install_lazygit
            install_btop
            print_success "Módulo Herramientas Base completado"
            ;;
        0) return ;;
        *) print_error "Opción inválida" ;;
    esac
}