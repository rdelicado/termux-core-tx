#!/usr/bin/env bash

source "$PROJECT_ROOT/core/detection.sh"
source "$PROJECT_ROOT/core/utils.sh"
source "$PROJECT_ROOT/core/backup.sh"

install_zsh_full() {
    print_header "Instalando ZSH + Apariencia"
    
    print_info "1/5 - Instalando ZSH..."
    if command -v zsh &>/dev/null; then
        print_warning "ZSH ya instalado: $(command -v zsh)"
    else
        install_package "zsh"
        if ! command -v zsh &>/dev/null; then
            print_error "Error instalando ZSH"
            return 1
        fi
        print_success "ZSH instalado"
        
        if [[ "$(detect_os)" == "android" ]]; then
            chsh -s zsh 2>/dev/null || print_warning "No se pudo cambiar shell por defecto"
        else
            sudo chsh -s "$(command -v zsh)" 2>/dev/null || print_warning "No se pudo cambiar shell por defecto"
        fi
    fi
    
    print_info "2/5 - Instalando Oh My Zsh..."
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        print_warning "Oh My Zsh ya existe"
    else
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        if [[ -d "$HOME/.oh-my-zsh" ]]; then
            print_success "Oh My Zsh instalado"
        else
            print_error "Error instalando Oh My Zsh"
            return 1
        fi
    fi
    
    print_info "3/5 - Instalando Powerlevel10k..."
    local p10k_dir="$HOME/powerlevel10k"
    if [[ -d "$p10k_dir" ]]; then
        print_warning "Powerlevel10k ya existe"
    else
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
        if [[ -d "$p10k_dir" ]]; then
            print_success "Powerlevel10k instalado"
            
            backup_zshrc
            local zshrc="$HOME/.zshrc"
            if [[ -f "$zshrc" ]] && ! grep -q "powerlevel10k" "$zshrc"; then
                echo "" >> "$zshrc"
                echo "# Powerlevel10k" >> "$zshrc"
                echo "source $p10k_dir/powerlevel10k.zsh-theme" >> "$zshrc"
            fi
        else
            print_error "Error instalando Powerlevel10k"
        fi
    fi
    
    print_info "4/5 - Instalando zsh-autosuggestions..."
    local autosug_dir="$HOME/.zsh/plugins/zsh-autosuggestions"
    if [[ -d "$autosug_dir" ]]; then
        print_warning "zsh-autosuggestions ya existe"
    else
        mkdir -p "$HOME/.zsh/plugins"
        git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$autosug_dir"
        if [[ -d "$autosug_dir" ]]; then
            print_success "zsh-autosuggestions instalado"
            
            backup_zshrc
            local zshrc="$HOME/.zshrc"
            if [[ -f "$zshrc" ]] && ! grep -q "zsh-autosuggestions" "$zshrc"; then
                echo "" >> "$zshrc"
                echo "# Plugins" >> "$zshrc"
                echo "source $autosug_dir/zsh-autosuggestions.zsh" >> "$zshrc"
            fi
        else
            print_error "Error instalando zsh-autosuggestions"
        fi
    fi
    
    print_info "5/5 - Instalando zsh-syntax-highlighting..."
    local syntax_dir="$HOME/.zsh/plugins/zsh-syntax-highlighting"
    if [[ -d "$syntax_dir" ]]; then
        print_warning "zsh-syntax-highlighting ya existe"
    else
        mkdir -p "$HOME/.zsh/plugins"
        git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$syntax_dir"
        if [[ -d "$syntax_dir" ]]; then
            print_success "zsh-syntax-highlighting instalado"
            
            backup_zshrc
            local zshrc="$HOME/.zshrc"
            if [[ -f "$zshrc" ]] && ! grep -q "zsh-syntax-highlighting" "$zshrc"; then
                echo "" >> "$zshrc"
                echo "source $syntax_dir/zsh-syntax-highlighting.zsh" >> "$zshrc"
            fi
        else
            print_error "Error instalando zsh-syntax-highlighting"
        fi
    fi
    
    print_success "Instalación de Apariencia completada!"
    print_info "Ejecuta 'zsh' para ver los cambios"
}

install_zsh_full "$@"