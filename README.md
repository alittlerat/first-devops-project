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



