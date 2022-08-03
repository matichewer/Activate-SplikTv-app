#!/bin/bash

LINK="https://sv.spliktv.xyz/activar"
PATH_LOG="/spliktv/logs/spliktv.log"

saveLog(){
    echo -e "$(date '+%Y/%m/%d,%H:%M:%S'),${STATUS}" >> ${PATH_LOG}
    echo -e "${STATUS}"
}


: '
# Intento activar la app
CURL_OUTPUT=$(curl                                                             \
                --silent                                                       \
                "${LINK}"                                                      \
                --data-raw 'submite=Pulsa+aqu%C3%AD+para+activar')
'

CURL_OUTPUT=$(curl 'https://sv.spliktv.xyz/activar' \
                --silent \
                -H 'authority: sv.spliktv.xyz' \
                -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
                -H 'accept-language: en-US,en;q=0.9,es;q=0.8,la;q=0.7' \
                -H 'content-type: application/x-www-form-urlencoded' \-H 'dnt: 1' \
                -H 'origin: https://sv.spliktv.xyz' \
                -H 'referer: https://sv.spliktv.xyz/activar' \
                -H 'sec-ch-ua: " Not A;Brand";v="99", "Chromium";v="102", "Google Chrome";v="102"' \
                -H 'sec-ch-ua-mobile: ?0' \
                -H 'sec-ch-ua-platform: "Linux"' \
                -H 'sec-fetch-dest: document' \
                -H 'sec-fetch-mode: navigate' \
                -H 'sec-fetch-site: same-origin' \
                -H 'sec-fetch-user: ?1' \
                -H 'upgrade-insecure-requests: 1' \
                -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.0.0 Safari/537.36' \
                --data-raw 'si=Pulsa+aqu%C3%AD+para+activar' \
                --compressed
            )




# Si curl() NO retorna 0, entonces hubo un error en la conexion
if [ $? -ne "0" ]; then
    STATUS="ERROR,link generado pero no se pudo presionar el boton de activacion"
    saveLog
    exit 1
else

    # Busco si realmente se ha activado
    grep -q "Activado" <<< "${CURL_OUTPUT}"
    ACTIVADO=$?

    # Si grep() no retorna 0, entonces no se pudo activar
    if [ ${ACTIVADO} -ne 0 ]; then

        # Busco si ya habia sido activado previamente
        grep -q "Ya activaste" <<< "${CURL_OUTPUT}"
        YA_ACTIVASTE=$?
        if [ ${YA_ACTIVASTE} -ne 0 ]; then
            STATUS="ERROR,conexion realizada pero no se pudo activar ni tampoco estaba activado"
            saveLog
            exit 1
        else
            STATUS="OK,ya estaba activado"
        fi
    else
        # En éste punto ya se tiene que haber activado si o si
        STATUS="OK,activado"
    fi
fi


# Por si no permite efectivamente activar por no abrir anuncios.
# Error completo: "Acción denegada. Violación en el uso de funciones de la app.""
grep -q "denegad"  <<< "${CURL_OUTPUT}"
DENEGADO=$?
if [ ${DENEGADO} -eq 0 ]; then
    STATUS="ERROR,accion denegada por no abrir anuncios"
    saveLog
    exit 1
fi



# Si la ejecucion llega a éste punto, entonces no hubo ningun error
saveLog

# Si puede activar, entonces genero el grafico y lo actualizo en nginx
if [[ "$STATUS" == "OK,activado" ]]; then
    /usr/local/bin/python3 /spliktv/activate-app/plotting.py
fi

