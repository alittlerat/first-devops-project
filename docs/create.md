# create.sh

Generator struktury projektu — automatycznie tworzy katalogi, plik README.md i inicjalizuje repozytorium Git.

## Funkcje:
- Tworzy podstawową strukturę katalogów (`src`, `tests`, `docs`, `config`)
- Opcjonalnie tworzy plik `README.md`
- Może zainicjalizować repozytorium Git
- Zapisuje logi do pliku (jeśli podano opcję)

## Użycie:
```bash
./src/scripts/create.sh [opcje]
```

## Opcje:
| Flaga | Opis |
|-------|------|
| `-n`, `--project-name <nazwa>` | Nazwa projektu (obowiązkowa) |
| `-b`, `--create_base-dirs` | Tworzy katalogi podstawowe |
| `-r`, `--create-readme` | Tworzy plik README.md |
| `-g`, `--git-init` | Inicjalizuje repozytorium Git |
| `--log-write <plik>` | Zapisuje logi do wskazanego pliku |
| `-h`, `--help` | Wyświetla pomoc |

## Przykłady:
```bash
# Tworzy projekt DevOps z katalogami i README
./src/scripts/create.sh -n devops-lab -b -r

# Tworzy tylko strukturę katalogów bez README
./src/scripts/create.sh -n demo -b

# Tworzy projekt z logowaniem i Git
./src/scripts/create.sh -n myapp -b -r -g --log-write setup.log
```

## Wynik:
```
[INFO] Utworzono katalog devops-lab
[INFO] Utworzono README.md
[INFO] Zainicjalizowano repozytorium Git
```
