# Rola: mysql_client

Ta rola instaluje klienta wiersza poleceń MySQL na maszynach, które będą łączyć się z serwerem baz danych.

## Zmienne (Zarządzane przez group_vars)

Rola wykorzystuje następujące zmienne zdefiniowane w pliku `group_vars/all.yml`:

| Zmienna | Opis | Gdzie używana |
| :--- | :--- | :--- |
| `client_package_name` | Nazwa pakietu klienta MySQL (np. `mysql-client`). | tasks/main.yml |

## Test Weryfikacyjny

Ostatnie zadanie w tej roli uruchamia test weryfikacyjny, aby potwierdzić, że klient został poprawnie zainstalowany i działa:
```bash
mysql --version
