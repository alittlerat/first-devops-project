# GitHub Actions Workflow

Workflow automatycznie buduje obraz Docker i uruchamia testy w kontenerze.

## Kroki workflow:
1. Checkout repozytorium.
2. Build Docker image z Dockerfile.
3. Uruchomienie `check_tools.sh` w kontenerze.
4. Wypisanie wersji narzędzi w logach GitHub Actions.

## Cel:
- Automatyczne sprawdzenie, że wszystkie narzędzia są poprawnie zainstalowane.
- Workflow działa przy każdym pushu lub pull request na gałąź `main`.
