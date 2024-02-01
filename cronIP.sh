#################################################################################################################
#                                                                                                               #
#   Usage:    ./cronIP.sh --location myPlace --endpoint https://my.webhookrelay.com/v1/webhooks/abcToken-1234   #
#                                                                                                               #
#################################################################################################################

#!/bin/bash

pararser() {
    # Define default values
    location=${location:-""}
    endpoint=${endpoint:-""}

    # Assign the values given by the user
    while [ $# -gt 0 ]; do
        if [[ $1 == *"--"* ]]; then
            param="${1/--/}"
            declare -g $param="$2"
        fi
        shift
    done
}

function process_arguments() {
    location=""
    endpoint=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -l|--location)
                shift
                location="$1"
                ;;
            -e|--endpoint)
                shift
                endpoint="$1"
                ;;
            *)
                echo "Unknown option: $1"
                exit 1
                ;;
        esac
        shift
    done

    if [[ -z "$location" || -z "$endpoint" ]]; then
        echo "Error: Both '--location | -l' and '--endpoint | -e' are required arguments."
        exit 1
    fi
}



echo -e "\n--- Starting Cron Job ---"

# Uncomment to do an additional update & upgrade
#echo "    Update && Upgrade"
#sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y && sudo apt autoremove -y

# Call the function with the provided arguments
process_arguments "$@"

# Fetch current IP
echo -e "\n--  Getting current IP  --"

ip=$(curl -s ipinfo.io/ip)

if [[ -z "$ip" ]]; then
	echo "Error: No IP found, check your network connection."
	exit 1
else
	echo "-   IP: ${ip}   -"
fi

# Create body
jsonPayload="{\"location\": \"${location}\", \"address\": \"${ip}\"}"
echo "    Setting json payload to ${jsonPayload}"

# POST to api
echo -e "\n--  Sending IP  -- \n"
response=$(curl -s -i -H "Content-Type: application/json" -X POST -d "${jsonPayload}" ${endpoint})

if [[ -z "$response" ]]; then
	echo "Error: Could not reach endpoint ${endpoint}."
	exit 1
else
	# Extract status and content-length from headers
	status=$(echo "$response" | grep -i ^HTTP | cut -d ' ' -f 2)
	content_length=$(echo "$response" | grep -i ^Content-Length | cut -d ' ' -f 2)

	# Extract content from the response body
	content=$(echo "$response" | sed -n '/^\r\{0,1\}$/,$p' | sed '1d')

	# Print the extracted values
	echo "Status: $status"
	echo "Content-Length: $content_length"
	echo "Content: $content"

	case "$status" in
			200) echo "Everything went AOK" ;;
			301) echo "Everything went AOK" ;;
			304) printf "Received: HTTP $response (file unchanged) ==> $endpoint\n" ;;
			404) printf "Received: HTTP $response (file not found) ==> $endpoint\n" ;;
			*) printf "Received: HTTP $response ==> $endpoint\n" ;;
	esac
fi
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
