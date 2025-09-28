# instal-tools.sh

Skrypt do instalacji narzędzi na systemie lokalnym.

## Co robi:
1. Aktualizuje system: `sudo apt update && sudo apt upgrade -y`
2. Instaluje narzędzia: git, curl, wget, unzip, htop, tree, jq
3. Instaluje Dockera: pobiera skrypt z get.docker.com i go uruchamia
4. Dodaje użytkownika do grupy docker: `sudo usermod -aG docker $USER`
5. Sprawdza poprawność instalacji Dockera i uruchamia testowy kontener `hello-world`
