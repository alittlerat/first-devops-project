# Dockerfile

Dockerfile tworzy obraz Ubuntu 22.04 z podstawowymi narzędziami używanymi w projekcie.

## Kroki:
1. `FROM ubuntu:22.04` – bazowy obraz Ubuntu.
2. `RUN apt update && apt upgrade -y && apt install -y ...` – aktualizacja systemu i instalacja narzędzi: git, curl, wget, unzip, htop, tree, jq.
3. `WORKDIR /first-devops-project` – ustawia katalog roboczy w kontenerze.
4. `COPY . /first-devops-project` – kopiuje wszystkie pliki projektu do kontenera.
5. `CMD ["bash"]` – domyślne polecenie przy uruchomieniu kontenera.
