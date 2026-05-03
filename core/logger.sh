#!/usr/bin/env bash

LOG_DIR="$PROJECT_ROOT/logs"
mkdir -p "$LOG_DIR"

log_init() {
    local timestamp=$(date +%Y%m%d_%H%M%S)
    LOG_FILE="$LOG_DIR/install_${timestamp}.log"
    echo "═══════════════════════════════════════════" >> "$LOG_FILE"
    echo "Termux Custom Toolkit - Log de Instalación" >> "$LOG_FILE"
    echo "Fecha: $(date)" >> "$LOG_FILE"
    echo "Sistema: $(detect_os)" >> "$LOG_FILE"
    echo "Usuario: $USER@$(hostname)" >> "$LOG_FILE"
    echo "═══════════════════════════════════════════" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"
    
    print_info "Log iniciado: $LOG_FILE"
}

log_info() {
    local msg="$1"
    echo "[INFO] $(date +%H:%M:%S) - $msg" | tee -a "$LOG_FILE"
}

log_success() {
    local msg="$1"
    echo "[OK] $(date +%H:%M:%S) - $msg" | tee -a "$LOG_FILE"
}

log_warning() {
    local msg="$1"
    echo "[WARN] $(date +%H:%M:%S) - $msg" | tee -a "$LOG_FILE"
}

log_error() {
    local msg="$1"
    echo "[ERROR] $(date +%H:%M:%S) - $msg" | tee -a "$LOG_FILE"
}

log_install() {
    local tool="$1"
    local status="$2"
    local path="$3"
    
    if [[ "$status" == "success" ]]; then
        echo "[INSTALL-OK] $tool -> $path" >> "$LOG_FILE"
    else
        echo "[INSTALL-FAIL] $tool" >> "$LOG_FILE"
    fi
}

log_summary() {
    local total=$1
    local success=$2
    local failed=$3
    
    echo "" >> "$LOG_FILE"
    echo "═══════════════════════════════════════════" >> "$LOG_FILE"
    echo "RESUMEN DE INSTALACIÓN" >> "$LOG_FILE"
    echo "═══════════════════════════════════════════" >> "$LOG_FILE"
    echo "Total de operaciones: $total" >> "$LOG_FILE"
    echo "Exitosas: $success" >> "$LOG_FILE"
    echo "Fallidas: $failed" >> "$LOG_FILE"
    echo "Fecha de finalización: $(date)" >> "$LOG_FILE"
    echo "═══════════════════════════════════════════" >> "$LOG_FILE"
    
    print_header "Resumen de Instalación"
    print_info "Total: $total | Exitosas: $success | Fallidas: $failed"
    print_info "Log: $LOG_FILE"
}

get_latest_log() {
    local latest=$(ls -1t "$LOG_DIR"/*.log 2>/dev/null | head -1)
    if [[ -n "$latest" ]]; then
        echo "$latest"
    else
        echo ""
    fi
}

show_log_content() {
    local log_file=$(get_latest_log)
    
    if [[ -n "$log_file" && -f "$log_file" ]]; then
        print_header "Contenido del Log"
        cat "$log_file"
    else
        print_warning "No hay logs disponibles"
    fi
}