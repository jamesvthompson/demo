#!/bin/bash

# Step 1: Prepare a benign script
cat << EOF > benign_cronjob.sh
#!/bin/bash
echo "Cron job executed at \$(date)" >> /tmp/cronjob.log
EOF

# Step 2: Make the script executable
chmod +x benign_cronjob.sh

# Step 3: Create a cron job
(crontab -l 2>/dev/null; echo "* * * * * $(pwd)/benign_cronjob.sh") | crontab -

# Step 4: Display a message to monitor the cron job
echo "Cron job created. Monitor /tmp/cronjob.log for updates."
