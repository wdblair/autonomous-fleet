#!/bin/bash

# On Linux: Run as root to install the files in the right place for
# FlightGear

# On Mac: You don't need to be root to run this

# For Linux (the path varies)
# FG_ROOT=/usr/share/games/flightgear

# For MacOS X
# FG_ROOT=/Applications/Flightgear.app/Contents/Resources/data

FG_ROOT=/usr/share/games/flightgear

cp ./777-autopilot-uav.xml $FG_ROOT/Aircraft/777/Systems/777-autopilot-uav.xml
cp ./uav.nas $FG_ROOT/Aircraft/777/Nasal/uav.nas

cp ./actuator_protocol.xml $FG_ROOT/Protocol/
cp ./sensor_protocol.xml $FG_ROOT/Protocol/

# Add our Nasal code into the 777 configuration.
sed -i '/<b777>/ a\
\<file\>Aircraft/777/Nasal/uav.nas\<\/file\>' $FG_ROOT/Aircraft/777/777-set-common.xml

# Add our custom autopilot to the 777 autopilots.
sed -i '/systems.xml\<\/path\>/ a\
\<autopilot\><path\>Aircraft/777/Systems/777-autopilot-uav.xml\<\/path\>\<\/autopilot\>' $FG_ROOT/Aircraft/777/777-set-common.xml
