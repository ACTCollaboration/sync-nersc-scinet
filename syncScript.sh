#/bin/bash

# Highly recommended that the following DEL_FLAG flag is kept commented. Only enable it if you are sure
# that the destination directories on Cori are correct and that no unrelated files will be
# removed.
#DEL_FLAG="--delete"

cd "$(dirname "$0")"
source sync_common.sh
SCI_SYNC_USER="$(trimWhite $(cat scinetUserName))"


while IFS=, read INSRC_DIR INDEST_DIR
do

    SRC_DIR="$(trimWhite $INSRC_DIR)"
    DEST_DIR="$(trimWhite $INDEST_DIR)"
    case "$SRC_DIR" in \#*) continue ;; esac
    if [ -z "$SRC_DIR" ]; then continue ; fi
    if [ -z "$DEST_DIR" ]; then continue ; fi
    nohup rsync -azPvL -e "ssh -A -vvv $SCI_SYNC_USER@login.scinet.utoronto.ca ssh -A -vvv " datamover1:$SRC_DIR/ $DEST_DIR $DEL_FLAG > syncScript.log 2>&1 &

    
done <$1


