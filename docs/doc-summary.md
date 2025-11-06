# doc-summary.sh

Skrypt analizujący logi, zliczający błędy i generujący raport CSV.

## Funkcje:
- Analizuje plik logów pod kątem błędów (`ERROR`, `WARN`)
- Zlicza wystąpienia i wyświetla 10 najczęstszych komunikatów
- Generuje raport CSV z wynikami
- Wypisuje krótkie podsumowanie w terminalu

## Użycie:
```bash
./src/scripts/doc-summary.sh <plik_logu> [plik_wyjściowy.csv]
```

## Przykłady:
```bash
# Analiza testowego pliku logów
./src/scripts/doc-summary.sh tests/test.log

# Analiza systemowego logu z własnym raportem
./src/scripts/doc-summary.sh /var/log/syslog raport.csv
```

## Wynik:
- Raport CSV z błędami (`report.csv` lub własna nazwa)
- W terminalu:
```
Liczba błędów: 42
Top 10 błędów:
1. Connection refused - 10x
2. Timeout reached - 8x
...
```
