# 🚀 Pierwszy Projekt DevOps

## 📘 Opis

Projekt do nauki praktyk **DevOps**.
Zawiera pliki i skrypty pozwalające na budowę środowiska testowego w Dockerze, instalację podstawowych narzędzi oraz analizę logów.
Służy do nauki automatyzacji, CI/CD oraz podstaw pracy z narzędziami w stylu GitOps.

---

## 📂 Struktura projektu

| Katalog / Plik         | Opis                                                                                    |
| ---------------------- | --------------------------------------------------------------------------------------- |
| `Dockerfile`           | Obraz **Ubuntu 22.04** z zainstalowanymi podstawowymi narzędziami (curl, git, jq, itp.) |
| `src/scripts/install-tools.sh` | Skrypt instalacyjny – instaluje wymagane narzędzia lokalnie lub w kontenerze            |
| `tests/check_tools.sh` | Skrypt testowy – weryfikuje poprawność instalacji narzędzi                              |
| `src/scripts/create.sh`        | Skrypt Bash do tworzenia struktury projektu (z opcjonalnym README i katalogami)         |
| `src/doc-summary.sh`   | Skrypt Bash analizujący logi, generujący raport błędów w formacie CSV                   |
| `tests/`               | Zawiera testy i przykładowe pliki logów (np. `test.log`)                                |
| `docs/`                | Dokumentacja projektu – opis Dockerfile, skryptów i workflow GitHub Actions             |
| `src/report.csv`           | Przykładowy raport wygenerowany przez `doc-summary.sh`                                  |

---

## 🧰 Skrypty w katalogu `src/`

### 1. `create.sh` — generator struktury projektu

Tworzy nowy projekt z podstawową strukturą katalogów i opcjonalnym plikiem README.

**Użycie:**

```bash
./scripts/create.sh [opcje] <nazwa_projektu> [podfoldery...]
```

**Opcje:**

* `-r` — pomija tworzenie pliku README.md

**Przykład:**

```bash
./scripts/create.sh myapp src config docs
./scripts/create.sh -r devops-lab scripts logs
```

---

### 2. `doc-summary.sh` — analiza logów

Analizuje błędy w pliku logu, zlicza ich ilość, pokazuje 10 najczęstszych i generuje raport CSV.

**Użycie:**

```bash
./scripts/doc-summary.sh <plik_logu> [plik_wyjściowy.csv]
```

**Przykłady:**

```bash
# Analiza przykładowego logu
./scripts/doc-summary.sh tests/test.log

# Analiza własnego logu systemowego i zapis do custom_report.csv
./scripts/doc-summary.sh /var/log/syslog custom_report.csv
```

**Wynik działania:**

* Liczba wszystkich błędów
* 10 najczęstszych błędów
* Plik `report.csv` z wynikami


## 🧪 Uruchomienie projektu

Można uruchomić lokalnie lub w Dockerze:

```bash
# Budowanie obrazu
docker build -t devops-lab .

# Uruchomienie kontenera interaktywnego
docker run -it devops-lab bash

# Wewnątrz kontenera
bash src/check_tools.sh
```

Możesz też uruchomić skrypty lokalnie:

```bash
bash src/install-tools.sh
bash src/check_tools.sh
```

---

## ⚙️ GitHub Actions

Workflow CI/CD (plik `.github/workflows/main.yml`) automatycznie:

* Buduje obraz Dockera,
* Uruchamia `src/check_tools.sh`,
* Weryfikuje, czy narzędzia zostały poprawnie zainstalowane.

=========================================================================================================================

## 🧩 Pliki przykładowe

| Plik             | Opis                                                                                            |
| ---------------- | ----------------------------------------------------------------------------------------------- |
| `tests/test.log` | Przykładowy plik logów do testowania `doc-summary.sh`. Można użyć własnych logów aplikacyjnych. |
| `report.csv`     | Przykładowy raport wygenerowany z `test.log`.                                                   |

---

## 👨‍💻 Autor

**GitHub:** [alittlerat](https://github.com/alittlerat)
**Data ostatniej edycji:** 06.11.2025

