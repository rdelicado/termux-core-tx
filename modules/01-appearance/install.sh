#!/usr/bin/env bash

source "$PROJECT_ROOT/core/detection.sh"
source "$PROJECT_ROOT/core/utils.sh"
source "$PROJECT_ROOT/core/backup.sh"

install_zsh() {
    print_info "Instalando zsh..."
    if command -v zsh &>/dev/null; then
        print_warning "zsh ya instalado: $(command -v zsh)"
        return 0
    fi
    install_package "zsh"
    
    if command -v zsh &>/dev/null; then
        print_success "zsh instalado correctamente"
        
        print_info "Configurando zsh como shell por defecto..."
        if [[ "$(detect_os)" == "android" ]]; then
            chsh -s zsh 2>/dev/null || print_warning "No se pudo cambiar shell por defecto"
        else
            sudo chsh -s "$(command -v zsh)" 2>/dev/null || print_warning "No se pudo cambiar shell por defecto"
        fi
    else
        print_error "Error al instalar zsh"
    fi
}

install_oh_my_zsh() {
    print_info "Instalando Oh My Zsh..."
    
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        print_warning "Oh My Zsh ya está instalado"
        return 0
    fi
    
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        print_success "Oh My Zsh instalado"
    else
        print_error "Error al instalar Oh My Zsh"
    fi
}

install_powerlevel10k() {
    print_info "Instalando Powerlevel10k..."
    local p10k_dir="$HOME/powerlevel10k"
    
    if [[ -d "$p10k_dir" ]]; then
        print_warning "Powerlevel10k ya existe en $p10k_dir"
        return 0
    fi
    
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
    
    if [[ -d "$p10k_dir" ]]; then
        print_success "Powerlevel10k instalado en $p10k_dir"
        
        backup_zshrc
        
        local zshrc="$HOME/.zshrc"
        if [[ -f "$zshrc" ]]; then
            if ! grep -q "powerlevel10k" "$zshrc"; then
                echo "" >> "$zshrc"
                echo "# Powerlevel10k" >> "$zshrc"
                echo "source $p10k_dir/powerlevel10k.zsh-theme" >> "$zshrc"
                print_info "Añadido source a .zshrc"
            fi
        fi
    else
        print_error "Error al instalar Powerlevel10k"
    fi
}

install_zsh_plugins() {
    print_info "Instalando plugins de zsh..."
    local plugins_dir="$HOME/.zsh/plugins"
    mkdir -p "$plugins_dir"
    
    local autosug="$plugins_dir/zsh-autosuggestions"
    if [[ -d "$autosug" ]]; then
        print_warning "zsh-autosuggestions ya existe"
    else
        git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$autosug"
        [[ -d "$autosug" ]] && print_success "zsh-autosuggestions" || print_error "Error"
    fi
    
    local syntax="$plugins_dir/zsh-syntax-highlighting"
    if [[ -d "$syntax" ]]; then
        print_warning "zsh-syntax-highlighting ya existe"
    else
        git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$syntax"
        [[ -d "$syntax" ]] && print_success "zsh-syntax-highlighting" || print_error "Error"
    fi
    
    backup_zshrc
    
    local zshrc="$HOME/.zshrc"
    if [[ -f "$zshrc" ]]; then
        if ! grep -q "zsh-autosuggestions" "$zshrc"; then
            echo "" >> "$zshrc"
            echo "# Plugins" >> "$zshrc"
            echo "source $autosug/zsh-autosuggestions.zsh" >> "$zshrc"
            echo "source $syntax/zsh-syntax-highlighting.zsh" >> "$zshrc"
            print_info "Plugins añadidos a .zshrc"
        fi
    fi
}

install_lsd() {
    print_info "Instalando lsd..."
    if command -v lsd &>/dev/null; then
        print_warning "lsd ya instalado: $(lsd --version 2>&1 | head -1)"
        return 0
    fi
    
    install_package "lsd"
    
    if command -v lsd &>/dev/null; then
        print_success "lsd instalado"
        
        backup_zshrc
        
        local zshrc="$HOME/.zshrc"
        if [[ -f "$zshrc" ]]; then
            if ! grep -q "alias ls=" "$zshrc" 2>/dev/null; then
                echo "" >> "$zshrc"
                echo "# Aliases" >> "$zshrc"
                echo "alias ls='lsd --icons always'" >> "$zshrc"
                echo "alias ll='lsd -la --icons always'" >> "$zshrc"
                print_info "Alias de lsd añadidos"
            fi
        fi
    else
        print_error "Error al instalar lsd"
    fi
}

install_bat() {
    print_info "Instalando bat..."
    if command -v bat &>/dev/null; then
        print_warning "bat ya instalado: $(bat --version 2>&1 | head -1)"
        return 0
    fi
    
    install_package "bat"
    
    if command -v bat &>/dev/null; then
        print_success "bat instalado"
        
        backup_zshrc
        
        local zshrc="$HOME/.zshrc"
        if [[ -f "$zshrc" ]]; then
            if ! grep -q "alias cat=" "$zshrc" 2>/dev/null; then
                echo "" >> "$zshrc"
                echo "alias cat='bat --style=auto --theme=TwoDark'" >> "$zshrc"
                print_info "Alias de bat añadido"
            fi
        fi
    else
        print_error "Error al instalar bat"
    fi
}

install_all_appearance() {
    print_info "Instalando toda la apariencia..."
    install_zsh
    install_oh_my_zsh
    install_powerlevel10k
    install_zsh_plugins
    install_lsd
    install_bat
    
    print_info "Instalando fuente MesloLGS para Powerlevel10k..."
    bash "$PROJECT_ROOT/modules/01-appearance/fonts.sh" Meslo
    
    print_success "Apariencia completa instalada"
}

