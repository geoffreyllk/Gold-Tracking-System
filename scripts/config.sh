#!/bin/bash
# config.sh

DB_USER="root"
DB_PASSWORD="avdex2025"
DB_NAME="gold_tracker"
DB_HOST="localhost"

GOLD_API_KEY="goldapi-a99t1nsmifixgp2-io"
GOLD_API_URL="https://www.goldapi.io/api/XAU/USD"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")"
LOG_FILE="$BASE_DIR/temp/gold_tracker.log"