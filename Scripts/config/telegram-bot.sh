#!/bin/bash


# Set paths
PATH_CONFIG="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PATH_TELEGRAM_BOT_TOKEN="${PATH_CONFIG}/telegram-bot-token.txt"
PATH_MY_TELEGRAM_ID="${PATH_CONFIG}/my-telegram-id.txt"
PATH_DEVICE_INFO="${PATH_CONFIG}/device.txt"



# Read telegram bot token (to send alerts)
TOKEN=$(<"${PATH_TELEGRAM_BOT_TOKEN}")

if [ $? -ne "0" ]; then
  echo "Error: the telegram bot token couldn't be read"
  exit 1
fi

# Read my telegram account id (to receive alerts)
ID=$(<"${PATH_MY_TELEGRAM_ID}")

if [ $? -ne "0" ]; then
  echo "Error: my telegram account id couldn't be read"
  exit 1
fi

# Url api for telegram
URL="https://api.telegram.org/bot$TOKEN/sendMessage"


# Read my telegram account id (to receive alerts)
ID=$(<"${PATH_MY_TELEGRAM_ID}")

if [ $? -ne "0" ]; then
  echo "Error: my telegram account id couldn't be read"
  exit 1
fi



DEVICE_INFO=$(<"${PATH_DEVICE_INFO}")
if [ $? -ne "0" ]; then
  echo "Error: device info couldn't be read"
  exit 1
fi

MSG_DEVICE="<b>Device:</b> <i>$DEVICE_INFO</i>%0A"



sendTelegramMessage(){  

  curl -s -X POST "$URL" -d chat_id="$ID" -d text="$MSG_DEVICE$1" -d parse_mode="HTML" > /dev/null

}