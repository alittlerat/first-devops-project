#  Projekt Automatyzacji MySQL z Ansible

Ten projekt wdraża kompletną infrastrukturę bazodanową:
1.  **Serwer MySQL** na maszynach z grupy `db_servers`.
2.  **Klient MySQL** na maszynach z grupy `db_clients`.

Całe wdrożenie wykorzystuje **klucze SSH** do uwierzytelniania, co jest zgodne z najlepszymi praktykami bezpieczeństwa.

---

## Struktura i Najważniejsze Elementy

Projekt jest zorganizowany zgodnie z najlepszymi praktykami Ansible:

* **`site.yml`**: Główny Playbook orkiestrujący całe wdrożenie.
* **`roles/`**: Zawiera role `mysql_server` i `mysql_client` (modularyzacja zadań).
* **`group_vars/`**: Zawiera zmienne środowiskowe:
    * `all.yml`: Zmienne globalne (np. `ansible_ssh_user`, nazwy pakietów).
    * `dev.yml` / `prod.yml`: Zmienne specyficzne dla środowiska (np. nazwy baz danych, hasła aplikacji).
* **`inventory/hosts`**: Definicja hostów docelowych (`db_servers`, `db_clients`).

## Wymagania i Konfiguracja

### Wymagania Wstępne
1.  **Ansible**: Zainstalowany lokalnie.
2.  **SSH Key**: Klucz publiczny **`~/.ssh/id_ed25519.pub`** wygenerowany na lokalnej maszynie.
3.  **Kolekcja**: Wymagana kolekcja MySQL do zarządzania bazami danych:
    ```bash
    ansible-galaxy collection install community.mysql
    ```

### Uwierzytelnianie
Połączenie SSH jest realizowane za pomocą **kluczy**. W Playbooku zaimplementowano zadanie, które automatycznie dystrybuuje klucz publiczny na maszyny docelowe.

### Pierwsze Uruchomienie (Wymagane Hasło SUDO)

Aby wdrożyć klucz SSH, musisz podać **hasło SUDO** dla użytkownika zdalnego (`test`):

```bash
ansible-playbook -i inventory/hosts site.yml --ask-become-pass
