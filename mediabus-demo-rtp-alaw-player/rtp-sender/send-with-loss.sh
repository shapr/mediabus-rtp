#!/bin/bash

PORT=${1?port missing}
MY_IP=${2?host ip missing}
DROPPROP=${3?Drop probability missing}
FNAME=${4:-28797-04.ogg}
FILE=$(realpath $(dirname ${0})/$FNAME)

gst-launch-1.0  uridecodebin uri=file://$FILE ! \
                queue ! \
                audioconvert ! \
                audioresample ! \
                audio/x-raw,format=S16LE,rate=8000,channels=1 ! \
                alawenc ! \
                rtppcmapay pt=8 \
                      min-ptime=10000000 \
                      max-ptime=200000000 \
                      ptime-multiple=10000000 ! \
                identity drop-probability="$DROPPROP" ! \
                udpsink host=$MY_IP port=$PORT
