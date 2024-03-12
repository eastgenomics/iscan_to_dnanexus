#!/bin/bash

typeset -A CONFIG
CONFIG=(
    [AUTH_TOKEN_PATH]=""
    [ISCAN_DIR]=""
    [UPLOAD_AGENT_PATH]=""
    [DX_PROJECT_ID]=""
)

while read LINE;
do
    if echo $LINE | grep -F = &>/dev/null
    then
        VARNAME=$(echo "$LINE" | cut -d '=' -f 1)
        CONFIG[$VARNAME]=$(echo "$LINE" | cut -d '=' -f 2-)
    fi
done < iscan_upload.conf

for DATA_SUBDIR in GS_reports GS_projects; do
    ${CONFIG[UPLOAD_AGENT_PATH]}/ua \
        --auth-token $(cat ${CONFIG[AUTH_TOKEN_PATH]}) \
        --recursive \
        --project=${CONFIG[DX_PROJECT_ID]} \
        ${CONFIG[ISCAN_DIR]}/${DATA_SUBDIR}
done
