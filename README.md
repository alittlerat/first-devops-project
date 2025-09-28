# Pierwszy Projekt DevOps

## Opis
Projekt do nauki praktyk DevOps. Zawiera Dockerfile, skrypt instalacyjny oraz testy sprawdzające poprawność instalacji podstawowych narzędzi.

## Struktura projektu
- `Dockerfile` – obraz Ubuntu 22.04 z podstawowymi narzędziami 
- `/src` – kod źródłowy, np. skrypt instalacyjny `instal-tools.sh` 
- `/tests` – testy, np. `check_tools.sh` 
- `/docs` – dokumentacja projektu, zawiera opis Dockerfile, skryptów instalacyjnych, testów oraz workflow GitHub Actions
## Uruchomienie
Projekt można uruchomić lokalnie poprzez budowanie obrazu Docker i uruchomienie kontenera. W kontenerze można sprawdzić wersje wszystkich narzędzi przy użyciu `check_tools.sh`.
Narzędzia można też zainstalować lokalnie na hoście korzystając ze skryptu `instal-tools.sh`.

## GitHub Actions
Workflow automatycznie buduje obraz Docker i uruchamia `check_tools.sh`, aby zweryfikować zainstalowane narzędzia.

## Autor
- GitHub: alittlerat

