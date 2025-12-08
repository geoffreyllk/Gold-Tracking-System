#!/bin/bash
# crontab.sh


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Run the tracker script
./scripts/track_prices.sh
./scripts/graph.sh