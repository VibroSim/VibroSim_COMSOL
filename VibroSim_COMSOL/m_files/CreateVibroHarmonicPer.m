%> Create physics, study, step, and solutin for a harmonic perturbation vibration analysis
%> for Vibrothermography given a static analysis (solidmech_static)
%>
%> Parameters
%> ----------
%> @param M:                  ModelWrapper around top level model
%> @param geom:               Wrapped top level geometry
%> @param solidmech_static:   Wrapped static physics analysis to perturb
%> @param tag:                Tag for physics to create. Should usually be
%>                            'solidmech_harmonicper'
%> @param freqrange:          Single frequency or range of frequencies to use.
%>                            can be 'range(freqstart,freqstep,freqend)'
%> @param crackdiscontinuity: Optional boolean, default false. If false the crack
%>                            face boundary conditions are continuity conditions.
%>                            If true, the thin elastic layer BC is used.
%> @param nonlinear:          Optional boolean, default false. If false the problem
%>                            is presumed to be linear. If true, geometric nonlineary
%>                            is considered.
%>
%> If optional nonlinear parameter is true, then enable
%> geometric nonlinearity and nonlinear solver.
function solidmech_harmonicper=CreateVibroHarmonicPer(M,geom,solidmech_static,tag,freqrange,crackdiscontinuity,nonlinear)

if ~exist('crackdiscontinuity','var')
  crackdiscontinuity=false;
end


if ~exist('nonlinear','var')
  nonlinear=false;
end


% Create physics for harmonic perturbation
solidmech_harmonicper=CreatePhysics(M,geom,tag,'SolidMechanics');

addprop(solidmech_harmonicper,'timedomain');
solidmech_harmonicper.timedomain=false;

% Fix equation form to frequency domain
solidmech_harmonicper.node.prop('EquationForm').setIndex('form', 'Frequency', 0);

% Add damping to default linear elastic material node...
% Physics has default "Linear Elastic Material" node lemm1
% to which we add damping
viscosity = ObtainDCParameter(M,'spcviscousdamping','N*s');


% Add damping to default linear elastic material node...
% Physics has default "Linear Elastic Material" node lemm1
% to which we add damping

CreateWrappedProperty(M,solidmech_harmonicper,'damping',[ solidmech_harmonicper.tag '_damping' ], solidmech_harmonicper.node.feature('lemm1').feature,'Damping',3); % 3-dimensional domains

dampingtype=GetDCParamStringValue(M,'spcmaterialdampingtype');
if strcmp(dampingtype.value,'ViscousDamping')
  solidmech_harmonicper.damping.node.set('DampingType','ViscousDamping');

  viscosity = ObtainDCParameter(M,'spcviscousdamping','N*s');

  
  solidmech_harmonicper.damping.node.set('etab',viscosity);
  solidmech_harmonicper.damping.node.set('etav',viscosity);
elseif strcmp(dampingtype.value,'RayleighDamping')
  solidmech_harmonicper.damping.node.set('DampingType','RayleighDamping');
 
  spcrayleighdamping_alpha = ObtainDCParameter(M,'spcrayleighdamping_alpha','1/s');
  spcrayleighdamping_beta = ObtainDCParameter(M,'spcrayleighdamping_beta','s');

  solidmech_harmonicper.damping.node.set('alpha_dM',spcrayleighdamping_alpha);
  solidmech_harmonicper.damping.node.set('beta_dK',spcrayleighdamping_beta);
else
  fprintf(1,'CreateVibroHarmonicPer(): Unknown damping type "%s"\n',dampingtype.value);
end


% Boundary conditions
BuildBoundaryConditions(M,geom,solidmech_harmonicper,'solidmech_harmonicper'); % apply boundary condtions



% Add laser vibrometer that probes motion 
addprop(solidmech_harmonicper,'laser');
solidmech_harmonicper.laser=CreateLaser(M,[ tag '_laser' ], solidmech_harmonicper.tag, ...
					ObtainDCParameter(M,'laserx','m'), ...
					ObtainDCParameter(M,'lasery','m'), ...
					ObtainDCParameter(M,'laserz','m'), ...
					ObtainDCParameter(M,'laserdx'), ...
					ObtainDCParameter(M,'laserdy'), ...
					ObtainDCParameter(M,'laserdz'));


% Initial conditions for harmonic perturbation: Initial values based on result of static study
initstrainvals={
		[ solidmech_static.tag '.eX'],
		[ solidmech_static.tag '.eXY'],
		[ solidmech_static.tag '.eXZ'],
		[ solidmech_static.tag '.eXY'],
		[ solidmech_static.tag '.eY'],
		[ solidmech_static.tag '.eYZ'],
		[ solidmech_static.tag '.eXZ'],
		[ solidmech_static.tag '.eYZ'],
		[ solidmech_static.tag '.eZ']};

initdisplvals={
	       [ solidmech_static.tag 'u'],
	       [ solidmech_static.tag 'v'],
	       [ solidmech_static.tag 'w']};

SolidMechanics_SetInitialStrain(M,solidmech_harmonicper,initstrainvals);
SolidMechanics_SetInitialDisplacement(M,solidmech_harmonicper,initdisplvals);

% Create harmonic study for harmonic perturbation
addprop(solidmech_harmonicper,'study');
solidmech_harmonicper.study=CreateStudy(M,geom,[ tag '_study' ]);
addprop(solidmech_harmonicper,'step');
solidmech_harmonicper.step=StudyAddFrequencyStep(M,geom,solidmech_harmonicper.study,[ tag '_step' ],freqrange,solidmech_harmonicper,solidmech_static); % both solidmech_harmonicper and solidmech_static are turned on...
StudyStepEnablePhysicsInSolvers(M,solidmech_harmonicper.step,solidmech_static,false); % ... but solidmech_static is not to be solved)

if nonlinear
  solidmech_harmonicper.step.node.set('geometricNonlinearity','on');
end
solidmech_harmonicper.step.node.set('usesol','on'); % Set 'Use Solution Method' on
solidmech_harmonicper.step.node.set('notsolmethod','sol'); % Set dependent variable selection to 'sol', not 'init'
solidmech_harmonicper.step.node.set('notstudy',solidmech_static.study.tag); % tag for study to be used to set dependent variables
solidmech_harmonicper.step.node.set('notsol',solidmech_static.solution.tag);

% Create custom solution for frequency domain study
% Set up solver so that the harmonic study is a linear perturbation solution linearized about the output of stationarystep
addprop(solidmech_harmonicper,'solution');
solidmech_harmonicper.solution=CreateSolution(M,solidmech_harmonicper.study,[ tag '_solution' ],solidmech_harmonicper.step,'Stationary');
% !!!*** NOTE: If this next line causes problems, try solution.solutionsolver.node.set(...
solidmech_harmonicper.solution.solutionsolvers{1}.node.set('nonlin','linper');  % This makes the harmonicstep a linear perturbation linearized around the stationary step
solidmech_harmonicper.solution.solutionsolvers{1}.node.set('linpmethod','sol');
solidmech_harmonicper.solution.solutionsolvers{1}.node.set('linpsol',solidmech_static.solution.tag);
solidmech_harmonicper.solution.solutionsolvers{1}.node.set('storelinpoint','on');

% Select BC's once all Physicses have been created

if crackdiscontinuity 
  bcclasses={'continuities','excitation','fixedisolators','crackdiscontinuity','fixed'};
else
  bcclasses={'continuities','excitation','fixedisolators','crackcontinuity','fixed'};
end  

addprop(solidmech_harmonicper,'rl_selectbcs');
solidmech_harmonicper.rl_selectbcs=RunLater(M,[ tag 'rl_selectbcs' ],'select_boundaryconditions', ...
					    @(M,rlobj) ...
					    SelectBoundaryConditionsForStudy(M,solidmech_harmonicper.study,bcclasses)); % Activate boundary conditions of specified classes

