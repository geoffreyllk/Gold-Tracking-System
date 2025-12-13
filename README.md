# Gold Price Tracker

## 1. Database Setup

```bash
mysql -u root -p < init_database.sql

## 2. Crontab Setup

chmod +x crontab.sh scripts/*.sh
crontab -e

# to run every 5 mins: (Testing)
*/5 * * * * /home/user1/gold_price_tracker/crontab.sh >> /home/user1/gold_price_tracker/temp/cron.log 2>&1

# to run every hour:
0 * * * * /home/user1/gold_price_tracker/crontab.sh >> /home/user1/gold_price_tracker/temp/cron.log 2>&1

# to run every day:
0 0 * * * /home/user1/gold_price_tracker/crontab.sh >> /home/user1/gold_price_tracker/temp/cron.log 2>&1

# display scheduled jobs
crontab -l


## Manual Execution (Test)

# run once to test crontab
./crontab.sh

# run to test individual scripts
./scripts/track_prices.sh
./scripts/graph.sh

# to generate specific graphs
