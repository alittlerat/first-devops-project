#!/bin/bash
# service_manager.sh - Zarządzanie procesami w tle

# Domyślne progi
PU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80
LOG_FILE="system_monitor.log"

# Funkcja logująca

log() {
    local level="$1"
    local message="$2"
    local timestamp
    timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] [$level] $message" | tee -a "$LOG_FILE"
}

# Funkcja monitorująca dysk
disk_usage() {
    local threshold="$1"
    local disk_info
    disk_info=$(df -h / | awk 'NR==2 {print $5}')
    local used_percent=${disk_info%\%}

    log "INFO" "Zużycie dysku: ${used_percent}% (próg: ${threshold}%)"

    if (( used_percent > threshold )); then
        log "WARN" "Przekroczony próg dysku: ${used_percent}% > ${threshold}%"
    else
        log "INFO" "Dysk OK"
    fi
}


# Funkcja monitorująca CPU
cpu_usage() {
    local threshold="$1"
    local usage
    usage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
    local usage_int=${usage%.*}

    log "INFO" "Zużycie CPU: ${usage_int}% (próg: ${threshold}%)"

    if (( usage_int > threshold )); then
        log "WARN" "Przekroczony próg CPU: ${usage_int}% > ${threshold}%"
    else
        log "INFO" "CPU OK"
    fi
}


# Funkcja monitorująca pamięć RAM
mem_usage() {
    local threshold="$1"
    local usage
    usage=$(free | awk '/Mem:/ {print $3/$2 * 100.0}')
    local usage_int=${usage%.*}

    log "INFO" "Zużycie RAM: ${usage_int}% (próg: ${threshold}%)"

    if (( usage_int > threshold )); then
        log "WARN" "Przekroczony próg RAM: ${usage_int}% > ${threshold}%"
    else
        log "INFO" "RAM OK"
    fi
}


while [[ $# -gt 0 ]]; do
    case "$1" in
        -d|--disk-usage)
            DISK_THRESHOLD="$2"
            disk_usage "$DISK_THRESHOLD"
            shift 2
            ;;
        -c|--cpu-usage)
            CPU_THRESHOLD="$2"
            cpu_usage "$CPU_THRESHOLD"
            shift 2
            ;;
        -m|--mem-usage)
            MEM_THRESHOLD="$2"
            mem_usage "$MEM_LIMIT"
            shift 2
            ;;
        --log-write)
            if [[ -z "$2" ]]; then
                log "WARN" "Nie podano pliku logu po --log-write, używam domyślnego: $LOG_FILE"
                shift
            else
                LOG_FILE="$2"
                log "INFO" "Zapis logów do: $LOG_FILE"
                shift 2
            fi
            ;;
        *)
            log "ERROR" "Nieznany parametr: $1"
            usage
            ;;
    esac
done
