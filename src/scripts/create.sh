#!/bin/bash
# project_setup.sh - Tworzenie struktury projektu

README=true

while getopts "r" opt; do
    case $opt in
        r) # jestli podano -r to tworzymy dodatkowe katalogi
           README=false
           ;;
        \?) # nieznana opcja
           echo "Nieznana opcja: -$OPTARG" >&2
           exit 1
           ;;  
    esac
done

shift $((OPTIND -1))

# Sprawdzamy, czy podano nazwę projektu

if [[ $# -eq 0 ]]; then
    echo "Użycie: $0 <nazwa_projektu>"
    exit 1
fi


project_name="$1"

#base_dirs=("src" "tests" "docs" "config")


# Tworzenie podanych przez użytkownika podkatalogów

create_base_dirs() {
    shift 1
    for dir in "$@"; do
        create_dir "$project_name/$dir"
    done
}

# Funkcja do bezpiecznego tworzenia katalogu
create_dir() {

local dir="$1"

    if [[ -d "$dir" ]]; then
        echo "⚠ Katalog $dir już istnieje"
        return 1
    fi

    if mkdir -p "$dir"; then
        echo "✅ Utworzono katalog $dir"
        return 0
    else

echo "❌ Błąd przy tworzeniu $dir"

return 1
fi
}
# Funkcja do tworzenia podstawowego README
create_readme() {
    local project="$1"
    if [[ "$README" == false ]]; then
        echo "ℹ️ Pomijanie tworzenia README.md"
        return
    fi
cat > "$project/README.md" << EOF
# $project
## O projekcie
Opis projektu
## Struktura
$(for dir in "${base_dirs[@]}"; do echo "- \`$dir/\`"; done)
## Instalacja
\`\`\`bash
git clone ...
cd $project
\`\`\`
EOF
echo "✅ Utworzono README.md"
}


# Główna logika
echo "🚀 Tworzenie struktury projektu $project_name..."

# Tworzenie głównego katalogu
if ! create_dir "$project_name"; then
    echo "❌ Nie można utworzyć projektu"
    exit 1
fi


for dir in "${base_dirs[@]}"; do
    create_dir "$project_name/$dir"
done


# Tworzenie README
create_readme "$project_name"

# Inicjalizacja git
if command -v git &>/dev/null; then
    (
    cd "$project_name" &&
    git init &&
    echo "✅ Zainicjalizowano repozytorium Git"
    )
fi

create_base_dirs $@
echo "✨ Projekt $project_name został pomyślnie utworzony!"