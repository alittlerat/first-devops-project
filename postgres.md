# Dokumentacja

## 1. Analiza potrzeb

### 1.1 RPO (Recovery Point Objective)
- RPO = **2 godziny**  
  Maksymalna akceptowalna utrata danych to jeden dzień pracy. Dane starsze niż 24 godziny muszą być możliwe do odzyskania z backupów.

### 1.2 RTO (Recovery Time Objective)
- RTO = **30 minut**  
  Czas potrzebny na pełne odtworzenie systemu i przywrócenie działania po awarii nie może przekraczać dwóch godzin.

### 1.3 Krytyczne dane wymagające ochrony
- Dane przechowywane w kluczowych tabelach bazy PostgreSQL, w szczególności:
  - dane użytkowników,
  - dane transakcyjne,
  - dane operacyjne używane przez aplikacje.
- Pliki WAL (Write-Ahead Log), niezbędne do rekonstrukcji stanu bazy między backupami.

### 1.4 Wymagania dot. retencji kopii zapasowych
- Backupy pełne: przechowywane przez **7 dni**.
- Backupy przyrostowe/WAL: przechowywane przez **3 dni**.
- Wszystkie kopie muszą umożliwiać cofnięcie stanu bazy do dowolnego punktu z ostatnich 24h.

---

## 2. Strategia kopii zapasowych

### 2.1 Rodzaje kopii
- **Kopia pełna** (full backup) – kompletny zrzut bazy.
- **Kopie przyrostowe** (incremental) – oparte o WAL archiving.

### 2.2 Częstotliwość wykonywania kopii
- Pełny backup: **raz dziennie (00:00)**.
- Archiwizacja WAL: **ciągła (continuous archiving)** – każdy plik WAL przenoszony do repozytorium.
- Weryfikacja integralności: **raz dziennie po wykonaniu backupu**.

### 2.3 Continuous archiving (WAL archiving)
- Włączone `archive_mode = on`
- `archive_command` kopiuje każdy segment WAL do katalogu archiwizacji.
- Umożliwia odtwarzanie do dowolnego punktu w czasie (PITR).

### 2.4 Procedury weryfikacji kopii
- Sprawdzenie poprawności backupu logicznego (`pg_restore --list`).
- Sprawdzenie integralności kopii fizycznej (checksum katalogu).
- Sprawdzenie kompletności zarchiwizowanych plików WAL.
- Cotygodniowa próba odtworzenia bazy na instancji testowej.

### 2.5 Przechowywanie kopii – lokalizacje
- **On-site**:
  - Backup logiczny `.sql`
  - Archiwum WAL
- **Off-site**:
  - Skopiowane backupy pełne + WAL (np. zewnętrzny dysk, serwer, chmura)
- Wymóg: co najmniej jedna lokalizacja musi być odseparowana od oryginalnego hosta.

---

## 3. Dokumentacja

### 3.1 Pełna dokumentacja strategii kopii zapasowych
Zawiera:
- opis RPO i RTO,
- listę typów kopii i ich harmonogram,
- konfigurację archiwizacji WAL,
- opis przechowywania backupów,
- procedury testowania kopii.

### 3.2 Procedury odtwarzania danych – różne scenariusze

#### 3.2.1 Odtwarzanie z kopii logicznej
1. Utworzyć nową pustą bazę.
2. Zaimportować backup `.sql`.
3. Uwierzytelnić i zweryfikować dane.

#### 3.2.2 Odtwarzanie z kopii fizycznej
1. Zatrzymać instancję PostgreSQL.
2. Zastąpić katalog danych kopią fizyczną.
3. Przywrócić pliki WAL.
4. Uruchomić PostgreSQL w trybie recovery.
5. Zweryfikować integralność.

#### 3.2.3 Odtwarzanie do punktu w czasie (PITR)
1. Przywrócić backup fizyczny.
2. Skopiować wszystkie WAL do katalogu archiwizacji.
3. Utworzyć plik `recovery.conf` (lub parametry `restore_command`).
4. Uruchomić bazę i pozwolić jej się zreplikować do żądanego punktu czasu.

### 3.3 Harmonogram testów strategii backupowej
- Cotygodniowa kontrola integralności backupów.
- Miesięczny test odtworzenia z backupu pełnego.
- Kwartalny test odtworzenia z archiwum WAL (PITR).
- Po każdej większej zmianie systemu – test pełnej ścieżki DR.



## 4. ================== Zadanie praktycznie=========================

### 4.1 Skład klastra
- **Primary** – główny węzeł PostgreSQL przyjmujący zapis.
- **Standby** – węzeł działający jako replika strumieniowa.
- **PgBouncer** – lekka usługa odpowiedzialna za pooling połączeń i kierowanie ruchu.

### 4.2 Replikacja
Zastosowano standardową replikację strumieniową PostgreSQL.
Węzeł standby został skonfigurowany tak, aby automatycznie pobierać i stosować zmiany
z primary. Zmiana roli ze standby na primary została przetestowana w sposób kontrolowany
(przez zatrzymanie kontenera primary i ręczną promocję standby).

### 4.3 Test failover
Przeprowadzono prosty test awarii:
1. Zatrzymano węzeł primary.
2. Standby został ręcznie promowany do roli primary.
3. Połączenia kierowane przez PgBouncer kontynuowały działanie po zmianie roli.

Test pozwolił potwierdzić działanie replikacji oraz możliwość utrzymania ciągłości pracy.

### 4.4 Monitoring
Do monitorowania podstawowych funkcji klastra użyto:
- `pg_isready` – sprawdzanie stanu instancji,
- logów kontenerów Docker,
- prostych testów wykonywania zapytań przez PgBouncer.

### 4.5 Ograniczenia środowiska
Klaster działa na jednym hoście i w środowisku kontenerowym. Z tego powodu jest to
wersja uproszczona, służąca do zrozumienia działania podstawowych mechanizmów HA.
W środowisku produkcyjnym mechanizmy failover i wykrywania awarii powinny być
zautomatyzowane (np. Patroni, repmgr, Consul/etcd).

### 4.6 ---------------------------------------------- Podsumowanie --------------------------------------------------------------
Co zrobiłem praktycznie:
- tworzenia klastra PostgreSQL,
- konfiguracji replikacji strumieniowej,
- przełączania ról węzłów,
- korzystania z PgBouncer,
- analizowania pracy klastra.
