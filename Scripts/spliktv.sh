#!/bin/bash


# Load the config to send messeges with a telegram bot
. ${HOME}/Scripts/config/telegram-raspberry-bot.sh
loadTelegramBotConfig


# Connect to SplikTV web page, to activate
CURL_OUTPUT=$(curl --silent 'https://app.spliktv.xyz/activar' \
              --data-raw 'submite=Pulsa+aqu%C3%AD+para+activar')



# If curl don't return 0, then there was an error in the connection
if [ $? -ne "0" ]; then 

    MESSAGE="SplikTV: there was an error in curl sentence"
    echo "${MESSAGE}"
    sendTelegramMessage
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
    sendTelegramMessage

fi
