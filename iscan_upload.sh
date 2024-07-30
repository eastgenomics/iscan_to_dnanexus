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

for DATA_SUBDIR in ${CONFIG[ISCAN_DIR]}/GS_*; do
    SUBDIR_NAME=$(basename $DATA_SUBDIR)
    ${CONFIG[UPLOAD_AGENT_PATH]}/ua \
        --auth-token $(cat ${CONFIG[AUTH_TOKEN_PATH]}) \
        --recursive \
        --project=${CONFIG[DX_PROJECT_ID]} \
        ${CONFIG[ISCAN_DIR]}/${SUBDIR_NAME}
done

# move all to archive
echo "Archiving data..."
for DATA_SUBDIR in ${CONFIG[ISCAN_DIR]}/GS_*; do
    SUBDIR_NAME=$(basename $DATA_SUBDIR)
    # make it if it doesn't exist
    mkdir -p ${CONFIG[ARCHIVE_DIR]}/${SUBDIR_NAME}
    mv ${CONFIG[ISCAN_DIR]}/${SUBDIR_NAME}/* ${CONFIG[ARCHIVE_DIR]}/${SUBDIR_NAME}/
done
echo "done"
