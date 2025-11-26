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

# Extract values using jq
price=$(echo "$response" | jq -r '.price')
change=$(echo "$response" | jq -r '.ch // 0')  

echo "Price: $price | Change: $change"

# Validate
if [[ -n "$price" && "$price" != "null" ]]; then
    # current date & time
    date=$(date '+%Y-%m-%d')
    time=$(date '+%H:%M:%S')

    mysql -u "$DB_USER" -p"$DB_PASSWORD" <<EOF
        USE $DB_NAME;
        INSERT INTO gold_prices (price_date, price_time, gold_price_usd, change_amount)
        VALUES ('$date', '$time', $price, $change);
EOF

    log_message "Price: $price USD | Change: $change"
    echo "succesfully stored in db"

else
    log_message "api data invalid"
    echo "failed to parse price"
fi
