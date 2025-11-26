#!/bin/bash
# test.sh

source config.sh

echo "Testing Gold Tracker"

# Test database
echo "Database:"
mysql -u $DB_USER -p$DB_PASSWORD -e "USE $DB_NAME; SELECT 'Records:', COUNT(*) FROM gold_prices;"

# Test API
echo "API:"
response=$(curl -s -H "x-access-token: $GOLD_API_KEY" $GOLD_API_URL)
price=$(echo "$response" | grep -o '"price":[0-9]*\.\?[0-9]*' | cut -d: -f2)
echo "Current price: $price"

# Test files
echo "Files:"
ls -la $DATA_FILE
ls -la $LOG_FILE

echo "Test Complete"