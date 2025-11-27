#!/bin/bash
# graph.sh - Gold Price Visualization

source config.sh

echo "extracting sql data to txt."
# data from sql db --> data/gold_data.txt
mysql -u "$DB_USER" -p"$DB_PASSWORD" -B -e "
    SELECT 
        gold_price_usd,
        change_amount
    FROM gold_prices 
    ORDER BY created_at
" $DB_NAME > "$BASE_DIR/data/gold_data.txt"

# check if got data (if file doesn't exist or has less than 1 line (wordcount) )
if [ ! -s "$BASE_DIR/data/gold_data.txt" ] || [ $(wc -l < "$BASE_DIR/data/gold_data.txt") -le 1 ]; then
    echo "No data found in database."
    exit 1
fi

echo "Data sample:"
head -3 "$BASE_DIR/data/gold_data.txt"

# create price trend chart
echo "Creating price trend chart."
gnuplot << EOF
    set terminal png size 1000,600
    set output "$BASE_DIR/data/price_trend.png"
    #set label names & style
    set title "Gold Price Trend"
    set xlabel "Data Points"
    set ylabel "Price (USD)"
    set grid
    set style data lines
    # plot data, skip header lines
    plot "$BASE_DIR/data/gold_data.txt" every ::1 using 1 with lines linewidth 2 title "Gold Price (USD)"
EOF
echo "Price trend chart sucessfully created."

# create price changes chart
echo "Creating price changes chart."
gnuplot << EOF
    set terminal png size 1000,400
    set output "$BASE_DIR/data/price_changes.png"
    #set label names & style
    set title "Gold Price Changes"
    set xlabel "Data Points"
    set ylabel "Change Amount (USD)"
    set grid
    # plot data, skip header lines
    plot "$BASE_DIR/data/gold_data.txt" every ::1 using 2 with points pointtype 7 pointsize 2 title "Price Changes (USD)"
EOF
echo "Price changes chart succesfully created."

echo ""
echo "Charts successfully generated."
echo "File Location: $BASE_DIR/data/"
ls -la "$BASE_DIR/data/"*.png