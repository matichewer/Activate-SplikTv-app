#!/bin/bash


####################################### CONFIG PATH #######################################

#THIS_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Load the config to use the telegram bot
#. "${THIS_PATH}/TelegramBashBotsFramework/tbb.sh"

# Logs
#LOG="${THIS_PATH}/log.txt"

###########################################################################################

PATH_LOG="log.txt"

saveLog(){
    # Guardo logs
    echo -e "$(date '+%Y/%m/%d%t%H:%M:%S')\t${STATUS}" >> ${PATH_LOG}
    echo "${STATUS}"
}

# Obtengo link personal de activacion
LINK=$(curl                                                                    \
            --silent                                                           \
            --include                                                          \
            'https://app.spliktv.xyz/activar'                                  \
            | grep "ocation"                                                   \
            | cut --delimiter=' ' --fields=2                                   \
            | tr -d " \t\n\r") 

# Si curl() NO retorna 0, entonces hubo un error en la generacion del link
if [ $? -ne "0" ]; then 
    STATUS="Error: no se pudo generar el link"
    saveLog
    exit 1
fi


# Intento activar la app con el link generado previamente
CURL_OUTPUT=$(curl                                                             \
                --silent                                                       \
                "${LINK}"                                                      \
                --data-raw 'submite=Pulsa+aqu%C3%AD+para+activar')

# Si curl() NO retorna 0, entonces hubo un error en la conexion
if [ $? -ne "0" ]; then 
    STATUS="Error: link generado, pero no se pudo presionar el boton de activacion"
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
            STATUS="Error: conexion realizada, pero no se pudo activar ni tampoco estaba activado"
            saveLog
            exit 1
        else
            STATUS="OK: no requeria activacion, ya lo estaba"
        fi
    else       
        # En éste punto ya se tiene que haber activado si o si 
        STATUS="OK: activado"        
        #sendMessage "text:SplikTV: ${STATUS}" > /dev/null
    fi
fi

# Si la ejecucion llega a éste punto, entonces no hubo ningun error
saveLog

