#!/bin/bash
# config.sh

DB_USER="root" # change if needed
DB_PASSWORD="" # insert your SQL database password IF ANY
DB_NAME="gold_tracker"
DB_HOST="localhost" # change if needed

GOLD_API_KEY="" # register at https://www.goldapi.io/dashboard and copy your API key here
GOLD_API_URL="https://www.goldapi.io/api/XAU/USD"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")"

LOG_DIR="$BASE_DIR/temp"
LOG_FILE="$LOG_DIR/track_prices.log"
