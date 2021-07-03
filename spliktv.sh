#!/bin/bash


################################ TELEGRAM BOT CONFIG ################################

# Read telegram bot token (to send alerts)
TOKEN=$(<raspberry-telegram-bot-token.txt)
if [ $? -ne "0" ]; then
  echo "Error: the telegram bot token couldn't be read"
  exit 1
fi

# Read my telegram account id (to receive alerts)
ID=$(<my-telegram-id.txt)
if [ $? -ne "0" ]; then
  echo "Error: my telegram account id couldn't be read"
  exit 1
fi

# Url api for telegram
URL="https://api.telegram.org/bot$TOKEN/sendMessage"


sendTelegramMessage(){  
  curl -s -X POST "$URL" -d chat_id=$ID -d text="$MENSAJE" > /dev/null
}

#####################################################################################



# Connect to SplikTV web page, to activate
CURL_OUTPUT=$(curl --silent 'https://app.spliktv.xyz/activar' \
              --data-raw 'submite=Pulsa+aqu%C3%AD+para+activar')



# If curl don't return 0, then there was an error in the connection
if [ $? -ne "0" ]; then 

    MENSAJE="SplikTV: there was an error in curl sentence"
    echo ${MENSAJE}
    sendTelegramMessage
    exit 1

else

    # Find if it was really activated
    grep -q 'Activado' <<< "${CURL_OUTPUT}"

    # If grep return 0, there was no error
    if [ $? -eq "0" ]; then
        MENSAJE="SplikTV: activated"
    else
        MENSAJE="SplikTV: connection made but couldn't be activated"
    fi

    echo ${MENSAJE}
    sendTelegramMessage

fi
