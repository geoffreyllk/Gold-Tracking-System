#!/bin/bash
# track_prices.sh

# Load config.sh
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

get_price() {
    curl -s -H "x-access-token: $GOLD_API_KEY" "$GOLD_API_URL"
}

response=$(get_price)
echo "API response: $response"

# Extract values using jq, if null default to 0
price=$(echo "$response" | jq -r '.price // 0')
change=$(echo "$response" | jq -r '.ch // 0')
price_24k=$(echo "$response" | jq -r '.price_gram_24k // 0')
price_22k=$(echo "$response" | jq -r '.price_gram_22k // 0')
price_21k=$(echo "$response" | jq -r '.price_gram_21k // 0')
price_20k=$(echo "$response" | jq -r '.price_gram_20k // 0')
price_18k=$(echo "$response" | jq -r '.price_gram_18k // 0')
price_16k=$(echo "$response" | jq -r '.price_gram_16k // 0')
price_14k=$(echo "$response" | jq -r '.price_gram_14k // 0')
price_10k=$(echo "$response" | jq -r '.price_gram_10k // 0')

# validate price
if [[ -n "$price" && "$price" != "null" ]]; then
    # current date & time
    date=$(date '+%Y-%m-%d')
    time=$(date '+%H:%M:%S')

    #insert values into sql db
    mysql -u "$DB_USER" -p"$DB_PASSWORD" <<EOF
        USE $DB_NAME;
        INSERT INTO gold_prices (
            price_date, price_time, price, price_change,
            price_gram_24k, price_gram_22k, price_gram_21k, price_gram_20k, price_gram_18k, price_gram_16k, price_gram_14k, price_gram_10k
        ) VALUES (
            '$date', '$time', $price, $change,
            $price_24k, $price_22k, $price_21k, $price_20k, $price_18k, $price_16k, $price_14k, $price_10k
        );
EOF

    log_message "SUCCESS: Recorded price $price USD (Change: $price_change USD) | Purity prices: 24k=$price_24k, 22k=$price_22k, 18k=$price_18k, 16k=$price_16k, 14k=$price_14k, 10k=$price_10k"
    echo "succesfully stored in db"

else
    #if invalid echo error
    log_message "Failed to parse API."
    echo "Failed to parse API."
fi
