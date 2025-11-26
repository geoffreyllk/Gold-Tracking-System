#!/bin/bash
# track_prices.sh

# Load config.sh
source config.sh

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $LOG_FILE
}

get_price() {
    curl -s -H "x-access-token: $GOLD_API_KEY" "$GOLD_API_URL"
}

response=$(get_price)
echo "API Response: $response"

price=$(echo "$response" | grep -o '"price":[0-9]*\.\?[0-9]*' | cut -d: -f2)
change=$(echo "$response" | grep -o '"ch":[+-]*[0-9]*\.\?[0-9]*' | cut -d: -f2)

echo "Extracted price: $price"
echo "Extracted change: $change"

if [ -z "$change" ]; then
    change="0"
    echo "Change value empty, using default: $change"
fi

if [ -n "$price" ]; then
    # Insert into database
    date=$(date '+%Y-%m-%d')
    time=$(date '+%H:%M:%S')
    
    mysql -u $DB_USER -p$DB_PASSWORD -e "
        USE $DB_NAME;
        INSERT INTO gold_prices (price_date, price_time, gold_price_usd, change_amount) 
        VALUES ('$date', '$time', '$price', '$change');
    "
    
    # Save to CSV
    echo "$date,$time,$price,$change" >> $DATA_FILE
    
    log_message "Price recorded: $price USD (Change: $change)"
else
    log_message "ERROR: Failed to get price"
fi