%> Create physics, study, step, and solution for a time-domain vibration analysis
%> for Vibrothermography. No static analysis is required.
%>
%> Parameters
%> ----------
%> @param M:                  ModelWrapper around top level model
%> @param geom:               Wrapped top level geometry
%> @param tag :               Tag for physics. Should usually be 'solidmech_timedomain'
%> @param couplant_coord:     Coordinates of transducer -- used to correctly locate transducer contact point motion probe 
%> @param crackdiscontinuity: Optional boolean, default false. If false the crack
%>                            face boundary conditions are continuity conditions.
%>                            If true, the thin elastic layer BC is used.
%>
%> @retval solidmech_timedomain
function solidmech_timedomain=CreateVibroTimeDomain(M,geom,tag,crackdiscontinuity)

if ~exist('crackdiscontinuity','var')
  crackdiscontinuity=false;
end


% Create physics for time-domain analysis
solidmech_timedomain=CreatePhysics(M,geom,tag,'SolidMechanics');

addprop(solidmech_timedomain,'timedomain');
solidmech_timedomain.timedomain=true;

% Add damping to default linear elastic material node...
% Physics has default "Linear Elastic Material" node lemm1
% to which we add damping
%CreateWrappedProperty(M,solidmech_timedomain,'damping',[ solidmech_timedomain.tag '_damping' ], solidmech_timedomain.node.feature('lemm1').feature,'Damping',3); % 3-dimensional domains
% !!!!*** solidmech_modal.damping.node.set('DampingType','IsotropicLossFactor');

% NOTE: We do not currently consider the presence of the excitation couplant (!)
% Also we do not include extra damping terms. To connect this study
% with modal analysis to observe ringdown, need to make damping 
% compatible !!!***

% Add damping to default linear elastic material node...
% Physics has default "Linear Elastic Material" node lemm1
% to which we add damping

CreateWrappedProperty(M,solidmech_timedomain,'damping',[ solidmech_timedomain.tag '_damping' ], solidmech_timedomain.node.feature('lemm1').feature,'Damping',3); % 3-dimensional domains

dampingtype=GetDCParamStringValue(M,'spcmaterialdampingtype');
if strcmp(dampingtype.value,'ViscousDamping')
  solidmech_timedomain.damping.node.set('DampingType','ViscousDamping');

  viscosity = ObtainDCParameter(M,'spcviscousdamping','N*s');

  
  solidmech_timedomain.damping.node.set('etab',viscosity);
  solidmech_timedomain.damping.node.set('etav',viscosity);
elseif strcmp(dampingtype.value,'RayleighDamping')
  %solidmech_timedomain.damping.node.set('DampingType','RayleighDamping');
  fprintf(1,'CreateVibroTimeDomain(): Time domain excitation incompatible with Rayleigh Damping; Damping is disabled\n');  

  %spcrayleighdamping_alpha = ObtainDCParameter(M,'spcrayleighdamping_alpha','1/s');
  %spcrayleighdamping_beta = ObtainDCParameter(M,'spcrayleighdamping_beta','s');

  %solidmech_timedomain.damping.node.set('alpha_dM',spcrayleighdamping_alpha);
  %solidmech_timedomain.damping.node.set('beta_dK',spcrayleighdamping_beta);
else
  fprintf(1,'CreateVibroTimeDomain(): Unknown damping type "%s"\n',dampingtype.value);
end

% Boundary conditions
BuildBoundaryConditions(M,geom,solidmech_timedomain,'solidmech_timedomain'); % apply boundary condtions

% Create timedomain study 
addprop(solidmech_timedomain,'study');
solidmech_timedomain.study=CreateStudy(M,geom,[ tag '_study' ]);
addprop(solidmech_timedomain,'step');
solidmech_timedomain.step=StudyAddStep(M,geom,solidmech_timedomain.study,[ tag '_step' ],'Transient',solidmech_timedomain); % only solidmech_timedomain physics enabled...

solidmech_timedomain.step.node.set('tlist',sprintf('range(%s,%s,%s)',ObtainDCParameter(M,'timedomain_start_time','s'),ObtainDCParameter(M,'timedomain_step_time','s'),ObtainDCParameter(M,'timedomain_end_time','s')));


%% Create custom solution for timedomain analysis study
%% Set up solver so that the modal study is a linear perturbation solution linearized about the output of stationarystep
addprop(solidmech_timedomain,'solution');
solidmech_timedomain.solution=CreateSolution(M,solidmech_timedomain.study,[ tag '_solution' ],solidmech_timedomain.step,'Time');
%solidmech_timedomain.solution.variables.feature('Component_solidmech_timedomainu').set('scalemethod', 'manual');
%solidmech_timedomain.solution.variables.feature('Component_solidmech_timedomainu').set('scaleval', '1e-2*0.1427906159381631');

%solidmech_timedomain.solution.solutionsolvers{1}.node.set('tlist','range(timedomain_start_time,timedomain_step_time,timedomain_end_time)');
solidmech_timedomain.solution.solutionsolvers{1}.node.set('plot','off');


solidmech_timedomain.solution.solutionsolvers{1}.node.set('timemethod', 'genalpha');
solidmech_timedomain.solution.solutionsolvers{1}.node.set('tstepsgenalpha', 'manual');
solidmech_timedomain.solution.solutionsolvers{1}.node.set('timestepgenalpha','1e-6');

%solidmech_timedomain.solution.solutionsolvers{1}.node.set('tstepsbdf','intermediate');  % 'intermediate bdf time steps forces it to calculate for at least our specified time steps... vs 'free' which allows COMSOL to figure out all time steps, vs 'strict' which forces calculation only at specified times


%solidmech_timedomain.solution.solutionsolvers{1}.node.set('atolglobalmethod', 'scaled');
%solidmech_timedomain.solution.solutionsolvers{1}.node.set('atolglobal', 0.001);
%
%% add probe for transducer motion
%addprop(solidmech_timedomain,'xducercontactprobe');
%solidmech_timedomain.xducercontactprobe=CreateProbe(M, [ tag '_xducercontactprobe', solidmech_timedomain.tag, ...
							     
% Add laser vibrometer that probes motion 
addprop(solidmech_timedomain,'laser');
solidmech_timedomain.laser=CreateLaser(M,[ tag '_laser' ], solidmech_timedomain.tag, ...
				       ObtainDCParameter(M,'laserx','m'), ...
				       ObtainDCParameter(M,'lasery','m'), ...
				       ObtainDCParameter(M,'laserz','m'), ...
				       ObtainDCParameter(M,'laserdx'), ...
				       ObtainDCParameter(M,'laserdy'), ...
				       ObtainDCParameter(M,'laserdz'));


% Select BC's once all Physicses have been created
if crackdiscontinuity 
  bcclasses={'continuities','impulseforceexcitation','fixedisolators','crackdiscontinuity','fixed'};
else
  bcclasses={'continuities','impulseforceexcitation','fixedisolators','crackcontinuity','fixed'};
end  


addprop(solidmech_timedomain,'rl_selectbcs');
solidmech_timedomain.rl_selectbcs=RunLater(M,[ tag 'rl_selectbcs' ],'select_boundaryconditions', ...
				      @(M,rlobj) ...
				      SelectBoundaryConditionsForStudy(M,solidmech_timedomain.study,bcclasses)); % Activate boundary conditions of specified classes (excitation not applicable for a modal analysis)


