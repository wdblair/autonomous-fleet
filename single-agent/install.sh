#!/bin/bash

# On Linux: Run as root to install the files in the right place for
# FlightGear

# On Mac: You don't need to be root to run this

# For Linux (the path varies)
# export FG_ROOT=/usr/share/flightgear/data

# For MacOS X
# export FG_ROOT=/Applications/Flightgear.app/Contents/Resources/data

ln -s $PWD/777-autopilot-uav.xml $FG_ROOT/Aircraft/777/Systems/777-autopilot-uav.xml
ln -s $PWD/uav.nas $FG_ROOT/Aircraft/777/Nasal/uav.nas

sed -i .bak '/<b777>/ a\
\<file\>Aircraft/777/Nasal/uav.nas\<\/file\>' $(FG_ROOT)/Aircraft/777/777-set-common.xml

sed -i .bak '/systems.xml\<\/path\>/ a\
\<autopilot\><path\>Aircraft/777/Systems/777-autopilot-uav.xml\<\/path\>\<\/autopilot\>' $(FG_ROOT)/Aircraft/777/777-set-common.xml
