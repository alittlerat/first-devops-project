# Dokumentacja strategii kopii zapasowych i wysokiej dostępności PostgreSQL

## 1. Analiza potrzeb

### 1.1 RPO (Recovery Point Objective)
- RPO = **2 godziny**
- Maksymalna akceptowalna utrata danych to 2 godziny. System musi umożliwiać odtworzenie danych wstecz do tego punktu.

### 1.2 RTO (Recovery Time Objective)
- RTO = **30 minut**
- Odtworzenie systemu po awarii nie może przekroczyć 30 minut.

### 1.3 Krytyczne dane
- Tabele operacyjne systemu PostgreSQL:
  - dane użytkowników,
  - dane transakcyjne,
  - dane aplikacyjne.
- Pliki WAL niezbędne do odbudowy danych pomiędzy backupami.

### 1.4 Retencja kopii zapasowych
- Backupy pełne – 7 dni.
- WAL / kopie przyrostowe – 3 dni.
- System ma umożliwiać PITR z ostatnich 24 godzin.

---

## 2. Strategia kopii zapasowych

### 2.1 Rodzaje kopii
- **Pełny backup fizyczny** (`pg_basebackup`) – kopia całego katalogu danych.
- **Kopie przyrostowe** – continuous archiving (WAL archiving).

### 2.2 Częstotliwość
- Backup pełny – codziennie o 00:00.
- Archiwizacja WAL – ciągła.
- Codzienna weryfikacja integralności backupów.

### 2.3 Continuous archiving (WAL archiving)

**Włączone w konfiguracji PostgreSQL:**
 - wal_level = replica
 - archive_mode = on
 - archive_command = 'cp %p /backup/wal/%f'
 - max_wal_senders = 10
 - wal_keep_size = 256MB

**Każdy utworzony plik WAL jest kopiowany do katalogu:**
  - `/backup/wal/`

**Zarchiwizowane WAL-e umożliwiają:**
 - odtwarzanie przyrostowe,
 - odtwarzanie do punktu w czasie (PITR),
 - utrzymanie repliki strumieniowej.

### 2.4 Weryfikacja kopii
- `pg_restore --list` dla backupów logicznych.
- Sumy kontrolne katalogu backupu fizycznego.
- Sprawdzenie kompletności archiwum WAL.
- Cotygodniowy test odtworzenia na instancji testowej.

### 2.5 Przechowywanie kopii

**On-site:**
- Backup pełny (pg_basebackup) → `/backup/full/`
- Archiwum WAL → `/backup/wal/`

**Off-site:**
- Kopia pełnego backupu + WAL (np. serwer NAS, chmura, zewnętrzny serwer SSH)

Wymóg: co najmniej jedna lokalizacja musi być odseparowana od głównego hosta.

---

## 3. Procedury odtwarzania

### 3.1 Dokumentacja strategii
Obejmuje:
- RPO, RTO,
- harmonogram kopii,
- konfigurację archiwizacji WAL,
- procedury testowe,
- procedury DR.

### 3.2 Odtwarzanie w zależności od scenariusza

#### 3.2.1 Odtwarzanie z kopii logicznej
1. Utworzyć pustą bazę.
2. Wykonać import pliku `.sql`.
3. Zweryfikować dane.

#### 3.2.2 Odtwarzanie z pełnej kopii fizycznej
1. Zatrzymać PostgreSQL.
2. Zastąpić katalog danych kopią fizyczną (np. z pg_basebackup).
3. Przywrócić WAL-e.
4. Uruchomić w trybie recovery.
5. Sprawdzić integralność.

#### 3.2.3 PITR – odtwarzanie do punktu w czasie
1. Przywrócić pełny backup fizyczny.
2. Upewnić się, że katalog `/backup/wal/` zawiera wszystkie WAL-e.
3. Utworzyć plik `recovery.signal`.
4. W `postgresql.auto.conf` dodać:




