#!/usr/bin/env bash

install_zsh() {
    print_info "Instalando zsh..."
    if command -v zsh &>/dev/null; then
        print_warning "zsh ya está instalado: $(command -v zsh)"
        read -p "Reinstalar? [s/N]: " resp
        [[ "$resp" != "s" && "$resp" != "S" ]] && return 0
    fi
    install_package "zsh"
    print_success "zsh instalado"
}

install_powerlevel10k() {
    print_info "Instalando Powerlevel10k..."
    local p10k_dir="$HOME/powerlevel10k"
    if [[ -d "$p10k_dir" ]]; then
        print_warning "Powerlevel10k ya existe en $p10k_dir"
        return 0
    fi
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
    print_success "Powerlevel10k instalado"
}

install_zsh_autosuggestions() {
    print_info "Instalando zsh-autosuggestions..."
    local plugin_dir="$HOME/.zsh/plugins/zsh-autosuggestions"
    if [[ -d "$plugin_dir" ]]; then
        print_warning "Plugin ya existe"
        return 0
    fi
    mkdir -p "$HOME/.zsh/plugins"
    git clone https://github.com/zsh-users/zsh-autosuggestions "$plugin_dir"
    print_success "zsh-autosuggestions instalado"
}

install_zsh_highlighting() {
    print_info "Instalando zsh-syntax-highlighting..."
    local plugin_dir="$HOME/.zsh/plugins/zsh-syntax-highlighting"
    if [[ -d "$plugin_dir" ]]; then
        print_warning "Plugin ya existe"
        return 0
    fi
    mkdir -p "$HOME/.zsh/plugins"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$plugin_dir"
    print_success "zsh-syntax-highlighting instalado"
}

install_lsd() {
    print_info "Instalando lsd..."
    if command -v lsd &>/dev/null; then
        print_warning "lsd ya instalado"
        return 0
    fi
    install_package "lsd"
    print_success "lsd instalado"
}

install_bat() {
    print_info "Instalando bat..."
    if command -v bat &>/dev/null; then
        print_warning "bat ya instalado"
        return 0
    fi
    install_package "bat"
    print_success "bat instalado"
}

install_git() {
    print_info "Instalando git..."
    if command -v git &>/dev/null; then
        print_warning "git ya instalado: $(command -v git)"
        return 0
    fi
    install_package "git"
    print_success "git instalado"
}

install_wget() {
    print_info "Instalando wget..."
    if command -v wget &>/dev/null; then
        print_warning "wget ya instalado"
        return 0
    fi
    install_package "wget"
    print_success "wget instalado"
}

install_openssh() {
    print_info "Instalando openssh..."
    if command -v ssh &>/dev/null; then
        print_warning "ssh ya instalado"
        return 0
    fi
    install_package "openssh"
    print_success "openssh instalado"
}

install_fzf() {
    print_info "Instalando fzf..."
    if command -v fzf &>/dev/null; then
        print_warning "fzf ya instalado"
        return 0
    fi
    install_package "fzf"
    print_success "fzf instalado"
}

install_zoxide() {
    print_info "Instalando zoxide..."
    if command -v zoxide &>/dev/null; then
        print_warning "zoxide ya instalado"
        return 0
    fi
    curl -sSf https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
    print_success "zoxide instalado"
}

install_lazygit() {
    print_info "Instalando lazygit..."
    if command -v lazygit &>/dev/null; then
        print_warning "lazygit ya instalado"
        return 0
    fi
    install_package "lazygit"
    print_success "lazygit instalado"
}

install_btop() {
    print_info "Instalando btop..."
    if command -v btop &>/dev/null; then
        print_warning "btop ya instalado"
        return 0
    fi
    install_package "btop"
    print_success "btop instalado"
}

install_neovim() {
    print_info "Instalando Neovim..."
    if command -v nvim &>/dev/null; then
        print_warning "nvim ya instalado"
        return 0
    fi
    install_package "neovim"
    print_success "Neovim instalado"
}

install_c_cpp() {
    print_info "Instalando GCC/Clang..."
    if command -v gcc &>/dev/null; then
        print_warning "gcc ya instalado"
        return 0
    fi
    install_package "clang"
    print_success "C/C++ instalado"
}

install_go() {
    print_info "Instalando Go..."
    if command -v go &>/dev/null; then
        print_warning "go ya instalado: $(go version)"
        return 0
    fi
    
    local os=$(detect_os)
    local arch="amd64"
    [[ "$(uname -m)" == "aarch64" ]] && arch="arm64"
    
    local go_version="1.21.5"
    local go_archive="go${go_version}.linux-${arch}.tar.gz"
    
    cd /tmp
    wget -q "https://go.dev/dl/${go_archive}"
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf "$go_archive"
    rm "$go_archive"
    
    export PATH=$PATH:/usr/local/go/bin
    print_success "Go instalado"
}

install_python() {
    print_info "Instalando Python..."
    if command -v python &>/dev/null; then
        print_warning "python ya instalado: $(python --version)"
        return 0
    fi
    install_package "python"
    install_package "python-pip"
    print_success "Python instalado"
}

install_nodejs() {
    print_info "Instalando Node.js..."
    if command -v node &>/dev/null; then
        print_warning "node ya instalado: $(node --version)"
        return 0
    fi
    install_package "nodejs"
    print_success "Node.js instalado"
}