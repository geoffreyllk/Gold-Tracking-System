#!/bin/bash
# track_prices.sh

# Load config.sh
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# check API status
get_status() {
    curl -s -H "x-access-token: $GOLD_API_KEY" "https://www.goldapi.io/api/status"
}

# get price data
get_price() {
    curl -s -H "x-access-token: $GOLD_API_KEY" "$GOLD_API_URL"
}

# check if API status is true, else exit
status_response=$(get_status)
if echo "$status_response" | grep -q '"result":true'; then
    log_message "API Status: OK"
else
    log_message "API Status: DOWN - $status_response"
    echo "API is down: $status_response"
    exit 1
fi

price_response=$(get_price)

# check if API response contains 'error' e.g. {"error":"No data available for this pair"}
if echo "$price_response" | grep -q '"error":'; then
    error_msg=$(echo "$price_response" | jq -r '.error')
    log_message "API Error: $error_msg"
    echo "$error_msg"
    exit 1
fi

price=$(echo "$price_response" | jq -r '.price')
change=$(echo "$price_response" | jq -r '.ch')
price_24k=$(echo "$price_response" | jq -r '.price_gram_24k')
price_22k=$(echo "$price_response" | jq -r '.price_gram_22k')
price_18k=$(echo "$price_response" | jq -r '.price_gram_18k')
price_14k=$(echo "$price_response" | jq -r '.price_gram_14k')
price_10k=$(echo "$price_response" | jq -r '.price_gram_10k')

if [[ -n "$price" && "$price" != "null" ]]; then
    date=$(date '+%Y-%m-%d')
    time=$(date '+%H:%M:%S')
    
    mysql -u "$DB_USER" -p"$DB_PASSWORD" <<EOF
        USE $DB_NAME;
        INSERT INTO gold_prices (price_date, price_time, price, price_change)
        VALUES ('$date', '$time', $price, $change);
        
        SET @gold_price_id = LAST_INSERT_ID();
        
        INSERT INTO purity_prices (gold_price_id, purity, price_per_gram) VALUES
            (@gold_price_id, '24k', $price_24k),
            (@gold_price_id, '22k', $price_22k),
            (@gold_price_id, '18k', $price_18k),
            (@gold_price_id, '14k', $price_14k),
            (@gold_price_id, '10k', $price_10k);
EOF
    
    log_message "SUCCESS: Recorded price $price USD (Change: $change USD) | Purity prices: 24k=$price_24k, 22k=$price_22k, 18k=$price_18k, 16k=$price_16k, 14k=$price_14k, 10k=$price_10k"
    echo "Success"
else
    log_message "ERROR: No price data in response"
    echo "No price data"
    exit 1
fi