#!/bin/bash
if [[ $# -lt 1 ]]; then
    echo "Użycie: $0 <plik_logu> [plik_wyjściowy.csv]"
    exit 1
fi

log_file="$1"
output_file="${2:-report.csv}"  # jeśli nie podano — domyślnie report.csv

if [[ ! -f "$log_file" ]]; then
    echo "❌ Plik $log_file nie istnieje!"
    exit 1
fi

#Główna analiza
echo "🔍 Analiza pliku logu: $log_file"

error_lines=$(grep -i "error" "$log_file")

# Zliczamy wszystkie błędy
error_count=$(echo "$error_lines" | wc -l)
echo "📊 Łączna liczba błędów: $error_count"

# Top 10 najczęstszych błędów 
echo
echo "🔥 10 najczęstszych błędów:"
top_errors=$(echo "$error_lines" \
    | sed -E 's/.*[Ee]rror[: -]*//' \
    | sort \
    | uniq -c \
    | sort -rn \
    | head -10)

echo "$top_errors"

# --- Tworzenie raportu CSV ---
echo "🧾 Tworzenie raportu CSV: $output_file"
{
    echo "Błąd,Ilość"
    echo "$top_errors" | awk '{count=$1; $1=""; sub(/^ /,""); print "\"" $0 "\"," count}'
} > "$output_file"

echo "✅ Raport zapisany w pliku: $output_file"