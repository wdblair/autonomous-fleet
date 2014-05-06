777 Autopilot
=============

These are the configuration files needed for our 777 auto pilot
written using FlightGear's internal scripting language, Nasal.

In order to install these files, set the FG_ROOT environment variable
to point to your FlightGear data directory.

For Linux, the path will vary, but it will likely be somewhere in /usr/share

    export FG_ROOT=/usr/share/flightgear/data

For MacOS X, use the following

    export FG_ROOT=/Applications/Flightgear.app/Contents/Resources/data

Running
=======

The planner will do all of this for you, so there's no need to follow
these steps your self. Nonetheless, here are the steps to get the plane
in the air.

Once the files are in place, you can try it out with

    fgfs --aircraft=777-200

Begin takeoff with the following

- Open Debug -> Browse Internal Properties
- Set /uav/planner/mode to "to/ga"