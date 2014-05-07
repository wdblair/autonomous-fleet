#!/bin/bash

# On Linux: Run as root to install the files in the right place for
# FlightGear

# On Mac: You don't need to be root to run this

# For Linux (the path varies)
# export FG_ROOT=/usr/share/flightgear/data

# For MacOS X
# export FG_ROOT=/Applications/Flightgear.app/Contents/Resources/data

FG_ROOT=/usr/share/games/flightgear

cp ./777-autopilot-uav.xml $FG_ROOT/Aircraft/777-200/Systems/777-autopilot-uav.xml
cp ./uav.nas $FG_ROOT/Aircraft/777-200/Nasal/uav.nas

sed -i '/<b777>/ a\
\<file\>Aircraft/777/Nasal/uav.nas\<\/file\>' $FG_ROOT/Aircraft/777-200/777-200ER-set.xml

sed -i '/systems.xml\<\/path\>/ a\
\<autopilot\><path\>Aircraft/777/Systems/777-autopilot-uav.xml\<\/path\>\<\/autopilot\>' $FG_ROOT/Aircraft/777-200/777-200ER-set.xml
