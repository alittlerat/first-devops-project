#!/bin/bash
# project_setup.sh - Tworzenie struktury projektu


# Domyślne podkatalogi
base_dirs=("src" "tests" "docs" "config")

# Domyślna wartość README
README=false

# Domyślna wartość create_base_dirs
create_base_dirs=false


# Domyślna wartość git_init
git_init=false

# Funkcja do logowania na różnych poziomach
log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    case "$level" in
        INFO)  echo "[$timestamp] [INFO] $message" 
        if [[ -n "$log_file" ]]; then
            echo "[$timestamp] [INFO] $message" >> "$log_file"
        fi
        ;;
        ERROR) echo "[$timestamp] [ERROR] $message" >&2 
        if [[ -n "$log_file" ]]; then
            echo "[$timestamp] [ERROR] $message" >> "$log_file"
        fi
        ;;
        DEBUG) [[ $verbose -eq 1 ]] && echo "[$timestamp] [DEBUG] $message"
        if [[ -n "$log_file" ]]; then
            [[ $verbose -eq 1 ]] && echo "[$timestamp] [DEBUG] $message" >> "$log_file"
        fi
        ;;
    esac
}

# Funkcja do inicjalizacji repozytorium Git
git_init() {
    local project="$1"
    if command -v git &>/dev/null; then
        (
        cd "$project_name" &&
        git init &&
        log INFO "Zainicjalizowano repozytorium Git"
        )
    fi
}

# Funkcja do bezpiecznego tworzenia katalogu
create_dir() {
    local dir="$1"
    if [[ -d "$dir" ]]; then
        log "WARNING" "Katalog $dir już istnieje"
        return 1
    fi
    
    if mkdir -p "$dir"; then
        log INFO "Utworzono katalog $dir"
        return 0
    
    else
        log ERROR "Błąd przy tworzeniu $dir"
        return 1
    fi
 }


# Funkcja do tworzenia podstawowych katalogów
create_base_dirs() {
    shift 1
    for dir in "${base_dirs[@]}"; do
        create_dir "$project_name/$dir"
    done
}

# Analiza parametrów
while [[ $# -gt 0 ]]; do
    case "$1" in
        -o|--output)
            output_file="$2"
            shift 2
            ;;
        -h|--help)
            echo "Użycie: $0 <nazwa_projektu>"
            exit 0
            ;;
        -n|--project-name)
            project_name=$2
            shift 2
            ;;   
        -b|--create_base-dirs)
            create_base_dirs=true
            shift
            ;;
        -r|--create-readme)
            README=true
            shift
            ;;
        -g |--git-init)
            git_init=true
            shift
            ;;
        --log-write)
            if [ -z "$2" ]; then 
                log ERROR "Nie podano pliku logu po --log-write, używam domyślnego"
                log_file="log_project.log"
                shift
            else
                log_file="$2"
                shift 2
            fi                        
            ;;         
        *)
            log ERROR "Nieznany parametr: $1"
            exit 1
            ;;
    esac
done


# Funkcja do tworzenia podstawowego README
create_readme() {
    local project="$1"
    if [[ "$README" == false ]]; then
        log INFO "ℹ️ Pomijanie tworzenia README.md"
        return
    fi
cat > "$project/README.md" << 'EOF'
# 🚀 Pierwszy Projekt DevOps

EOF

log INFO "Utworzono README.md"
}


# Główna logika
log INFRO "🚀 Tworzenie struktury projektu $project_name..."

# Tworzenie głównego katalogu
if ! create_dir "$project_name"; then
    log ERROR "Nie można utworzyć projektu"
    exit 1
fi

# Tworzenie podstawowych katalogów
if [[ "$create_base_dirs" = true ]]; then
    create_base_dirs 
fi

# Tworzenie README
create_readme "$project_name"

# Inicjalizacja Git
if [[ "$git_init" = true ]]; then
    git_init "$project_name"
fi

log INFO "✨ Projekt $project_name został pomyślnie utworzony!"