#!/bin/bash
# graph.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

# extract data in sql db into gold_data.txt
echo "Extracting SQL data to text file..."
mysql -u "$DB_USER" -p"$DB_PASSWORD" -B -e "
    SELECT 
        CONCAT(gp.price_date, ' ', gp.price_time) as datetime,
        gp.price,
        gp.price_change,
        MAX(CASE WHEN pp.purity = '24k' THEN pp.price_per_gram END) as price_gram_24k,
        MAX(CASE WHEN pp.purity = '22k' THEN pp.price_per_gram END) as price_gram_22k,
        MAX(CASE WHEN pp.purity = '21k' THEN pp.price_per_gram END) as price_gram_21k,
        MAX(CASE WHEN pp.purity = '20k' THEN pp.price_per_gram END) as price_gram_20k,
        MAX(CASE WHEN pp.purity = '18k' THEN pp.price_per_gram END) as price_gram_18k,
        MAX(CASE WHEN pp.purity = '16k' THEN pp.price_per_gram END) as price_gram_16k,
        MAX(CASE WHEN pp.purity = '14k' THEN pp.price_per_gram END) as price_gram_14k,
        MAX(CASE WHEN pp.purity = '10k' THEN pp.price_per_gram END) as price_gram_10k
    FROM gold_prices gp
    LEFT JOIN purity_prices pp ON gp.id = pp.gold_price_id
    GROUP BY gp.id, gp.price_date, gp.price_time, gp.price, gp.price_change
    ORDER BY gp.price_date, gp.price_time
" $DB_NAME > "$BASE_DIR/data/gold_data.txt"

# if no new data in gold_data.txt then exit
if [ ! -s "$BASE_DIR/data/gold_data.txt" ] || [ $(wc -l < "$BASE_DIR/data/gold_data.txt") -le 1 ]; then
    echo "No data found in database."
    exit 1
fi

plot_price() {
gnuplot << EOF
set terminal png size 1200,600
set output "$BASE_DIR/data/graph_price.png"
set title "Gold Price (USD per ounce)"
set xlabel "Date and Time"
set ylabel "Price (USD)"
set grid
set xdata time
set timefmt "%Y-%m-%d %H:%M:%S"
set format x "%m/%d %H:%M"
set datafile separator "\t"
plot "$BASE_DIR/data/gold_data.txt" every ::1 using 1:2 with linespoints linewidth 2
EOF
}

plot_change() {
gnuplot << EOF
set terminal png size 1200,600
set output "$BASE_DIR/data/graph_price_change.png"
set title "Gold Price Daily Change"
set xlabel "Date and Time"
set ylabel "Change (USD)"
set grid
set xdata time
set timefmt "%Y-%m-%d %H:%M:%S"
set format x "%m/%d %H:%M"
set datafile separator "\t"
plot "$BASE_DIR/data/gold_data.txt" every ::1 using 1:3 with linespoints linewidth 2
EOF
}

plot_24k() {
gnuplot << EOF
set terminal png size 1200,600
set output "$BASE_DIR/data/graph_price_gram_24k.png"
set title "24K Gold Price (USD per gram)"
set xlabel "Date and Time"
set ylabel "Price per Gram (USD)"
set grid
set xdata time
set timefmt "%Y-%m-%d %H:%M:%S"
set format x "%m/%d %H:%M"
set datafile separator "\t"
plot "$BASE_DIR/data/gold_data.txt" every ::1 using 1:4 with linespoints linewidth 2
EOF
}

plot_22k() {
gnuplot << EOF
set terminal png size 1200,600
set output "$BASE_DIR/data/graph_price_gram_22k.png"
set title "22K Gold Price (USD per gram)"
set xlabel "Date and Time"
set ylabel "Price per Gram (USD)"
set grid
set xdata time
set timefmt "%Y-%m-%d %H:%M:%S"
set format x "%m/%d %H:%M"
set datafile separator "\t"
plot "$BASE_DIR/data/gold_data.txt" every ::1 using 1:5 with linespoints linewidth 2
EOF
}

plot_21k() {
gnuplot << EOF
set terminal png size 1200,600
set output "$BASE_DIR/data/graph_price_gram_21k.png"
set title "21K Gold Price (USD per gram)"
set xlabel "Date and Time"
set ylabel "Price per Gram (USD)"
set grid
set xdata time
set timefmt "%Y-%m-%d %H:%M:%S"
set format x "%m/%d %H:%M"
set datafile separator "\t"
plot "$BASE_DIR/data/gold_data.txt" every ::1 using 1:6 with linespoints linewidth 2
EOF
}

plot_20k() {
gnuplot << EOF
set terminal png size 1200,600
set output "$BASE_DIR/data/graph_price_gram_20k.png"
set title "20K Gold Price (USD per gram)"
set xlabel "Date and Time"
set ylabel "Price per Gram (USD)"
set grid
set xdata time
set timefmt "%Y-%m-%d %H:%M:%S"
set format x "%m/%d %H:%M"
set datafile separator "\t"
plot "$BASE_DIR/data/gold_data.txt" every ::1 using 1:7 with linespoints linewidth 2
EOF
}

plot_18k() {
gnuplot << EOF
set terminal png size 1200,600
set output "$BASE_DIR/data/graph_price_gram_18k.png"
set title "18K Gold Price (USD per gram)"
set xlabel "Date and Time"
set ylabel "Price per Gram (USD)"
set grid
set xdata time
set timefmt "%Y-%m-%d %H:%M:%S"
set format x "%m/%d %H:%M"
set datafile separator "\t"
plot "$BASE_DIR/data/gold_data.txt" every ::1 using 1:8 with linespoints linewidth 2
EOF
}

plot_16k() {
gnuplot << EOF
set terminal png size 1200,600
set output "$BASE_DIR/data/graph_price_gram_16k.png"
set title "16K Gold Price (USD per gram)"
set xlabel "Date and Time"
set ylabel "Price per Gram (USD)"
set grid
set xdata time
set timefmt "%Y-%m-%d %H:%M:%S"
set format x "%m/%d %H:%M"
set datafile separator "\t"
plot "$BASE_DIR/data/gold_data.txt" every ::1 using 1:9 with linespoints linewidth 2
EOF
}

plot_14k() {
gnuplot << EOF
set terminal png size 1200,600
set output "$BASE_DIR/data/graph_price_gram_14k.png"
set title "14K Gold Price (USD per gram)"
set xlabel "Date and Time"
set ylabel "Price per Gram (USD)"
set grid
set xdata time
set timefmt "%Y-%m-%d %H:%M:%S"
set format x "%m/%d %H:%M"
set datafile separator "\t"
plot "$BASE_DIR/data/gold_data.txt" every ::1 using 1:10 with linespoints linewidth 2
EOF
}

plot_10k() {
gnuplot << EOF
set terminal png size 1200,600
set output "$BASE_DIR/data/graph_price_gram_10k.png"
set title "10K Gold Price (USD per gram)"
set xlabel "Date and Time"
set ylabel "Price per Gram (USD)"
set grid
set xdata time
set timefmt "%Y-%m-%d %H:%M:%S"
set format x "%m/%d %H:%M"
set datafile separator "\t"
plot "$BASE_DIR/data/gold_data.txt" every ::1 using 1:11 with linespoints linewidth 2
EOF
}

# call functions individually, if not then call all at once
case "$1" in
    price)
        plot_price
        ;;
    change)
        plot_change
        ;;
    24k)
        plot_24k
        ;;
    22k)
        plot_22k
        ;;
    21k)
        plot_21k
        ;;
    20k)
        plot_20k
        ;;
    18k)
        plot_18k
        ;;
    16k)
        plot_16k
        ;;
    14k)
        plot_14k
        ;;
    10k)
        plot_10k
        ;;
    "")
        #if no argument, generate all 10 graphs
        plot_price
        plot_change
        plot_24k
        plot_22k
        plot_21k
        plot_20k
        plot_18k
        plot_16k
        plot_14k
        plot_10k
        ;;
    *)
        echo "Unknown option: $1"
        echo "Usage: ./graph.sh [price|change|24k|22k|21k|20k|18k|16k|14k|10k]"
        exit 1
        ;;
esac

# if no argument passed, all graphs created, else graph $1 created
echo ""
if [ -z "$1" ]; then
    echo "All graphs successfully created."
else
    echo "Graph '$1' successfully created."
fi
echo ""
echo "Graph generation complete"
echo ""