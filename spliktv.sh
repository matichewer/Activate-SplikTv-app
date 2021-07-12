#!/bin/bash


####################################### CONFIG PATH #######################################

MY_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"


PATH_TELEGRAM_BOT="${MY_PATH}/config/telegram-bot.sh"
# Load the config to send messeges with a telegram bot
. "${PATH_TELEGRAM_BOT}"

###########################################################################################


# Connect to SplikTV web page, to activate
MY_LINK=$(curl --silent --include 'https://app.spliktv.xyz/activar' | grep location | cut --delimiter=' ' --fields=2 | tr -d " \t\n\r")

# If curl don't return 0, then there was an error in the connection
if [ $? -ne "0" ]; then 

    MESSAGE="SplikTV: can't get the link with my ID"
    echo "${MESSAGE}"
    sendTelegramMessage "${MESSAGE}"
    exit 1

fi


CURL_OUTPUT=$(curl --silent ${MY_LINK} --data-raw 'submite=Pulsa+aqu%C3%AD+para+activar')


# If curl don't return 0, then there was an error in the connection
if [ $? -ne "0" ]; then 

    MESSAGE="SplikTV: there was an error in curl sentence"
    echo "${MESSAGE}"
    sendTelegramMessage "${MESSAGE}"
    echo "${MY_LINK}"
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
    sendTelegramMessage "${MESSAGE}"

fi
