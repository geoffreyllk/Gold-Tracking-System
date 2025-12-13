# Gold Price Tracker

## 1. Database Setup
first, configure DB_USER and DB_PASSWORD in scripts/config.sh

```bash
mysql -u root -p < init_database.sql

## 2. Crontab Setup

chmod +x crontab.sh scripts/*.sh
crontab -e

# Run every 5 mins: (Testing)
*/5 * * * * cd /path/to/your/gold_price_tracker && ./crontab.sh >> temp/cron.log 2>&1

# Run every hour:
0 * * * * cd /path/to/your/gold_price_tracker && ./crontab.sh >> temp/cron.log 2>&1

# Run every day: (Recommended as gold prices do not fluctuate frequently)
0 0 * * * cd /path/to/your/gold_price_tracker && ./crontab.sh >> temp/cron.log 2>&1

# display scheduled jobs
crontab -l


## Manual Execution (Test)

cd ~/gold_price_tracker

# run once to test crontab
./crontab.sh

# run to test individual scripts
./scripts/track_prices.sh
./scripts/graph.sh

# to generate specific graphs
./scripts/graph.sh price
./scripts/graph.sh change
./scripts/graph.sh 24k
./scripts/graph.sh 22k
./scripts/graph.sh 21k
./scripts/graph.sh 20k
./scripts/graph.sh 18k
./scripts/graph.sh 16k
./scripts/graph.sh 14k
./scripts/graph.sh 10k

# to check sql database
mysql -u root -p -e "USE gold_tracker; SELECT * FROM gold_prices;"
mysql -u root -p -e "USE gold_tracker; SELECT * FROM purity_prices;"