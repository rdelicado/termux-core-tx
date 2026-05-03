#!/usr/bin/env bash

source "$PROJECT_ROOT/core/detection.sh"
source "$PROJECT_ROOT/core/utils.sh"
source "$PROJECT_ROOT/core/backup.sh"

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
        return 1
    fi
}

install_wget() {
    print_info "Instalando wget..."
    if command -v wget &>/dev/null; then
        print_warning "wget ya instalado: $(wget --version | head -1)"
        return 0
    fi
    
    install_package "wget"
    command -v wget &>/dev/null && print_success "wget instalado" || { print_error "Error instalando wget"; return 1; }
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
        return 1
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
                backup_zshrc
                echo "" >> "$HOME/.zshrc"
                echo "# FZF" >> "$HOME/.zshrc"
                echo "[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh" >> "$HOME/.zshrc"
            fi
        fi
    else
        print_error "Error al instalar fzf"
        return 1
    fi
}

install_zoxide() {
    print_info "Instalando zoxide..."
    if command -v zoxide &>/dev/null; then
        print_warning "zoxide ya instalado: $(zoxide --version)"
        return 0
    fi
    
    local os=$(detect_os)
    
    # On Android, use package manager (no sudo available)
    if [[ "$os" == "android" ]]; then
        install_package "zoxide"
        if command -v zoxide &>/dev/null; then
            print_success "zoxide instalado"
            backup_zshrc
            echo "" >> "$HOME/.zshrc"
            echo "# Zoxide" >> "$HOME/.zshrc"
            echo 'eval "$(zoxide init zsh)"' >> "$HOME/.zshrc"
            print_info "Añadido init a .zshrc"
        fi
        return $?
    fi
    
    local arch=$(uname -m)
    local ext=""
    
    case "$os" in
        linux)  [[ "$arch" == "x86_64" ]] && ext="x86_64" || ext="aarch64" ;;
        darwin) [[ "$arch" == "x86_64" ]] && ext="x86_64" || ext="arm64" ;;
        *)      install_package "zoxide" 2>/dev/null || print_error "Error instalando zoxide"; return 1 ;;
    esac
    
    local version="${ZOXIDE_VERSION:-0.9.0}"
    local url="https://github.com/ajeetdsouza/zoxide/releases/download/v${version}/zoxide-v${version}-${ext}-unknown-linux-musl.tar.gz"
    
    cd /tmp
    if curl -sSL "$url" -o zoxide.tar.gz; then
        tar -xzf zoxide.tar.gz
        if command -v sudo &>/dev/null; then
            sudo mv zoxide /usr/local/bin/
        else
            mv zoxide /usr/local/bin/
        fi
        rm zoxide.tar.gz
        
        if command -v zoxide &>/dev/null; then
            print_success "zoxide instalado"
            
            backup_zshrc
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
    command -v lazygit &>/dev/null && print_success "lazygit instalado" || { print_error "Error instalando lazygit"; return 1; }
}

install_btop() {
    print_info "Instalando btop/htop..."
    
    if command -v btop &>/dev/null; then
        print_warning "btop ya instalado: $(btop --version)"
        return 0
    fi
    
    if command -v htop &>/dev/null; then
        print_warning "htop ya instalado: $(htop --version)"
        return 0
    fi
    
    if install_package "btop"; then
        if command -v btop &>/dev/null; then
            print_success "btop instalado"
        elif command -v htop &>/dev/null; then
            print_success "htop instalado como alternativa"
        fi
        return 0
    else
        print_error "Error al instalar btop/htop"
        return 1
    fi
}

install_all_basetools() {
    print_info "Instalando todas las herramientas base..."
    install_git
    install_wget
    install_openssh
    install_fzf
    install_btop
    print_success "Herramientas base instaladas"
}

