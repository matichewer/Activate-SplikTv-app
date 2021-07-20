#!/bin/bash


####################################### CONFIG PATH #######################################

THIS_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Load the config to use the telegram bot
. "${THIS_PATH}/TelegramBashBotsFramework/tbb.sh"

###########################################################################################



# Generate the link with the correct ID to activate
LINK=$(curl --silent --include 'https://app.spliktv.xyz/activar' | grep location | cut --delimiter=' ' --fields=2 | tr -d " \t\n\r")

# If curl don't return 0, then there was an error in the last sentence
if [ $? -ne "0" ]; then 

    MESSAGE="SplikTV: can't get the link with my ID"
    echo "${MESSAGE}"
    sendMessage "text:${MESSAGE}"
    exit 1

fi



# Activate SplikTv with the previously generated link
CURL_OUTPUT=$(curl --silent ${LINK} --data-raw 'submite=Pulsa+aqu%C3%AD+para+activar')

# If curl don't return 0, then there was an error in the connection
if [ $? -ne "0" ]; then 

    MESSAGE="SplikTV: there was an error in the activation
            ${LINK}"
    echo "${MESSAGE}"
    sendMessage "text:${MESSAGE}"
    exit 1

else

    # Find if it was really activated
    grep -q 'Activado' <<< "${CURL_OUTPUT}"

    # If grep return 0, there was no error
    if [ $? -eq "0" ]; then
        MESSAGE="SplikTV: activated"
    else
        MESSAGE="SplikTV: connection made but couldn't be activated"
    fi

    echo "${MESSAGE}"
    sendMessage "text:${MESSAGE}"

fi

