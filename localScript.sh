#/bin/bash

cd "$(dirname "$0")"
source sync_common.sh

NERSC_SYNC_USER="$(trimWhite $(cat nerscUserName))"
NERSC_DIR="$(trimWhite $(cat nerscPath))"

ssh $NERSC_SYNC_USER@cori "$NERSC_DIR/syncScript.sh $NERSC_DIR/syncList.txt"
