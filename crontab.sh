#!/bin/bash
# crontab.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Check network (internet)
if ! ping -c 1 8.8.8.8 > /dev/null 2>&1; then
    echo "$(date) - ERROR: network not found"
    exit 1
fi

# run track_prices.sh
if ! ./scripts/track_prices.sh; then
    echo "$(date) - WARNING: track_prices.sh failed, continuing..."
fi

# run graph.sh
if ! ./scripts/graph.sh; then
    echo "$(date) - ERROR: graph.sh failed"
    exit 1
fi

echo "$(date) - Completed"