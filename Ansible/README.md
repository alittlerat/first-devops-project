# Projekt Automatyzacji MySQL z Ansible

Ten projekt wdraża serwer MySQL na jednej maszynie oraz klienta MySQL na drugiej.

## Struktura
Projekt wykorzystuje najlepsze praktyki Ansible:
- **Role**: Oddzielne role dla serwera i klienta.
- **Environment**: Obsługa dev/prod poprzez `group_vars`.
- **Error Handling**: Użycie `block/rescue` w konfiguracji DB.

## Wymagania
1. Zainstalowany Ansible.
2. Dostęp SSH do maszyn docelowych.
3. Kolekcja `community.mysql` (zainstaluj przez: `ansible-galaxy collection install community.mysql`).

## Uruchomienie

Pełne wdrożenie na środowisko DEV:
`ansible-playbook -i inventory/hosts site.yml`

Tylko konfiguracja bazy danych (z pominięciem instalacji pakietów):
`ansible-playbook -i inventory/hosts site.yml --tags "database"`

Tylko wdrożenie klienta:
`ansible-playbook -i inventory/hosts site.yml --limit db_clients`
