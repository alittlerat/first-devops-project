set -e

echo "=== Aktualizacja systemu ==="
sudo apt update && sudo apt upgrade -y

echo "=== Instalacja narzędzi ==="
sudo apt install -y \
    git \
    curl \
    wget \
    unzip \
    htop \
    tree \
    jq

echo "=== Instalacja Dockera ==="
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

echo "=== Dodawanie użytkownika do grupy docker ==="
sudo usermod -aG docker $USER

echo "--- Docker ---"
docker --version
docker run --rm hello-world



