set -e

echo "Checking installed tools versions..."

echo "git version:"
git --version

echo "curl version:"
curl --version | head -n 1

echo "wget version:"
wget --version | head -n 1

echo "unzip version:"
unzip --version 2>&1 | head -n 1 || true

echo "htop version:"
htop --version

echo "tree version:"
tree --version

echo "jq version:"
jq --version

echo "All tools checked successfully!"
