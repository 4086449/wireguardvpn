#!/bin/bash

location="D"

echo "--- Starting pCron Job ---"

# Uncomment to do an additional update & upgrade
#echo "    Update && Upgrade"
#sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y && sudo apt autoremove -y

# Fetch current IP
echo "--  Getting current IP  --"
ip=$(curl ipinfo.io/ip)
echo "-   IP: $ip   -"

# Create body
echo "    Setting json payload"
JSON_PAYLOAD="{\"location\": \"$location\", \"address\": \"$ip\"}"

# POST to api
echo "--  Sending IP  --"
response=$(curl -s -H "Content-Type: application/json" -X POST -d "$JSON_PAYLOAD" https://my.webhookrelay.com/v1/webhooks/a4898eb2-bbd2-4b78-9257-2f33121a837d)

echo -e "\n\n\n--- done ---\n\n\n"


#   *     *     *   *    *        command to be executed
#   -     -     -   -    -
#   |     |     |   |    |
#   |     |     |   |    +----- day of the week (0 - 6) (Sunday = 0)
#   |     |     |   +------- month (1 - 12)
#   |     |     +--------- day of the month (1 - 31)
#   |     +----------- hour (0 - 23)
#   +------------- min (0 - 59)



#   0 9 * * 0 /home/your_username/myscript.sh

#   In this example, 
#   0 represents the minute, 
#   9 represents the hour, 
#   * * means every month and every day of the month, 
#   0 represents Sunday, and 
#   /home/your_username/myscript.sh is the full path to your script.