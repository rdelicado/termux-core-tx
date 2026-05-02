#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="${PROJECT_ROOT:-$(cd "$SCRIPT_DIR/.." && pwd)}"
export PROJECT_ROOT

source "$PROJECT_ROOT/core/utils.sh"
source "$PROJECT_ROOT/core/menu.sh"

update_core_tx() {
    execute_action "cd \"$PROJECT_ROOT\" && git pull origin main" "Update CORE-TX"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    update_core_tx
fi
