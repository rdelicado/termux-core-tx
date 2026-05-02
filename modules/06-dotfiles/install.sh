#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="${PROJECT_ROOT:-$(cd "$SCRIPT_DIR/../.." && pwd)}"
export PROJECT_ROOT

source "$PROJECT_ROOT/core/utils.sh"

DOTFILES_DIR="$PROJECT_ROOT/dotfiles"

ensure_dotfiles_dir() {
    mkdir -p "$DOTFILES_DIR"
}

get_dotfiles_files() {
    local -n _result=$1
    _result=()

    while IFS= read -r -d '' file; do
        _result+=("$file")
    done < <(find "$DOTFILES_DIR" -mindepth 1 \( -type f -o -type l \) -print0 | sort -z)
}

sync_dotfile() {
    local source_file="$1"
    local relative_path="${source_file#${DOTFILES_DIR}/}"
    local target_file="$HOME/$relative_path"

    mkdir -p "$(dirname "$target_file")"

    if [[ -L "$target_file" || -e "$target_file" ]]; then
        rm -rf "$target_file"
    fi

    ln -s "$source_file" "$target_file"
    print_success "Sincronizado: ~$relative_path"
}

sync_all_dotfiles() {
    local files=()
    get_dotfiles_files files

    if [[ ${#files[@]} -eq 0 ]]; then
        print_warning "No hay archivos en $DOTFILES_DIR"
        return 0
    fi

    local file
    for file in "${files[@]}"; do
        sync_dotfile "$file"
    done
}

show_dotfiles_menu() {
    ensure_dotfiles_dir

    while true; do
        local files=()
        get_dotfiles_files files

        local options=("Sincronizar todo")
        local file

        for file in "${files[@]}"; do
            options+=("${file#"$DOTFILES_DIR/"}")
        done

        options+=("Volver")

        local selected=0
        local key

        tput civis
        trap "tput cnorm; exit" INT TERM

        clear
        banner
        echo -e "  ${COLOR_TITLE}Dotfiles Manager${RESET}\n"
        echo -e "  ${COLOR_MUTED}Origen: $DOTFILES_DIR${RESET}\n"
        tput sc

        while true; do
            tput rc

            for i in "${!options[@]}"; do
                if [[ $i -eq $selected ]]; then
                    echo -e "\e[K  ${COLOR_SELECTED}▸ ${options[$i]}${RESET}"
                else
                    echo -e "\e[K      ${COLOR_UNSELECTED}${options[$i]}${RESET}"
                fi
            done

            echo -e "\e[K"
            echo -e "\e[K  ${COLOR_MUTED}j/k o flechas: navegar  •  enter: seleccionar  •  q: salir${RESET}"

            read -rsn1 key

            case "$key" in
                $'\e')
                    read -rsn2 key
                    case "$key" in
                        '[A') ((selected--)) ;;
                        '[B') ((selected++)) ;;
                    esac
                    ;;
                'k') ((selected--)) ;;
                'j') ((selected++)) ;;
                'q') tput cnorm; return ;;
                "") break ;;
            esac

            if [[ $selected -lt 0 ]]; then
                selected=$((${#options[@]} - 1))
            elif [[ $selected -ge ${#options[@]} ]]; then
                selected=0
            fi
        done

        tput cnorm

        case $selected in
            0) sync_all_dotfiles ;;
            *)
                if [[ $selected -eq $((${#options[@]} - 1)) ]]; then
                    return
                fi

                sync_dotfile "$DOTFILES_DIR/${options[$selected]}"
                ;;
        esac

        echo -e "\n  ${COLOR_MUTED}Presiona ENTER para volver al menú...${RESET}"
        read -r
    done
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    show_dotfiles_menu
fi
