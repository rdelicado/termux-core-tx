#!/usr/bin/env bash

source "$PROJECT_ROOT/core/detection.sh"
source "$PROJECT_ROOT/core/utils.sh"

install_font() {
    local font_name="$1"
    local font_url=""
    
    case "$font_name" in
        Meslo)
            font_url="https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
            print_info "Instalando fuente MesloLGS (recomendada para p10k)..."
            ;;
        Hack)
            font_url="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/HackNerdFont-Regular.ttf"
            print_info "Instalando fuente Hack Nerd Font..."
            ;;
        JetBrainsMono)
            font_url="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf"
            print_info "Instalando fuente JetBrains Mono..."
            ;;
        FiraCode)
            font_url="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/FiraCodeNerdFont-Regular.ttf"
            print_info "Instalando fuente Fira Code..."
            ;;
        *)
            print_error "Fuente desconocida: $font_name"
            return 1
            ;;
    esac
    
    mkdir -p "$HOME/.termux"
    
    if curl -fLo "$HOME/.termux/font.ttf" "$font_url" 2>&1; then
        print_success "Fuente $font_name descargada"
        
        if command -v termux-reload-settings &>/dev/null; then
            termux-reload-settings
            print_info "Configuración de Termux recargada"
        fi
        
        print_success "Fuente $font_name aplicada correctamente"
        print_info "Los iconos de Powerlevel10k ahora deberían verse correctamente"
        return 0
    else
        print_error "Error al descargar la fuente $font_name"
        return 1
    fi
}

if [[ -n "$1" ]]; then
    install_font "$1"
else
    print_error "Uso: $0 <Meslo|Hack|JetBrainsMono|FiraCode>"
    exit 1
fi