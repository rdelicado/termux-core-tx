#!/usr/bin/env bash

source "$PROJECT_ROOT/core/detection.sh"
source "$PROJECT_ROOT/core/utils.sh"
source "$PROJECT_ROOT/core/backup.sh"

uninstall_zsh_cascade() {
    local cascade_msg="Oh My Zsh, Powerlevel10k, zsh-autosuggestions, zsh-syntax-highlighting, ~/.zshrc"
    
    if ! confirm_uninstall "ZSH (con cascada)" "$cascade_msg"; then
        return 1
    fi
    
    print_info "Desinstalando ZSH y componentes relacionados..."
    
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        print_info "Eliminando Oh My Zsh..."
        rm -rf "$HOME/.oh-my-zsh"
        print_success "Oh My Zsh eliminado"
    fi
    
    if [[ -d "$HOME/powerlevel10k" ]]; then
        print_info "Eliminando Powerlevel10k..."
        rm -rf "$HOME/powerlevel10k"
        print_success "Powerlevel10k eliminado"
    fi
    
    if [[ -d "$HOME/.zsh/plugins/zsh-autosuggestions" ]]; then
        print_info "Eliminando zsh-autosuggestions..."
        rm -rf "$HOME/.zsh/plugins/zsh-autosuggestions"
    fi
    
    if [[ -d "$HOME/.zsh/plugins/zsh-syntax-highlighting" ]]; then
        print_info "Eliminando zsh-syntax-highlighting..."
        rm -rf "$HOME/.zsh/plugins/zsh-syntax-highlighting"
    fi
    
    if [[ -f "$HOME/.zshrc" ]]; then
        backup_zshrc
        rm -f "$HOME/.zshrc"
        print_info ".zshrc eliminado"
    fi
    
    local os=$(detect_os)
    if [[ "$os" == "android" ]]; then
        chsh -s bash 2>/dev/null || print_warning "No se pudo cambiar shell a bash"
    else
        sudo chsh -s /bin/bash 2>/dev/null || print_warning "No se pudo cambiar shell a bash"
    fi
    print_info "Shell cambiada a bash"
    
    uninstall_package "zsh"
    if [[ $? -eq 0 ]]; then
        print_success "ZSH desinstalado completamente"
    else
        print_error "Error al desinstalar ZSH"
        return 1
    fi
    
    return 0
}

uninstall_oh_my_zsh_only() {
    if ! confirm_uninstall "Oh My Zsh" "Powerlevel10k, plugins de ZSH, pero ZSH se mantiene"; then
        return 1
    fi
    
    print_info "Desinstalando Oh My Zsh (ZSH se mantiene)..."
    
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        rm -rf "$HOME/.oh-my-zsh"
        print_success "Oh My Zsh eliminado"
    fi
    
    if [[ -d "$HOME/powerlevel10k" ]]; then
        rm -rf "$HOME/powerlevel10k"
        print_success "Powerlevel10k eliminado"
    fi
    
    if [[ -d "$HOME/.zsh/plugins" ]]; then
        rm -rf "$HOME/.zsh/plugins"
        print_success "Plugins de ZSH eliminados"
    fi
    
    if [[ -f "$HOME/.zshrc" ]]; then
        backup_zshrc
        rm -f "$HOME/.zshrc"
    fi
    
    print_success "Oh My Zsh desinstalado (ZSH se mantiene)"
    return 0
}

uninstall_powerlevel10k() {
    if ! confirm_uninstall "Powerlevel10k" "Solo el tema"; then
        return 1
    fi
    
    print_info "Desinstalando Powerlevel10k..."
    
    if [[ -d "$HOME/powerlevel10k" ]]; then
        rm -rf "$HOME/powerlevel10k"
        print_success "Powerlevel10k eliminado"
    fi
    
    if [[ -f "$HOME/.zshrc" ]]; then
        sed -i '/powerlevel10k/d' "$HOME/.zshrc" 2>/dev/null
    fi
    
    print_success "Powerlevel10k desinstalado"
    return 0
}

uninstall_zsh_plugins() {
    if ! confirm_uninstall "Plugins de ZSH" "zsh-autosuggestions, zsh-syntax-highlighting"; then
        return 1
    fi
    
    print_info "Desinstalando plugins de ZSH..."
    
    if [[ -d "$HOME/.zsh/plugins/zsh-autosuggestions" ]]; then
        rm -rf "$HOME/.zsh/plugins/zsh-autosuggestions"
        print_success "zsh-autosuggestions eliminado"
    fi
    
    if [[ -d "$HOME/.zsh/plugins/zsh-syntax-highlighting" ]]; then
        rm -rf "$HOME/.zsh/plugins/zsh-syntax-highlighting"
        print_success "zsh-syntax-highlighting eliminado"
    fi
    
    if [[ -f "$HOME/.zshrc" ]]; then
        sed -i '/zsh-autosuggestions/d' "$HOME/.zshrc" 2>/dev/null
        sed -i '/zsh-syntax-highlighting/d' "$HOME/.zshrc" 2>/dev/null
    fi
    
    print_success "Plugins de ZSH desinstalados"
    return 0
}

uninstall_lsd() {
    if ! confirm_uninstall "lsd" "Ninguna dependencia"; then
        return 1
    fi
    
    print_info "Desinstalando lsd..."
    uninstall_package "lsd"
    
    if [[ -f "$HOME/.zshrc" ]]; then
        sed -i "s/alias ls='lsd.*'/alias ls='ls --color=auto'/" "$HOME/.zshrc" 2>/dev/null
        sed -i '/lsd/d' "$HOME/.zshrc" 2>/dev/null
    fi
    
    if command -v lsd &>/dev/null; then
        print_error "Error al desinstalar lsd"
        return 1
    else
        print_success "lsd desinstalado"
        return 0
    fi
}

uninstall_bat() {
    if ! confirm_uninstall "bat" "Ninguna dependencia"; then
        return 1
    fi
    
    print_info "Desinstalando bat..."
    uninstall_package "bat"
    
    if [[ -f "$HOME/.zshrc" ]]; then
        sed -i '/alias cat=/d' "$HOME/.zshrc" 2>/dev/null
    fi
    
    if command -v bat &>/dev/null; then
        print_error "Error al desinstalar bat"
        return 1
    else
        print_success "bat desinstalado"
        return 0
    fi
}

uninstall_git() {
    print_warning "Git está PROTEGIDO y no puede ser desinstalado"
    print_info "Es una dependencia crítica del sistema"
    return 1
}

uninstall_wget() {
    if ! confirm_uninstall "wget" "Ninguna dependencia"; then
        return 1
    fi
    
    print_info "Desinstalando wget..."
    uninstall_package "wget"
    
    if command -v wget &>/dev/null; then
        print_error "Error al desinstalar wget"
        return 1
    else
        print_success "wget desinstalado"
        return 0
    fi
}

uninstall_openssh() {
    if ! confirm_uninstall "OpenSSH" "Ninguna dependencia"; then
        return 1
    fi
    
    print_info "Desinstalando OpenSSH..."
    uninstall_package "openssh"
    
    if command -v ssh &>/dev/null; then
        print_error "Error al desinstalar OpenSSH"
        return 1
    else
        print_success "OpenSSH desinstalado"
        return 0
    fi
}

uninstall_fzf() {
    if ! confirm_uninstall "FZF" "Ninguna dependencia"; then
        return 1
    fi
    
    print_info "Desinstalando FZF..."
    uninstall_package "fzf"
    
    if [[ -d "$HOME/.fzf" ]]; then
        rm -rf "$HOME/.fzf"
    fi
    
    if [[ -f "$HOME/.zshrc" ]]; then
        sed -i '/fzf/d' "$HOME/.zshrc" 2>/dev/null
    fi
    
    if command -v fzf &>/dev/null; then
        print_error "Error al desinstalar FZF"
        return 1
    else
        print_success "FZF desinstalado"
        return 0
    fi
}

uninstall_btop_htop() {
    if ! confirm_uninstall "btop/htop" "Ninguna dependencia"; then
        return 1
    fi
    
    print_info "Desinstalando btop/htop..."
    uninstall_package "btop" 2>/dev/null
    uninstall_package "htop" 2>/dev/null
    
    if command -v btop &>/dev/null || command -v htop &>/dev/null; then
        print_error "Error al desinstalar btop/htop"
        return 1
    else
        print_success "btop/htop desinstalado"
        return 0
    fi
}

uninstall_tmux() {
    if ! confirm_uninstall "tmux" "Ninguna dependencia"; then
        return 1
    fi

    print_info "Desinstalando tmux..."
    uninstall_package "tmux"

    if command -v tmux &>/dev/null; then
        print_error "Error al desinstalar tmux"
        return 1
    else
        print_success "tmux desinstalado"
        return 0
    fi
}

uninstall_dotfiles() {
    local dotfiles_dir="$PROJECT_ROOT/dotfiles"

    if ! confirm_uninstall "Dotfiles Manager" "symlinks creados desde $dotfiles_dir"; then
        return 1
    fi

    print_info "Eliminando symlinks de dotfiles..."

    if [[ ! -d "$dotfiles_dir" ]]; then
        print_warning "No existe $dotfiles_dir"
        return 0
    fi

    local link
    while IFS= read -r -d '' link; do
        local target
        target="$(readlink -f "$link" 2>/dev/null)"

        if [[ -n "$target" && "$target" == "$dotfiles_dir"* ]]; then
            rm -f "$link"
            print_success "Eliminado: ${link#$HOME/}"
        fi
    done < <(find "$HOME" -type l -print0 2>/dev/null)

    print_success "Dotfiles Manager desinstalado"
    return 0
}

uninstall_proot_debian() {
    if ! confirm_uninstall "Debian (proot-distro)" "rootfs y datos del contenedor"; then
        return 1
    fi

    print_info "Eliminando Debian de proot-distro..."

    if ! command -v proot-distro &>/dev/null; then
        print_error "proot-distro no está instalado"
        return 1
    fi

    proot-distro remove debian

    print_success "Debian eliminado"
}

uninstall_proot_alpine() {
    if ! confirm_uninstall "Alpine (proot-distro)" "rootfs y datos del contenedor"; then
        return 1
    fi

    print_info "Eliminando Alpine de proot-distro..."

    if ! command -v proot-distro &>/dev/null; then
        print_error "proot-distro no está instalado"
        return 1
    fi

    proot-distro remove alpine

    print_success "Alpine eliminado"
}

uninstall_proot_distro() {
    if ! confirm_uninstall "proot-distro" "Debian, Alpine y otros rootfs instalados"; then
        return 1
    fi

    print_info "Eliminando contenedores proot-distro..."

    if command -v proot-distro &>/dev/null; then
        proot-distro remove debian 2>/dev/null
        proot-distro remove alpine 2>/dev/null
        uninstall_package "proot-distro"
    else
        print_warning "proot-distro no está instalado"
    fi

    if command -v proot-distro &>/dev/null; then
        print_error "proot-distro sigue instalado"
        return 1
    fi

    print_success "proot-distro desinstalado"
    return 0
}

uninstall_neovim() {
    if ! confirm_uninstall "Neovim" "~/.config/nvim"; then
        return 1
    fi
    
    print_info "Desinstalando Neovim..."
    uninstall_package "neovim"
    
    if [[ -d "$HOME/.config/nvim" ]]; then
        rm -rf "$HOME/.config/nvim"
        print_success "Configuración de Neovim eliminada"
    fi
    
    if command -v nvim &>/dev/null; then
        print_error "Error al desinstalar Neovim"
        return 1
    else
        print_success "Neovim desinstalado"
        return 0
    fi
}

uninstall_clang() {
    if ! confirm_uninstall "Clang (C/C++)" "Ninguna dependencia"; then
        return 1
    fi
    
    print_info "Desinstalando Clang..."
    uninstall_package "clang"
    uninstall_package "make" 2>/dev/null
    
    if command -v clang &>/dev/null; then
        print_error "Error al desinstalar Clang"
        return 1
    else
        print_success "Clang desinstalado"
        return 0
    fi
}

uninstall_go() {
    if ! confirm_uninstall "Go" "~/.local/go o /usr/local/go"; then
        return 1
    fi
    
    print_info "Desinstalando Go..."
    
    local os=$(detect_os)
    if [[ "$os" == "android" ]]; then
        uninstall_package "golang"
        rm -rf "$HOME/go" 2>/dev/null
    else
        sudo rm -rf /usr/local/go
    fi
    
    if [[ -f "$HOME/.zshrc" ]]; then
        sed -i '/go/d' "$HOME/.zshrc" 2>/dev/null
    fi
    
    if command -v go &>/dev/null; then
        print_error "Error al desinstalar Go"
        return 1
    else
        print_success "Go desinstalado"
        return 0
    fi
}

uninstall_python() {
    if ! confirm_uninstall "Python" "~/.local/pip"; then
        return 1
    fi
    
    print_info "Desinstalando Python..."
    uninstall_package "python"
    uninstall_package "python-pip" 2>/dev/null
    uninstall_package "python3" 2>/dev/null
    
    if command -v python &>/dev/null || command -v python3 &>/dev/null; then
        print_error "Error al desinstalar Python"
        return 1
    else
        print_success "Python desinstalado"
        return 0
    fi
}

uninstall_nodejs() {
    if ! confirm_uninstall "Node.js" "npm global packages"; then
        return 1
    fi
    
    print_info "Desinstalando Node.js..."
    uninstall_package "nodejs"
    uninstall_package "node" 2>/dev/null
    
    if command -v node &>/dev/null; then
        print_error "Error al desinstalar Node.js"
        return 1
    else
        print_success "Node.js desinstalado"
        return 0
    fi
}

uninstall_all_appearance() {
    if ! confirm_uninstall "APARIENCIA COMPLETA" "ZSH, OMZ, P10k, plugins, lsd, bat, fuente"; then
        return 1
    fi
    
    print_info "Desinstalando toda la apariencia..."
    uninstall_zsh_cascade
    uninstall_lsd
    uninstall_bat
    
    if [[ -f "$HOME/.termux/font.ttf" ]]; then
        rm -f "$HOME/.termux/font.ttf"
        termux-reload-settings 2>/dev/null
        print_info "Fuente personalizada eliminada"
    fi
    
    print_success "Apariencia completa desinstalada"
}

uninstall_all_basetools() {
    if ! confirm_uninstall "HERRAMIENTAS BASE (excepto git)" "wget, openssh, fzf, btop/htop"; then
        return 1
    fi
    
    print_info "Desinstalando herramientas base..."
    uninstall_wget
    uninstall_openssh
    uninstall_fzf
    uninstall_btop_htop
    
    print_success "Herramientas base desinstaladas"
}

uninstall_all_multiplexers() {
    if ! confirm_uninstall "MULTIPLEXERS" "tmux"; then
        return 1
    fi

    print_info "Desinstalando multiplexers..."
    uninstall_tmux || return 1

    print_success "Multiplexers desinstalados"
}

uninstall_all_proot() {
    if ! confirm_uninstall "PROOT DISTRO" "Debian, Alpine y proot-distro"; then
        return 1
    fi

    print_info "Desinstalando proot-distro y contenedores..."
    uninstall_proot_distro || return 1

    print_success "PRoot Distro desinstalado"
}

uninstall_all_devenvs() {
    if ! confirm_uninstall "ENTORNOS DEV" "neovim, clang, go, python, nodejs"; then
        return 1
    fi
    
    print_info "Desinstalando entornos de desarrollo..."
    uninstall_neovim
    uninstall_clang
    uninstall_go
    uninstall_python
    uninstall_nodejs
    
    print_success "Entornos de desarrollo desinstalados"
}

uninstall_master_wipe() {
    if ! confirm_uninstall "TODO EL SISTEMA (Master Wipe)" "Todo excepto Git"; then
        return 1
    fi
    
    print_warning "MASTER WIPE - Restaurando sistema limpio"
    print_info "Esto desinstalará TODAS las herramientas..."

    uninstall_all_appearance
    uninstall_all_basetools
    uninstall_all_multiplexers
    uninstall_all_devenvs
    uninstall_all_proot

    print_success "Master Wipe completado - Solo Git permanece"
}

case "$1" in
    uninstall_zsh_cascade) uninstall_zsh_cascade ;;
    uninstall_oh_my_zsh_only) uninstall_oh_my_zsh_only ;;
    uninstall_powerlevel10k) uninstall_powerlevel10k ;;
    uninstall_zsh_plugins) uninstall_zsh_plugins ;;
    uninstall_lsd) uninstall_lsd ;;
    uninstall_bat) uninstall_bat ;;
    uninstall_git) uninstall_git ;;
    uninstall_wget) uninstall_wget ;;
    uninstall_openssh) uninstall_openssh ;;
    uninstall_fzf) uninstall_fzf ;;
    uninstall_btop_htop) uninstall_btop_htop ;;
    uninstall_tmux) uninstall_tmux ;;
    uninstall_dotfiles) uninstall_dotfiles ;;
    uninstall_neovim) uninstall_neovim ;;
    uninstall_clang) uninstall_clang ;;
    uninstall_go) uninstall_go ;;
    uninstall_python) uninstall_python ;;
    uninstall_nodejs) uninstall_nodejs ;;
    uninstall_proot_debian) uninstall_proot_debian ;;
    uninstall_proot_alpine) uninstall_proot_alpine ;;
    uninstall_proot_distro) uninstall_proot_distro ;;
    uninstall_all_appearance) uninstall_all_appearance ;;
    uninstall_all_basetools) uninstall_all_basetools ;;
    uninstall_all_multiplexers) uninstall_all_multiplexers ;;
    uninstall_all_devenvs) uninstall_all_devenvs ;;
    uninstall_all_proot) uninstall_all_proot ;;
    uninstall_master_wipe) uninstall_master_wipe ;;
    *) echo "Uso: $0 <funcion>"; exit 1 ;;
esac
