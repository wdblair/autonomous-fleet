Final Project CS640 README
==========================

This repo contains the code needed to run our final project.

Dependencies
============

- Matlab 2013b 
- FlightGear (v 2.12+)

Instructions
============

In the single-agent directory, run the install.sh file to install
all the necessary files to the FlightGear directory. You will need
to find where your FlightGear data directory is before hand and edit
the FG_ROOT variable in install.sh.

Once FlightGear is installed, you can open up Matlab in the planner
directory and run "exampleRun.m" which will demonstrate our Matlab
system starting and guiding the single agent through takeoff and cruising
to a destination airport.

Unfortunately, if you're not running this on a Mac, the run-fg.sh script
may not work as we needed to hardcode the location of the Flightgear executable.
To replace it with the path your Flightgear is located, run

    which fgfs

and put the output into planner/run-fg.sh.