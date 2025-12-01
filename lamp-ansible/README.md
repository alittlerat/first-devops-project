# LAMP Ansible – Automatyczne wdrożenie Apache + MySQL + PHP + aplikacja demo

Ten projekt pozwala automatycznie postawić środowisko LAMP na Ubuntu/Debian przy pomocy Ansible.

## 🚀 Jak uruchomić?

1. Zainstaluj Ansible
2. Odpal:
3. Sprawdź stronę:
- http://localhost/ansible_demo  
- lub: cat /var/www/html/ansible_demo/index.php

---

## 📦 Opis ról

### **base**
Instaluje podstawowe pakiety systemowe.  
Modyfikacja: `roles/base/defaults/main.yaml`

### **web**
Instaluje i konfiguruje Apache2.  
Modyfikacja: `roles/web/defaults/main.yaml`

### **database**
Instaluje MariaDB, tworzy bazę i użytkownika.  
Modyfikacja: `roles/database/defaults/main.yaml`

### **php**
Instaluje PHP + moduły.  
Modyfikacja: `roles/php/defaults/main.yaml`

### **app**
Tworzy katalog i wrzuca aplikację PHP łączącą się z bazą.  
Modyfikacja: `roles/app/templates/index.php.j2` i `defaults/main.yaml`

