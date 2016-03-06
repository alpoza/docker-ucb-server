#!/bin/bash

set -e

if [ "$1" = 'ucb' ]; then

exec /opt/ibm-ucd/server/bin/server run

elif [ "$1" = 'sleep' ]; then

while true; do
echo "running sleep";
sleep 10;
done;

fi;

