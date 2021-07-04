#!/bin/bash


####################################### CONFIG PATHS #######################################

PATH_CONFIG="${HOME}/Git/Activate-SplikTv-app/Scripts/config"

PATH_TELEGRAM_BOT_SCRIPT="${PATH_CONFIG}/telegram-bot.sh"
PATH_TELEGRAM_BOT_TOKEN="${PATH_CONFIG}/telegram-bot-token.txt"
PATH_MY_TELEGRAM_ID="${PATH_CONFIG}/my-telegram-id.txt"

############################################################################################



# Load the config to send messeges with a telegram bot
. "${PATH_TELEGRAM_BOT_SCRIPT}"
loadTelegramBotConfig "${PATH_TELEGRAM_BOT_TOKEN}" "${PATH_MY_TELEGRAM_ID}"



# Connect to SplikTV web page, to activate
CURL_OUTPUT=$(curl --silent 'https://app.spliktv.xyz/activar' \
              --data-raw 'submite=Pulsa+aqu%C3%AD+para+activar')



# If curl don't return 0, then there was an error in the connection
if [ $? -ne "0" ]; then 

    MESSAGE="SplikTV: there was an error in curl sentence"
    echo "${MESSAGE}"
    sendTelegramMessage "${MESSAGE}"
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
