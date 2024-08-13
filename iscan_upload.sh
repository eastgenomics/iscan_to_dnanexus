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


# The upload agent (ua) uploads all files it can find with a recursive search,
# which is why we point it at subdirectories instead of individual files.
#
# The search is restricted to sites with "GS_" as a prefix, so we don't 
# accidentally upload non-iScan data to DNANexus.
#
# If the upload agent (ua) throws an error, it'll do so by returning a non-zero
# exit code. We don't want to archive any data that didn't get uploaded for
# whatever reason, so we terminate the process if an error is thrown.
for DATA_SUBDIR in ${CONFIG[ISCAN_DIR]}/GS_*; do
    SUBDIR_NAME=$(basename $DATA_SUBDIR)
    ${CONFIG[UPLOAD_AGENT_PATH]}/ua \
        --auth-token $(cat ${CONFIG[AUTH_TOKEN_PATH]}) \
        --recursive \
        --project=${CONFIG[DX_PROJECT_ID]} \
        ${CONFIG[ISCAN_DIR]}/${SUBDIR_NAME}
    if [ $? != 0 ]; then
        echo "ERROR - SEE LOGS"
        exit 1
    fi
done

# When the upload is confirmed, all data is moved to an archive directory.
# There is no actual process for archiving yet, so all we do is move
# files from the upload directories to an uncompressed "archive" directory
# somewhere else on the system. This is defined in the config.
echo "Archiving data..."
for DATA_SUBDIR in ${CONFIG[ISCAN_DIR]}/GS_*; do
    SUBDIR_NAME=$(basename $DATA_SUBDIR)
    mkdir -p ${CONFIG[ARCHIVE_DIR]}/${SUBDIR_NAME}
    mv ${CONFIG[ISCAN_DIR]}/${SUBDIR_NAME}/* ${CONFIG[ARCHIVE_DIR]}/${SUBDIR_NAME}/
done
echo "done"
