#/bin/bash

cd "$(dirname "$0")"
source sync_common.sh

NERSC_SYNC_USER="$(trimWhite $(cat config/nerscUserName))"
NERSC_DIR="$(trimWhite $(cat config/nerscPath))"

ssh -A $NERSC_SYNC_USER@cori.nersc.gov "$NERSC_DIR/syncScript.sh $NERSC_DIR/listForSync.txt"
#ssh -A $NERSC_SYNC_USER@edison.nersc.gov "$NERSC_DIR/syncScript.sh $NERSC_DIR/listForSync.txt"
