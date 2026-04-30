#!/usr/bin/env bash

BACKUP_DIR="$PROJECT_ROOT/backups"
mkdir -p "$BACKUP_DIR"

backup_file() {
    local file=$1
    local filename=$(basename "$file")
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_path="$BACKUP_DIR/${filename}.bak_${timestamp}"
    
    if [[ -f "$file" ]]; then
        cp "$file" "$backup_path"
        print_success "Backup creado: $backup_path"
        return 0
    else
        print_warning "Archivo no existe: $file"
        return 1
    fi
}

backup_zshrc() {
    local zshrc="$HOME/.zshrc"
    backup_file "$zshrc"
}

restore_backup() {
    local filename=${1:-".zshrc"}
    local search_pattern="$BACKUP_DIR/${filename}.bak_"*
    
    local backups=($search_pattern)
    
    if [[ ${#backups[@]} -eq 0 ]]; then
        print_warning "No hay backups de $filename"
        return 1
    fi
    
    echo -e "${CYAN}Backups disponibles:${NC}"
    local i=1
    for backup in "${backups[@]}"; do
        echo -e "${GREEN}$i)${NC} $(basename "$backup")"
        ((i++))
    done
    
    echo ""
    read -p "Selecciona backup a restaurar [0 para cancelar]: " choice
    
    if [[ "$choice" -eq 0 ]] || [[ -z "$choice" ]]; then
        return 0
    fi
    
    local selected=$((choice - 1))
    if [[ "$selected" -ge 0 ]] && [[ "$selected" -lt ${#backups[@]} ]]; then
        local target="$HOME/$filename"
        cp "${backups[$selected]}" "$target"
        print_success "Restaurado: $filename"
    else
        print_error "Selección inválida"
    fi
}

list_backups() {
    print_header "Backups Disponibles"
    
    if [[ -n "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]]; then
        ls -1hr "$BACKUP_DIR"
    else
        print_warning "No hay backups"
    fi
}