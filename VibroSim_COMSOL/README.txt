VibroSim: A Vibrothermography Simulation Engine
-----------------------------------------------

VibroSim is a set of MATLAB scripts for creating COMSOL 
simulations of the vibrothermography process. 

PLEASE NOTE THAT VIBROSIM HAS NOT BEEN ADEQUATELY VALIDATED,
THE NUMBERS BUILT INTO IT ALMOST CERTAINLY DO NOT APPLY
TO YOUR VIBROTHERMOGRAPHY PROCESS. ITS OUTPUT CANNOT BE 
TRUSTED AND IS NOT SUITABLE FOR ENGINEERING REQUIREMENTS
WITHOUT APPLICATION- AND PROCESS-SPECIFIC VALIDATION. 

Requirements
------------
COMSOL 5.0 or newer. Tested with COMSOL 5.0 and 5.2
MATLAB (the correct version for your COMSOL)
LiveLink for MATLAB

Depending on your source of geometry, you may want to also
have COMSOL's CAD Import Module

Documentation
-------------
See the file doc/VibroSim.pdf for primary documentation
See the file doc/Reference.pdf for (partial) API/function documentation

If you have a source distribution that does not include these
files, the DocBook source files are in doc/UserGuide/. The printed
documentation can be built using doc/Makefile via the commands 
"make VibroSim.pdf" and "make Reference.pdf"

Installation
------------
1. Install MATLAB
2. Install COMSOL with MATLAB LiveLink, being sure to correctly
   identify your MATLAB installation
3. Unzip the VibroSim archive to a convenient location
4. (Linux platforms) Check the setting of the MATLABDIR parameter 
   inside the "comsolmatlab" script in the VibroSim archive, then 
   run the "comsolmatlab" script in the VibroSim archive 
4. (Other Platforms) Run "COMSOL with MATLAB", then add the VibroSim directory
   to MATLAB's function path and the following subdirectories: 
     conf/
     definitions/ 
     geometry/
     material/ 
     mesh/ 
     physics/ 
     results/ 
     study/
     support/
     util/ 

Running COMSOL
--------------

You need to run COMSOL server, 

"comsol server -mlroot /usr/local/matlab -forcegcc"
or 
comsol server -mlroot /usr/local/matlab -forcegcc matlab
