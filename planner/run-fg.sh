#!/bin/bash

/Applications/Flightgear.app/Contents/MacOS/fgfs ${@:2} &

pid=$!

echo $pid > $1.pid
