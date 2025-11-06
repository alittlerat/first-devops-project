# bg-monitor.sh

Skrypt monitorujący zasoby systemowe (dysk, pamięć RAM, CPU) i zapisujący wyniki do logu.

## Funkcje:
- Monitoruje **zużycie CPU, RAM oraz dysku**
- Działa w trybie manualnym (pojedyncze wywołanie)
- Loguje zdarzenia do pliku (domyślnie `system_monitor.log`)
- Wypisuje komunikaty w formacie `[data] [LEVEL] wiadomość`

## Działanie:
Dla każdego parametru (CPU, RAM, dysk) sprawdza aktualne zużycie i porównuje z wartością progową.
Wynik zapisuje do logu z poziomem `INFO` lub `WARN`.

## Użycie:
```bash
./src/scripts/bg-monitor.sh [opcje]
```

## Opcje:
| Flaga | Opis |
|-------|------|
| `-d`, `--disk-usage <procent>` | Sprawdza zużycie dysku i porównuje z progiem |
| `-c`, `--cpu-usage <procent>` | Sprawdza użycie procesora |
| `-m`, `--mem-usage <procent>` | Sprawdza zużycie pamięci RAM |
| `--log-write <plik>` | Zapis logów do wskazanego pliku |
| brak flag | Domyślnie nic nie wykonuje – należy podać parametr |

## Przykład:
```bash
./src/scripts/bg-monitor.sh -d 70 -c 80 -m 75 --log-write bg_monitor.log
```

## Wynik:
Plik logu z wpisami w stylu:
```
[2025-11-06 19:53:04] [INFO] Zużycie RAM: 20% (próg: 25%)
[2025-11-06 19:53:04] [WARN] Przekroczony próg CPU: 90% > 80%
```
