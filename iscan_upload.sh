#!/bin/bash

typeset -A CONFIG
CONFIG=(
    [AUTH_TOKEN_PATH]=""
    [ISCAN_DIR]=""
    [UPLOAD_AGENT_PATH]=""
    [DX_PROJECT_ID]=""
    [ARCHIVE_DIR]=""
)

while read LINE;
do
    if echo $LINE | grep -F = &>/dev/null
    then
        VARNAME=$(echo "$LINE" | cut -d '=' -f 1)
        CONFIG[$VARNAME]=$(echo "$LINE" | cut -d '=' -f 2-)
    fi
done < $ISCAN_CONFIG_PATH 

for DATA_SUBDIR in GS_*; do
    ${CONFIG[UPLOAD_AGENT_PATH]}/ua \
        --auth-token $(cat ${CONFIG[AUTH_TOKEN_PATH]}) \
        --recursive \
        --project=${CONFIG[DX_PROJECT_ID]} \
        ${CONFIG[ISCAN_DIR]}/${DATA_SUBDIR}
done

# move all to archive
for DATA_SUBDIR in GS_*; do
    # make it if it doesn't exist
    mkdir -p ${CONFIG[ARCHIVE_DIR]}/${DATA_SUBDIR}
    mv ${CONFIG[ISCAN_DIR]}/${DATA_SUBDIR}/* ${CONFIG[ARCHIVE_DIR]}/${DATA_SUBDIR}/
done
