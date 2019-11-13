VibroSim: A Vibrothermography Simulation Engine
-----------------------------------------------

VibroSim is a set of MATLAB scripts for creating COMSOL 
simulations of the vibrothermography process. 

PLEASE NOTE THAT VIBROSIM MAY NOT HAVE BEEN ADEQUATELY 
VALIDATED, THE NUMBERS BUILT INTO IT ALMOST CERTAINLY 
DO NOT APPLY TO YOUR VIBROTHERMOGRAPHY PROCESS. ITS OUTPUT 
CANNOT BE TRUSTED AND IS NOT SUITABLE FOR ENGINEERING 
REQUIREMENTS WITHOUT APPLICATION- AND PROCESS-SPECIFIC 
VALIDATION. 

Requirements
------------
COMSOL 5.4 or newer. Tested with COMSOL 5.4
MATLAB (the correct version for your COMSOL)
LiveLink for MATLAB
COMSOL Structural Mechanics module

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
3. Within MATLAB go to File...Open and browse to VibroSim_COMSOL.mtlbx 
   and open it. Select 'Install'. You can manage it with MATLAB's 
   add-on manager. By default it will be placed under your 
   Documents/MATLAB folder. 
4. Alternate install: 
    * Unzip the .mtlbx file (it is actually a ZIP archive) 
    * Add the VibroSim_COMSOL folder and the VibroSim_COMSOL/m_files
      folders WITHIN the unzipped toolbox to your MATLAB path. 

Running COMSOL
--------------

Follow the instructions outlined in the manual for COMSOL's LiveLink
for Matlab. In summary you need to run the COMSOL server
("comsolmphserver" (Windows) or "comsol mphserver" on the command line)
and Matlab in the same session. To satisfy licensing requirements
you may need to run MATLAB, COMSOL server, and (optionally) COMSOL
client all from the same terminal. 

For Linux/Macintosh platforms a convenience script "comsolmatlab" 
is included within the toolbox folder that starts MATLAB, 
COMSOL server and COMSOL client all together. If you just want to 
run MATLAB and comsolserver, then "comsol mphserver matlab" 
should do the trick. 


Rebuilding .mltbx file from source
----------------------------------
Open VibroSim_COMSOL.prj in Matlab and press Package...Package.

