#!/bin/bash


loadTelegramBotConfig(){

    # Read telegram bot token (to send alerts)
    TOKEN=$(<${HOME}/Scripts/config/raspberry-telegram-bot-token.txt)

    if [ $? -ne "0" ]; then
      echo "Error: the telegram bot token couldn't be read"
      exit 1
    fi


    # Read my telegram account id (to receive alerts)
    ID=$(<${HOME}/Scripts/config/my-telegram-id.txt)

    if [ $? -ne "0" ]; then
      echo "Error: my telegram account id couldn't be read"
      exit 1
    fi


    # Url api for telegram
    URL="https://api.telegram.org/bot$TOKEN/sendMessage"

}




sendTelegramMessage(){  

  curl -s -X POST "$URL" -d chat_id="$ID" -d text="$1" > /dev/null

}