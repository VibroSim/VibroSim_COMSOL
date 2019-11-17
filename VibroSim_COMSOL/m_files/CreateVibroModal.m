%> Create physics, study, step, and solution for a modal (NON-perturbation) vibration analysis
%> for Vibrothermography. No static analysis is required.
%>
%> Parameters
%> ----------
%> @param M:                  ModelWrapper around top level model
%> @param geom:               Wrapped top level geometry
%> @param tag :               Tag for physics. Should usually be 'solidmech_modal'
%> @param crackdiscontinuity: Optional boolean, default false. If false the crack
%>                            face boundary conditions are continuity conditions.
%>                            If true, the thin elastic layer BC is used.
%>
%> @retval solidmech_modal
function solidmech_modal=CreateVibroModal(M,geom,tag,crackdiscontinuity)

if ~exist('crackdiscontinuity','var')
  crackdiscontinuity=false;
end


% Create physics for modal analysis
solidmech_modal=CreatePhysics(M,geom,tag,'SolidMechanics');

addprop(solidmech_modal,'timedomain');
solidmech_modal.timedomain=false;


% Add damping to default linear elastic material node...
% Physics has default "Linear Elastic Material" node lemm1
% to which we add damping
viscosity = ObtainDCParameter(M,'spcviscousdamping','N*s');

CreateWrappedProperty(M,solidmech_modal,'damping',[ solidmech_modal.tag '_damping' ], solidmech_modal.node.feature('lemm1').feature,'Damping',3); % 3-dimensional domains
solidmech_modal.damping.node.set('DampingType','ViscousDamping');


solidmech_modal.damping.node.set('etab',viscosity);
solidmech_modal.damping.node.set('etav',viscosity);


% Boundary conditions
BuildBoundaryConditions(M,geom,solidmech_modal,'solidmech_modal'); % apply boundary condtions

% Create modal study 
addprop(solidmech_modal,'study');
solidmech_modal.study=CreateStudy(M,geom,[ tag '_study' ]);
addprop(solidmech_modal,'step');
solidmech_modal.step=StudyAddStep(M,geom,solidmech_modal.study,[ tag '_step' ],'Eigenfrequency',solidmech_modal); % only solidmech_modal physics enabled...


% Create custom solution for modal analysis study
% Set up solver so that the modal study is a linear perturbation solution linearized about the output of stationarystep
addprop(solidmech_modal,'solution');
solidmech_modal.solution=CreateSolution(M,solidmech_modal.study,[ tag '_solution' ],solidmech_modal.step,'Eigenvalue');
solidmech_modal.solution.solutionsolvers{1}.node.set('transform','eigenfrequency');
solidmech_modal.solution.solutionsolvers{1}.node.set('shift',ObtainDCParameter(M,'simulationeigsaround','Hz'));

% We extract the value here for neigs instead of using ObtainDCParameter, 
% because for whatever reason the neigs parameter of solutionsolver only supports constants. 
try 
  neigs_struct=GetDCParamNumericValue(M,'simulationneigs');
  neigs=neigs_struct.value;
catch
  neigs_struct=GetDCParamStringValue(M,'simulationneigs'); % temporary workaround for simulationneigs being a string in datacollect
  neigs=str2num(neigs_struct.repr);
end

solidmech_modal.solution.solutionsolvers{1}.node.set('neigs',neigs);
% 11/8/19 - use simulationeigsaround as the linearization point for the modal analysis, 
% in case there is frequency dependence in the model (e.g. in mount stiffness/damping for cantilever model)
solidmech_modal.solution.solutionsolvers{1}.node.set('transeigref', true);
solidmech_modal.solution.solutionsolvers{1}.node.set('eigref',ObtainDCParameter(M,'simulationeigsaround','Hz'));



% Select BC's once all Physicses have been created
if crackdiscontinuity 
  bcclasses={'continuities','fixedexcitation','fixedisolators','crackdiscontinuity','fixed'};
else
  bcclasses={'continuities','fixedexcitation','fixedisolators','crackcontinuity','fixed'};
end  


addprop(solidmech_modal,'rl_selectbcs');
solidmech_modal.rl_selectbcs=RunLater(M,[ tag 'rl_selectbcs' ],'select_boundaryconditions', ...
				      @(M,rlobj) ...
				      SelectBoundaryConditionsForStudy(M,solidmech_modal.study,bcclasses)); % Activate boundary conditions of specified classes (excitation not applicable for a modal analysis)


