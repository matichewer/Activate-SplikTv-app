#!/bin/bash


################################ CONFIG TELEGRAM BOT ################################

TOKEN=$(<raspberry-telegram-bot-token.txt)
if [ $? -ne "0" ]; then
  echo "Error: No se pudo leer el token del bot de telegram"
  exit 1
fi

ID=$(<my-telegram-id.txt) # id de mi cuenta de telegram para recibir el mensaje
if [ $? -ne "0" ]; then
  echo "Error: No se pudo leer mi ID de Telegram"
  exit 1
fi

URL="https://api.telegram.org/bot$TOKEN/sendMessage"

#####################################################################################



# Connect to SplikTv web page, to activate
CURL_OUTPUT=$(curl --silent 'https://app.spliktv.xyz/activar' \
              -H 'Connection: keep-alive' \
              -H 'Cache-Control: max-age=0' \
              -H 'sec-ch-ua: " Not;A Brand";v="99", "Google Chrome";v="91", "Chromium";v="91"' \
              -H 'sec-ch-ua-mobile: ?0' \
              -H 'Origin: https://app.spliktv.xyz' \
              -H 'Upgrade-Insecure-Requests: 1' \
              -H 'DNT: 1' \
              -H 'Content-Type: application/x-www-form-urlencoded' \
              -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.114 Safari/537.36' \
              -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
              -H 'Sec-Fetch-Site: same-origin' \
              -H 'Sec-Fetch-Mode: navigate' \
              -H 'Sec-Fetch-User: ?1' \
              -H 'Sec-Fetch-Dest: document' \
              -H 'Referer: https://app.spliktv.xyz/activar' \
              -H 'Accept-Language: es-419,es;q=0.9' \
              --data-raw 'submite=Pulsa+aqu%C3%AD+para+activar' \
              --compressed)


if [ $? -eq "0" ]; then # Si curl no lanza error
  grep 'Activado' <<< "${CURL_OUTPUT}" 
  if [ $? -eq "0" ]; then # Si se obtuvo el mensaje de 'Activado'
    MENSAJE="SplikTV: activado"
  else
    MENSAJE="SplikTV: conexion realizada pero no se pudo activar"
  fi
else
  MENSAJE="SplikTV: error en curl"
fi


# El bot me envia el mensaje
curl -s -X POST "$URL" -d chat_id=$ID -d text="$MENSAJE"

