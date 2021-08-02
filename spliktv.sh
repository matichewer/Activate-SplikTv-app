#!/bin/bash


####################################### CONFIG PATH #######################################

THIS_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Load the config to use the telegram bot
. "${THIS_PATH}/TelegramBashBotsFramework/tbb.sh"

###########################################################################################



# Obtengo mi ID y genero el link de activacion
LINK=$(curl --silent --include                                                 \
            'https://app.spliktv.xyz/activar'                                  \
            | grep location                                                    \
            | cut --delimiter=' ' --fields=2                                   \
            | tr -d " \t\n\r")

# Si curl no retorna 0, entonces hubo un error en la generacion del link
if [ $? -ne "0" ]; then 
    STATUS="SplikTV: no se pudo generar el link con mi ID"
fi


# Intento activar la app con el link generado previamente
CURL_OUTPUT=$(curl --silent ${LINK}                                            \
                --data-raw 'submite=Pulsa+aqu%C3%AD+para+activar')

# Si curl no retorna 0, entonces hubo un error en la conexion
if [ $? -ne "0" ]; then 
    STATUS="SplikTV: link generado correctamente, pero hubo un error en la activacion"
else

    # Busco si realmente se ha activado
    grep -q 'Activado' <<< "${CURL_OUTPUT}"

    # Si grep() retorna 0, entonces se pudo activar correctamente
    if [ $? -eq "0" ]; then
        STATUS="SplikTV: activado correctamente!"
    else      
        # Sino, busco si ya habia sido activado previamente  
        grep -q 'activaste' <<< "${CURL_OUTPUT}"
        if [ $? -eq "0" ]; then
            STATUS="SplikTV: ya habia sido activado"
        else
            STATUS="SplikTV: conexion realizada pero no se pudo activar"
        fi
    fi
fi

echo "${STATUS}"
sendMessage "text:${STATUS}" > /dev/null