#!/bin/bash
# graph.sh - Gold Price Visualization

source config.sh

echo "extracting sql data to txt."
# data from sql db --> data/gold_data.txt
mysql -u "$DB_USER" -p"$DB_PASSWORD" -B -e "
    SELECT 
        price_date,
        gold_price_usd,
        change_amount
    FROM gold_prices 
    WHERE (price_date, created_at) IN (
        SELECT price_date, MAX(created_at) 
        FROM gold_prices
        GROUP BY price_date
    )
    ORDER BY price_date
" $DB_NAME > "$BASE_DIR/data/gold_data.txt"

# check if got data, if file doesn't exist or has less than 1 line (wordcount)
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
    set xlabel "Date"
    set ylabel "Price (USD)"
    set grid
    set datafile separator "\t"
    set style data lines
    # REMOVE xdata time and use categorical x-axis
    set xtics rotate
    # plot data: using 0:2 means use row number for x, column2(price) for y
    # and xtic(1) uses column1 for x-axis labels
    plot "$BASE_DIR/data/gold_data.txt" every ::1 using 0:2:xtic(1) with lines linewidth 2 title "Gold Price (USD)"
EOF
echo "Price trend chart successfully created."

# create price changes chart
echo "Creating price changes chart."
gnuplot << EOF
    set terminal png size 1000,400
    set output "$BASE_DIR/data/price_changes.png"
    #set label names & style
    set title "Gold Price Changes"
    set xlabel "Date"
    set ylabel "Change Amount (USD)"
    set grid
    set datafile separator "\t"
    # REMOVE xdata time and use categorical x-axis
    set xtics rotate
    # plot data: using 0:3 means use row number for x, column3(change) for y
    # and xtic(1) uses column1 for x-axis labels
    plot "$BASE_DIR/data/gold_data.txt" every ::1 using 0:3:xtic(1) with points pointtype 7 pointsize 2 title "Price Changes (USD)"
EOF
echo "Price changes chart successfully created."

echo ""
echo "Charts successfully generated."
echo "File Location: $BASE_DIR/data/"
ls -la "$BASE_DIR/data/"*.png