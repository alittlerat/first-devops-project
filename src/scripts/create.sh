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

## 📘 Opis  
Projekt do nauki praktyk **DevOps**.  
Zawiera pliki i skrypty pozwalające na budowę środowiska testowego w Dockerze, instalację podstawowych narzędzi, analizę logów i monitorowanie systemu.  
Służy do nauki automatyzacji, CI/CD oraz podstaw pracy z narzędziami GitOps.

---

## 📂 Struktura projektu

| Katalog / Plik | Opis |
|----------------|------|
| **Dockerfile** | Obraz Ubuntu 22.04 z zainstalowanymi narzędziami (curl, git, jq, itp.) |
| **src/scripts/install-tools.sh** | Skrypt instalacyjny – instaluje wymagane narzędzia lokalnie lub w kontenerze |
| **src/scripts/create.sh** | Skrypt Bash do tworzenia struktury projektu (z opcjonalnym README i katalogami) |
| **src/scripts/doc-summary.sh** | Skrypt analizujący logi, generujący raport błędów w formacie CSV |
| **src/scripts/bg-monitor.sh** | Skrypt monitorujący zasoby systemowe (CPU, RAM, dysk) z obsługą progów i logowaniem |
| **src/logs/bg-monitor.log** | Plik logów generowany przez `bg-monitor.sh` |
| **tests/check_tools.sh** | Skrypt testowy – weryfikuje poprawność instalacji narzędzi |
| **tests/test.log** | Przykładowy plik logów do testowania `doc-summary.sh` |
| **src/report.csv** | Przykładowy raport błędów wygenerowany przez `doc-summary.sh` |
| **docs/** | Dokumentacja projektu – opis Dockerfile, skryptów i workflow GitHub Actions |
| **.github/workflows/main.yml** | Workflow CI/CD budujący obraz Dockera i uruchamiający testy |

---

## 🧰 Skrypty w katalogu `src/scripts/`

### 1. `create.sh` — generator struktury projektu  
Tworzy nowy projekt z podstawową strukturą katalogów (`src`, `tests`, `docs`, `config`) oraz opcjonalnym plikiem `README.md`.

**Użycie:**  
`./src/scripts/create.sh [opcje] <nazwa_projektu> [podfoldery...]`

**Opcje:**  
`-r` — pomija tworzenie pliku README.md  
`-b` — tworzy podstawowe katalogi (src, tests, docs, config)  
`-g` — inicjalizuje repozytorium Git  
`--log <plik>` — zapisuje logi do wskazanego pliku  
`-h` — wyświetla pomoc  

**Przykład:**  
`./src/scripts/create.sh -r devops-lab scripts logs`

---

### 2. `doc-summary.sh` — analiza logów  
Analizuje błędy w pliku logu, zlicza ich ilość, pokazuje 10 najczęstszych i generuje raport CSV.

**Użycie:**  
`./src/scripts/doc-summary.sh <plik_logu> [plik_wyjściowy.csv]`

**Przykłady:**  
`./src/scripts/doc-summary.sh tests/test.log`  
`./src/scripts/doc-summary.sh /var/log/syslog custom_report.csv`

**Wynik działania:**  
- Liczba wszystkich błędów  
- 10 najczęstszych błędów  
- Plik `report.csv` z wynikami  

---

### 3. `bg-monitor.sh` — monitorowanie zasobów systemu  
Monitoruje stan CPU, RAM i dysków, porównując je z progami krytycznymi.  
Wyniki zapisuje do logu `src/logs/bg-monitor.log` i obsługuje błędy argumentów.

**Użycie:**  
`./src/scripts/bg-monitor.sh [opcje]`

**Opcje:**  
`-d`, `--disk-usage <procent>` — sprawdza zużycie dysku  
`-c`, `--cpu-usage <procent>` — sprawdza użycie procesora  
`-m`, `--mem-usage <procent>` — sprawdza zużycie pamięci RAM  
`--log-write <plik>` — zapis logów do niestandardowego pliku  
`-h`, `--help` — wyświetla pomoc  

**Przykład:**  
`./src/scripts/bg-monitor.sh -d 80 -c 85 -m 90 --log-write custom_monitor.log`

---

### 4. `install-tools.sh` — instalacja narzędzi  
Instaluje pakiety niezbędne do pracy w środowisku DevOps.

**Instalowane narzędzia:**  
git, curl, wget, unzip, htop, tree, jq  

**Użycie:**  
`bash src/scripts/install-tools.sh`

---

## 🧪 Uruchomienie projektu

**W Dockerze:**  
`docker build -t devops-lab .`  
`docker run -it devops-lab bash`

**Wewnątrz kontenera:**  
`bash src/check_tools.sh`

**Lokalnie:**  
`bash src/scripts/install-tools.sh`  
`bash src/scripts/check_tools.sh`

---

## ⚙️ GitHub Actions  
Workflow CI/CD (`.github/workflows/main.yml`) automatycznie:  
- Buduje obraz Dockera  
- Uruchamia `src/check_tools.sh`  
- Weryfikuje poprawność instalacji narzędzi  

---

## 🧩 Pliki przykładowe

| Plik | Opis |
|------|------|
| `tests/test.log` | Przykładowy log do testowania `doc-summary.sh` |
| `src/logs/bg-monitor.log` | Przykładowy log z monitorowania systemu |
| `src/report.csv` | Raport błędów z `doc-summary.sh` |

---

## 👨‍💻 Autor  
GitHub: [alittlerat](https://github.com/alittlerat)  
Data ostatniej edycji: **07.11.2025**



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