#!/bin/bash
# graph.sh

# Load config.sh
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

echo "Extracting SQL data to text file..."
# Get data from SQL
mysql -u "$DB_USER" -p"$DB_PASSWORD" -B -e "
    SELECT 
        price_date,
        price,
        price_change,
        price_gram_24k,
        price_gram_22k,
        price_gram_21k,
        price_gram_20k,
        price_gram_18k,
        price_gram_16k,
        price_gram_14k,
        price_gram_10k
    FROM gold_prices 
    ORDER BY price_date, created_at DESC
" $DB_NAME > "$BASE_DIR/data/gold_data.txt"

# Check if got data
if [ ! -s "$BASE_DIR/data/gold_data.txt" ] || [ $(wc -l < "$BASE_DIR/data/gold_data.txt") -le 1 ]; then
    echo "No data found in database."
    exit 1
fi

echo "Data sample:"
head -3 "$BASE_DIR/data/gold_data.txt"

# Array of column names, titles, and y-axis labels
declare -a columns=("price" "price_change" "price_gram_24k" "price_gram_22k" "price_gram_21k" "price_gram_20k" "price_gram_18k" "price_gram_16k" "price_gram_14k" "price_gram_10k")
declare -a titles=("Gold Price (USD per ounce)" "Gold Price Daily Change" "24K Gold Price (USD per gram)" "22K Gold Price (USD per gram)" "21K Gold Price (USD per gram)" "20K Gold Price (USD per gram)" "18K Gold Price (USD per gram)" "16K Gold Price (USD per gram)" "14K Gold Price (USD per gram)" "10K Gold Price (USD per gram)")
declare -a ylabels=("Price (USD)" "Change (USD)" "Price per Gram (USD)" "Price per Gram (USD)" "Price per Gram (USD)" "Price per Gram (USD)" "Price per Gram (USD)" "Price per Gram (USD)" "Price per Gram (USD)" "Price per Gram (USD)")

# loop 10 graphs
for i in {0..9}; do
    col_index=$((i + 2))
    output_file="$BASE_DIR/data/graph_${columns[$i]}.png"
    
    echo "Creating graph $((i+1))/10: ${titles[$i]}..."
    
    gnuplot << EOF
        set terminal png size 1000,600
        set output "$output_file"
        set title "${titles[$i]}"
        set xlabel "Date"
        set ylabel "${ylabels[$i]}"
        set grid
        set datafile separator "\t"
        set style data linespoints
        set xtics rotate
        # Column 0: row number (x), Column $col_index: data value (y), Column 1: date label
        plot "$BASE_DIR/data/gold_data.txt" every ::1 using 0:$col_index:xtic(1) with linespoints linewidth 2 pointtype 7 pointsize 1 title "${columns[$i]}"
EOF
done

echo ""
echo "All 10 graphs successfully generated:"
echo ""