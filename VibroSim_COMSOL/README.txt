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
3. Within MATLAB go to File...Open and browse to VibroSim_COMSOL.mltbx 
   and open it. Select 'Install'. You can manage it with MATLAB's 
   add-on manager. By default it will be placed under your 
   Documents/MATLAB folder. 
4. Alternate install: 
    * Unzip the .mltbx file (it is actually a ZIP archive) 
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
1. Make sure all changes have been committed to git
    * Including an update to the new version number in VibroSim_COMSOL.prj
2. Tag the version with the new version number (e.g. v0.3.2)
3. Run git status --ignored to check for ignored files. Make sure
   all ignored files are either deleted or added to the repository
   as appropriate. (VibroSim_COMSOL.mltbx should be deleted)
4. From the base directory of this package, run: 
      matlab VibroSim_COMSOL.prj
5. Explicitly add the m_files subfolder to MATLAB's path
      path('VibroSim_COMSOL/m_files',path);
6. Double click on VibroSim_COMSOL.prj on the left (file list)
7. Make sure under "Install Actions" the m_files subfolder is
   explicitly included in the MATLAB Path
8. Press Package...Package.
9. Check changes to VibroSim_COMSOL.prj to make sure they are not substantive
   probably want to 'git checkout VibroSim_COMSOL.prj' to revert them because
   MATLAB likes to add in absolute paths
