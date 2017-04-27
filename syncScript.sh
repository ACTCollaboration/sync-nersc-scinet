#/bin/bash

# Highly recommended that the following DEL_FLAG flag is kept commented. Only enable it if you are sure
# that the destination directories on Cori are correct and that no unrelated files will be
# removed.
#DEL_FLAG="--delete"

cd "$(dirname "$0")"
source sync_common.sh
SCI_SYNC_USER="$(trimWhite $(cat config/scinetUserName))"


while IFS=, read INSRC_DIR INDEST_DIR
do

    SRC_DIR="$(trimWhite $INSRC_DIR)"
    DEST_DIR="$(trimWhite $INDEST_DIR)"
    case "$SRC_DIR" in \#*) continue ;; esac  # ignore comments
    if [ -z "$SRC_DIR" ]; then continue ; fi  # ignore empty
    if [ -z "$DEST_DIR" ]; then continue ; fi # ignore empty
    nohup rsync -azPvL -e "ssh -A -o IdentityFile=~/.ssh/id_scinet_Oct1816.pub $SCI_SYNC_USER@login.scinet.utoronto.ca ssh -A " datamover1:$SRC_DIR/ $DEST_DIR $DEL_FLAG > rsyncCommand.log 2>&1 &
    wait
    
done <$1


