%> @param mode: 'modal', 'static', 'harmonicsweep', 'harmonicburst', 'heatflow', 'broadbandprocess', 'welderprocess', 'timedomain', or 'all'

function M = VibroPhysics(M,geom,specimen,flaw_notused,mode,use_impulse_force_excitation)
% 
% There are two tracks mode can be set:
%
% 1. Individual physics keywords separated with '|'
%   - modal
%   - static 
%   - harmonicsweep
%   - multisweep
%   - harmonicburst
%   - heatflow
%   - timedomain
%
% 2. Combination keywords, (primarily for backwards compatibility)
%   - broadbandprocess
%   - welderprocess
%   - all

if ~exist('use_impulse_force_excitation','var')
  use_impulse_force_excitation=false;
end


% Make a flag for each of the options, initialize to false 
modal               = false ; 
static              = false ;
harmonicsweep       = false ;
multisweep          = false ; 
harmonicburst       = false ;
heatflow            = false ;
timedomain   = false ;
%vibroheatconvert    = false ;

broadbandprocess    = false ;
welderprocess       = false ;
all                 = false ;

% Split the mode string at the |'s
modes = strsplit( mode , '|') ;

if any(strcmp('welder_timedomain',modes))
   error('welder_timedomain parameter has been changed to just timedomain')
   
end

% Raise a physics flag if the string matches in modes
modal               = any(strcmp('modal',modes)) ;
static              = any(strcmp('static',modes)) ;
harmonicsweep       = any(strcmp('harmonicsweep',modes)) ;
multisweep       = any(strcmp('multisweep',modes)) ;
harmonicburst       = any(strcmp('harmonicburst',modes)) ;
heatflow            = any(strcmp('heatflow',modes)) ;
timedomain          = any(strcmp('timedomain',modes)) ;
%vibroheatconvert    = any(strcmp('vibroheatconvert',modes)) ;

broadbandprocess    = any(strcmp('broadbandprocess',modes)) | any(strcmp('process',modes)); % backward compatibility: "process" as a synonym for "broadbandprocess

welderprocess       = any(strcmp('welderprocess',modes)) ;
all                 = any(strcmp('all',modes)) ;



% Raise the flags for the process keyword
if broadbandprocess ;
    harmonicsweep = 1 ;
    modal = 1 ;
    harmonicburst = 1 ;
    heatflow = 1 ;
%    vibroheatconvert = 1 ;
end

if welderprocess ;
    modal = 1 ;
    multisweep = 1 ;
    heatflow = 1 ;
%    vibroheatconvert = 1 ;
end

% Raise the flags for the all keyword
if all ;
    modal = 1 ; 
    timedomain = 1 ;
    static = 1 ;
    harmonicsweep = 1 ;
    multisweep = 1 ;
    harmonicburst = 1 ;
%    vibroheatconvert = 1 ;
    heatflow = 1 ;
end

% Execute the options
if modal ; 
  % Create physics and study/step/solution for independent (non-perturbation) modal analysis
  addprop(M,'solidmech_modal');
  M.solidmech_modal=CreateVibroModal(M,geom,'solidmech_modal');
end

if timedomain
  % Create time domain model
  addprop(M,'solidmech_timedomain');
  M.solidmech_timedomain=CreateVibroTimeDomain(M,geom,'solidmech_timedomain');
end

if static
  % Create physics and study/step/solution for static deformation
  addprop(M,'solidmech_static');
  M.solidmech_static=CreateVibroStatic(M,geom,'solidmech_static');
end


% % Create physics and study/step/solution for harmonic perturbation around the static solution
% addprop(M,'solidmech_harmonicper');
% M.solidmech_harmonicper=CreateVibroHarmonicPer(M,geom,M.solidmech_static,'solidmech_harmonicper');


if harmonicsweep
  % Create physics and study/step/solution for independent (non-perturbation) harmonic analysis
  freqstart=ObtainDCParameter(M,'simulationfreqstart','Hz');
  freqstep=ObtainDCParameter(M,'simulationfreqstep','Hz');
  freqend=ObtainDCParameter(M,'simulationfreqend','Hz');
  freqrange=[ 'range(' freqstart ',' freqstep ',' freqend ')' ];
  

  addprop(M,'solidmech_harmonicsweep');
  M.solidmech_harmonicsweep=CreateVibroHarmonic(M,geom,'solidmech_harmonicsweep',freqrange);
end


if multisweep
  % Create physics and study/step/solution for independent (non-perturbation) harmonic analysis
  seg1_freqstart=ObtainDCParameter(M,'seg1_freqstart','Hz');
  seg1_freqstep=ObtainDCParameter(M,'seg1_freqstep','Hz');
  seg1_freqend=ObtainDCParameter(M,'seg1_freqend','Hz');
  seg1_freqrange=[ 'range(' seg1_freqstart ',' seg1_freqstep ',' seg1_freqend ')' ];

  seg2_freqstart=ObtainDCParameter(M,'seg2_freqstart','Hz');
  seg2_freqstep=ObtainDCParameter(M,'seg2_freqstep','Hz');
  seg2_freqend=ObtainDCParameter(M,'seg2_freqend','Hz');
  seg2_freqrange=[ 'range(' seg2_freqstart ',' seg2_freqstep ',' seg2_freqend ')' ];


  seg3_freqstart=ObtainDCParameter(M,'seg3_freqstart','Hz');
  seg3_freqstep=ObtainDCParameter(M,'seg3_freqstep','Hz');
  seg3_freqend=ObtainDCParameter(M,'seg3_freqend','Hz');
  seg3_freqrange=[ 'range(' seg3_freqstart ',' seg3_freqstep ',' seg3_freqend ')' ];

  seg4_freqstart=ObtainDCParameter(M,'seg4_freqstart','Hz');
  seg4_freqstep=ObtainDCParameter(M,'seg4_freqstep','Hz');
  seg4_freqend=ObtainDCParameter(M,'seg4_freqend','Hz');
  seg4_freqrange=[ 'range(' seg4_freqstart ',' seg4_freqstep ',' seg4_freqend ')' ];
  

  addprop(M,'solidmech_multisweep');
  M.solidmech_multisweep=CreateVibroMultiSweep(M,geom,'solidmech_multisweep',seg1_freqrange,seg2_freqrange,seg3_freqrange,seg4_freqrange);
end




if harmonicburst
  % Create physics and study/step/solution for independent (non-perturbation) harmonic analysis
  addprop(M,'solidmech_harmonicburst');
  M.solidmech_harmonicburst=CreateVibroHarmonic(M,geom, ...
						'solidmech_harmonicburst', ...
						ObtainDCParameter(M,'simulationburstfreq','Hz'));
end


%if vibroheatconvert
%  % Create weak-form pde physics for accelerating transfer of MATLAB-calculated 
%  % heating values into heat flow model
 
%  % To disable weak-form pde acceleration, comment out these two lines and change the 'vibroheatconvert' parameter to CreateCrack() to [].
%  addprop(M,'vibroheatconvert');
%  M.vibroheatconvert=CreateVibroHeatConvert(M,geom,'vibroheatconvert',M.solidmech_harmonicburst,1);
%end

if heatflow
  % Create heat transfer physics

  addprop(M,'heatflow');

  %if isprop(M,'vibroheatconvert')
  %  M.heatflow=CreateVibroHeatFlow(M,geom,'heatflow',M.solidmech_harmonicburst,1,M.vibroheatconvert);
  %else
  %  M.heatflow=CreateVibroHeatFlow(M,geom,'heatflow',M.solidmech_harmonicburst,1);
  %end

  M.heatflow=CreateVibroHeatFlow(M,geom,'heatflow');
end
