#!/usr/bin/env bash

source "$PROJECT_ROOT/core/detection.sh"
source "$PROJECT_ROOT/core/utils.sh"
source "$PROJECT_ROOT/core/backup.sh"

install_neovim() {
    print_info "Instalando Neovim..."
    if command -v nvim &>/dev/null; then
        print_warning "Neovim ya instalado: $(nvim --version | head -1)"
        return 0
    fi
    
    install_package "neovim"
    
    if command -v nvim &>/dev/null; then
        print_success "Neovim instalado"
        
        print_info "Configurando Neovim..."
        
        local nvim_dir="$HOME/.config/nvim"
        local nvim_init="$nvim_dir/init.vim"
        
        mkdir -p "$nvim_dir"
        
        cat > "$nvim_init" << 'EOF'
" Neovim Config - Termux Custom Toolkit
syntax on
set number
set relativenumber
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set showmatch
set hlsearch
set enc=utf-8

" Theme
colorscheme gruvbox

" Plugins (requiere plugin manager)
" Añade tus plugins aquí
EOF
        
        print_success "Configuración básica creada en $nvim_init"
    else
        print_error "Error al instalar Neovim"
    fi
}

install_c_cpp() {
    print_info "Instalando C/C++ (Clang)..."
    
    if command -v gcc &>/dev/null; then
        print_warning "GCC ya instalado: $(gcc --version | head -1)"
    fi
    
    if command -v clang &>/dev/null; then
        print_warning "Clang ya instalado: $(clang --version | head -1)"
        return 0
    fi
    
    install_package "clang"
    install_package "make"
    
    if command -v clang &>/dev/null; then
        print_success "Clang instalado: $(clang --version | head -1)"
        print_info "Puedes compilar con: clang archivo.c -o programa"
    else
        print_error "Error al instalar C/C++"
    fi
}

install_go() {
    print_info "Instalando Go..."
    
    if command -v go &>/dev/null; then
        print_warning "Go ya instalado: $(go version)"
        return 0
    fi
    
    local os=$(detect_os)
    local arch=$(uname -m)
    local go_arch="amd64"
    
    case "$arch" in
        x86_64)  go_arch="amd64" ;;
        aarch64|arm64) go_arch="arm64" ;;
        *)      go_arch="amd64" ;;
    esac
    
    local go_version="1.21.5"
    local go_file="go${go_version}.linux-${go_arch}.tar.gz"
    local go_url="https://go.dev/dl/${go_file}"
    
    cd /tmp
    
    if command -v wget &>/dev/null; then
        wget -q "$go_url" -O "$go_file"
    else
        curl -sSL "$go_url" -o "$go_file"
    fi
    
    if [[ -f "$go_file" ]]; then
        if [[ "$(detect_os)" == "android" ]]; then
            rm -rf "$HOME/go"
            tar -C "$HOME" -xzf "$go_file"
            export PATH="$HOME/go/bin:$PATH"
        else
            sudo rm -rf /usr/local/go
            sudo tar -C /usr/local -xzf "$go_file"
        fi
        
        rm "$go_file"
        
        if command -v go &>/dev/null; then
            print_success "Go instalado: $(go version)"
            
            echo "" >> "$HOME/.zshrc"
            echo "# Go" >> "$HOME/.zshrc"
            echo 'export PATH=$PATH:$HOME/go/bin' >> "$HOME/.zshrc"
            print_info "Go añadido al PATH"
        fi
    else
        print_error "Error al descargar Go"
    fi
}

install_python() {
    print_info "Instalando Python..."
    
    if command -v python3 &>/dev/null; then
        print_warning "Python3 ya instalado: $(python3 --version)"
        return 0
    fi
    
    if command -v python &>/dev/null; then
        print_warning "Python ya instalado: $(python --version)"
        return 0
    fi
    
    install_package "python"
    
    if command -v python3 &>/dev/null; then
        print_success "Python3 instalado: $(python3 --version)"
        
        install_package "python-pip"
        
        if command -v pip3 &>/dev/null; then
            print_success "pip3 instalado"
        fi
    else
        print_error "Error al instalar Python"
    fi
}

install_nodejs() {
    print_info "Instalando Node.js..."
    
    if command -v node &>/dev/null; then
        print_warning "Node.js ya instalado: $(node --version)"
        return 0
    fi
    
    install_package "nodejs"
    
    if command -v node &>/dev/null; then
        print_success "Node.js instalado: $(node --version)"
        print_info "npm disponible: $(npm --version 2>/dev/null)"
    else
        print_error "Error al instalar Node.js"
    fi
}

install_rust() {
    print_info "Instalando Rust..."
    
    if command -v rustc &>/dev/null; then
        print_warning "Rust ya instalado: $(rustc --version)"
        return 0
    fi
    
    if command -v curl &>/dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    else
        print_error "curl no disponible"
        return 1
    fi
    
    if [[ -f "$HOME/.cargo/bin/rustc" ]]; then
        export PATH="$HOME/.cargo/bin:$PATH"
        print_success "Rust instalado: $(rustc --version)"
        
        echo "" >> "$HOME/.zshrc"
        echo "# Rust" >> "$HOME/.zshrc"
        echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> "$HOME/.zshrc"
    else
        print_error "Error al instalar Rust"
    fi
}

install_all_devenvs() {
    print_info "Instalando todos los entornos de desarrollo..."
    install_neovim
    install_c_cpp
    install_go
    install_python
    install_nodejs
    print_success "Entornos de desarrollo instalados"
}

run_devenv_module() {
    local choice
    show_devenv_menu
    read -r choice
    
    case "$choice" in
        1) install_neovim ;;
        2) install_c_cpp ;;
        3) install_go ;;
        4) install_python ;;
        5) install_nodejs ;;
        6) 
            print_info "Instalando entornos de desarrollo..."
            install_neovim
            install_c_cpp
            install_go
            install_python
            install_nodejs
            print_success "Módulo Entornos Dev completado"
            ;;
        0) return ;;
        *) print_error "Opción inválida" ;;
    esac
}