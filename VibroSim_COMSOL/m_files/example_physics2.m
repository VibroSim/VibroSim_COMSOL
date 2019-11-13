function example_physics(M,geom,specimen,flaw)

% In a physicsfunc, create each physics and corresponding studies

% Create physics and study/step/solution for independent (non-perturbation) modal analysis
addprop(M,'solidmech_modal');
M.solidmech_modal=CreateVibroModal(M,geom,'solidmech_modal');


% Create physics and study/step/solution for static deformation
addprop(M,'solidmech_static');
M.solidmech_static=CreateVibroStatic(M,geom,'solidmech_static');



% Create physics and study/step/solution for harmonic perturbation around the static solution

freqstart=ObtainDCParameter(M,'simulationfreqstart','Hz');
freqstep=ObtainDCParameter(M,'simulationfreqstep','Hz');
freqend=ObtainDCParameter(M,'simulationfreqend','Hz');
freqrange=[ 'range(' freqstart ',' freqstep ',' freqend ')' ];


addprop(M,'solidmech_harmonicper');
M.solidmech_harmonicper=CreateVibroHarmonicPer(M,geom,M.solidmech_static, ...
					       'solidmech_harmonicper', ...
					       freqrange, ...
					       false,true);


% Create physics and study/step/solution for independent (non-perturbation) harmonic analysis
addprop(M,'solidmech_harmonic');
M.solidmech_harmonic=CreateVibroHarmonic(M,geom,'solidmech_harmonic',freqrange);






% Create heat transfer physics
addprop(M,'heatflow');
% It pulls vibration data from the first element of of the solidmech_harmonic
% study. 
M.heatflow=CreateVibroHeatFlow(M,geom,'heatflow',M.solidmech_harmonic,1);


% model.physics('ht').feature.create('bhs1', 'BoundaryHeatSource', 2);
% model.physics('ht').feature('bhs1').selection.set([7]);
% model.physics('ht').feature('bhs1').set('Qb', '100');



% Note: When viewing 3D plot of frequency domain study, you must
%   * Plot a quantity that actually exists (the default does not)
%   * Enable the 'differential' option in the plot
