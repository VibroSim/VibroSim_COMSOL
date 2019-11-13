function example_physics(M,geom,specimen,flaw)

% In a physicsfunc, create each physics and corresponding studies

% Create first SolidMechanics for static deformation study
addprop(M,'solidmech_static');
M.solidmech_static=CreatePhysics(M,geom,'solidmech_static','SolidMechanics'); % note: displacements are solidmech_staticu, solidmech_staticv, solidmech_staticw
M.solidmech_static.node.prop('EquationForm').setIndex('form', 'Stationary', 0);

% Create boundary conditions for solidmech_static 
BuildBoundaryConditions(M,geom,M.solidmech_static,'solidmech_static');

% Define stationary study
stationarystudy=CreateStudy(M,geom,'stationarystudy');
stationarystep=StudyAddStep(M,geom,stationarystudy,'stationarystudy_step','Stationary',M.solidmech_static);
stationarystep.node.set('geometricNonlinearity','on');

% Create custom solution for stationary step
stationarysolution=CreateSolution(M,stationarystudy,'stationarystudy_solution',stationarystep,'Stationary');
stationarysolution.solutionsolver.node.set('nonlin','on');

% Select BC's once all Physicses have been created
RunLater(M,'rl_stationarystudy','select_boundaryconditions', ...
	 @(M,rlobj) ...
	 SelectBoundaryConditionsForStudy(M,stationarystudy,{'continuities','staticloading'})); % Activate boundary conditions of specified classes






% Create second solidmechanics, for harmonic perturbation
addprop(M,'solidmech_harmonicper');
M.solidmech_harmonicper=CreatePhysics(M,geom,'solidmech_harmonicper','SolidMechanics');
M.solidmech_harmonicper.node.prop('EquationForm').setIndex('form', 'Frequency', 0);
% Boundary conditions
BuildBoundaryConditions(M,geom,M.solidmech_harmonicper,'solidmech_harmonicper'); % apply boundary condtions

% Initial conditions for harmonic perturbation: Initial values based on result of static study
initstrainvals={'solidmech_static.eX','solidmech_static.eXY','solidmech_static.eXZ','solidmech_static.eXY','solidmech_static.eY','solidmech_static.eYZ','solidmech_static.eXZ','solidmech_static.eYZ','solidmech_static.eZ'};
initdisplvals={'solidmech_staticu','solidmech_staticv','solidmech_staticw'};
SolidMechanics_SetInitialStrain(M,M.solidmech_harmonicper,initstrainvals);
SolidMechanics_SetInitialDisplacement(M,M.solidmech_harmonicper,initdisplvals);

% Create harmonic study for harmonic perturbation
freqstart=ObtainDCParameter(M,'simulationfreqstart','Hz');
freqstep=ObtainDCParameter(M,'simulationfreqstep','Hz');
freqend=ObtainDCParameter(M,'simulationfreqend','Hz');
freqrange=[ 'range(' freqstart ',' freqstep ',' freqend ')' ];


harmonicperstudy=CreateStudy(M,geom,'harmonicperstudy');
harmonicperstep=StudyAddFrequencyStep(M,geom,harmonicperstudy, ...
				      'harmonicperstudy_step', ...
				      freqrange, ...
				      M.solidmech_harmonicper,M.solidmech_static); % both solidmech_harmonicper and solidmech_static are turned on...
StudyStepEnablePhysicsInSolvers(M,harmonicperstep,solidmech_static,false); % ... but solidmech_static is not to be solved)

harmonicperstep.node.set('geometricNonlinearity','on');
harmonicperstep.node.set('usesol','on'); % Set 'Use Solution Method' on
harmonicperstep.node.set('notsolmethod','sol'); % Set dependent variable selection to 'sol', not 'init'
harmonicperstep.node.set('notstudy',stationarystudy.tag); % tag for study to be used to set dependent variables

% Create custom solution for frequency domain study
% Set up solver so that the harmonicper study is a linear perturbation solution linearized about the output of stationarystep
freqsolution=CreateSolution(M,harmonicperstudy,'harmonicperstudy_solution',harmonicperstep,'Stationary');
freqsolution.solutionsolver.node.set('nonlin','linper');  % This makes the harmonicperstep a linear perturbation linearized around the stationary step
freqsolution.solutionsolver.node.set('linpmethod','sol');
freqsolution.solutionsolver.node.set('linpsol',stationarysolution.tag);
freqsolution.solutionsolver.node.set('storelinpoint','on');

% Select BC's once all Physicses have been created
RunLater(M,'rl_harmonicperstudy','select_boundaryconditions', ...
	 @(M,rlobj) ...
	 SelectBoundaryConditionsForStudy(M,harmonicperstudy,{'continuities','excitation','fixedisolators'})); % Activate boundary conditions of specified classes







ObtainDCParameter(M,'simulationtimestart');
ObtainDCParameter(M,'simulationtimestep');
ObtainDCParameter(M,'simulationtimeend');

% Create heat transfer physics
addprop(M,'heatflow');
M.heatflow=CreatePhysics(M,geom,'heatflow','HeatTransfer');
M.heatflow.node.prop('EquationForm').setIndex('form', 'Transient', 0);

BuildBoundaryConditions(M,geom,M.heatflow,'heatflow'); % apply boundary condtions



% Define time-domain study for heat transfer
heatflowstudy=CreateStudy(M,geom,'heatflowstudy');
heatflowstudy_step=StudyAddStep(M,geom,heatflowstudy,'heatflowstudy_step','Transient',M.heatflow);
heatflowstudy_step.node.set('tlist','range(simulationtimestart,simulationtimestep,simulationtimeend)');



% Select BC's once all Physicses have been created
RunLater(M,'rl_heatflowstudy','select_boundaryconditions', ...
	 @(M,rlobj) ...
	 SelectBoundaryConditionsForStudy(M,heatflowstudy,{'crackheating','continuities'})); % Activate boundary conditions of specified classes


% Create solution for heatflow step
heatflow_solution=CreateSolution(M,heatflowstudy,'heatflow_solution',heatflowstudy_step,'Time');

% model.physics('ht').feature.create('bhs1', 'BoundaryHeatSource', 2);
% model.physics('ht').feature('bhs1').selection.set([7]);
% model.physics('ht').feature('bhs1').set('Qb', '100');



% Note: When viewing 3D plot of frequency domain study, you must
%   * Plot a quantity that actually exists (the default does not)
%   * Enable the 'differential' option in the plot
