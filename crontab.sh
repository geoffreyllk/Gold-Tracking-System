#crontab.sh
#!/bin/bash

# Run at midnight daily
0 0 * * * cd /path/to/your/project && ./crontab.sh >> /path/to/your/project/temp/cron.log 2>&1