# Gold Price Tracker

## 1. Database Setup
** IMPORTANT **
- configure DB_USER and DB_PASSWORD in scripts/config.sh
- register your account at https://www.goldapi.io/dashboard 
  and copy your API key into the 'GOLD_API_KEY' variable in scripts/config.sh
- run "mysql -u root -p < sql/init_database.sql" to initialise sql db

## 2. Crontab Setup

chmod +x crontab.sh scripts/*.sh
crontab -e

# run every 5 mins: (Testing)
*/5 * * * * cd /path/to/your/gold_price_tracker && ./crontab.sh >> temp/cron.log 2>&1
# run every hour:
0 * * * * cd /path/to/your/gold_price_tracker && ./crontab.sh >> temp/cron.log 2>&1
# run every day: (Recommended as gold prices do not fluctuate frequently)
0 0 * * * cd /path/to/your/gold_price_tracker && ./crontab.sh >> temp/cron.log 2>&1

# display scheduled jobs
crontab -l

## 3. SQL Dump (Optional)

mysql -u root -p < /sql/data_dump.sql
# to check sql tables
mysql -u root -p -e "USE gold_tracker; SELECT * FROM gold_prices;"
mysql -u root -p -e "USE gold_tracker; SELECT * FROM purity_prices;"

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