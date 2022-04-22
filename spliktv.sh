#!/bin/bash

LINK="https://sv.spliktv.xyz/activar"
PATH_LOG="log.txt"

saveLog(){
    echo -e "$(date '+%Y/%m/%d,%H:%M:%S'),${STATUS}" >> ${PATH_LOG}
    echo -e "${STATUS}"
}


# Intento activar la app
CURL_OUTPUT=$(curl                                                             \
                --silent                                                       \
                "${LINK}"                                                      \
                --data-raw 'submite=Pulsa+aqu%C3%AD+para+activar')

# Si curl() NO retorna 0, entonces hubo un error en la conexion
if [ $? -ne "0" ]; then 
    STATUS="ERROR,link generado pero no se pudo presionar el boton de activacion"
    saveLog
    exit 1
else

    # Busco si realmente se ha activado
    grep -q 'Activado' <<< "${CURL_OUTPUT}"

    # Si grep() no retorna 0, entonces no se pudo activar
    if [ $? -ne "0" ]; then

        # Busco si ya habia sido activado previamente  
        grep -q "Ya activaste" <<< "${CURL_OUTPUT}"
        if [ $? -ne "0" ]; then
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


# Si la ejecucion llega a éste punto, entonces no hubo ningun error
saveLog

# Si puede activar, entonces genero el grafico y lo actualizo en nginx
if [[ "$STATUS" == "OK,activado" ]]; then
    python plotting.py
    cp spliktv_activacion.html /var/www/html/
fi


