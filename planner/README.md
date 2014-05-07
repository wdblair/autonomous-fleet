Information:
===========================
This folder contains all of the files required to run the planning software. 
To start, please download the folder and extract. Start MATLAB, and change to the downloaded folder. 

Possible Run Styles:<br>
(1) To run a full simulation:<br>
     
    fgSim('ifSim',1)

(2) To run an example of a single MATLAB/Client communication:
    
    'exampleRun'

(3) To run a full planner without Flightgear agents:
     	
    fgSim('ifSim',0)

Please note: (1) and (2) require that you install the single agent files first. (1) and (3) have a start up time of about 4 minutes, due to calculating minimum paths. 

Dependencies:
===========================
<br>
(1) MATLAB: Code was written in 2013b and tested in 2013b & 2012a. However, the code should be compatible with 2011a onwards.<br>
<br>
(2) Toolboxes: The following toolboxes are used. A standard BU checkout of MATLAB includes all of these:<br>
	- Image Processing Toolbox<br>
	- Signals Processing Toolbox<br>
	- Mapping Toolbox<br>


