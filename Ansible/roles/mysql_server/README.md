# Rola: mysql_server

Ta rola instaluje, konfiguruje i uruchamia serwer MySQL. Jest również odpowiedzialna za wstępną konfigurację bazy danych i użytkowników aplikacji.

## Zmienne (Zarządzane przez group_vars)

Kluczowe zmienne konfiguracyjne, które powinny być ustawione w `group_vars/all.yml` lub `group_vars/dev.yml/prod.yml`:

| Zmienna | Opis | Gdzie używana |
| :--- | :--- | :--- |
| `mysql_package_name` | Nazwa pakietu MySQL Server (np. `mysql-server`). | tasks/main.yml |
| `mysql_bind_address` | Adres IP, na którym serwer ma nasłuchiwać (np. `0.0.0.0` dla nasłuchiwania zewnętrznego). | templates/my.cnf.j2 |
| `app_db_name` | Nazwa bazy danych dla aplikacji. | tasks/main.yml |
| `app_db_user` | Nazwa użytkownika aplikacji. | tasks/main.yml |
| `app_db_pass` | Hasło użytkownika aplikacji. | tasks/main.yml |

## Tagi

* `install`: Instalacja pakietów systemowych.
* `config`: Konfiguracja pliku `my.cnf`.
* `database`: Tworzenie bazy danych i użytkownika (blok `block/rescue`).
