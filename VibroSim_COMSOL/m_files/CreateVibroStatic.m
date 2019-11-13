%> Create a static distortion analysis for vibrothermography.
%>
%> Parameters
%> ----------
%> @param M:                  ModelWrapper around top level model
%> @param geom:               Wrapped top level geometry
%> @param tag:                Tag for physics. Should usually be 'solidmech_static'
%> @param crackdiscontinuity: Optional boolean, default false. If false the crack
%>                            face boundary conditions are continuity conditions.
%>                            If true, the thin elastic layer BC is used.
%> @param nonlinear:          Optional boolean, default false. If false the problem
%>                            is presumed to be linear. If true, geometric nonlineary
%>                            is considered and a nonlinear solver is used
%>
%> If optional nonlinear parameter is true, then enable
%> geometric nonlinearity and nonlinear solver.
%>
%> @retval solidmech_static

function solidmech_static=CreateVibroStatic(M,geom,tag,crackdiscontinuity,nonlinear)


if ~exist('crackdiscontinuity','var')
  crackdiscontinuity=false;
end

if ~exist('nonlinear','var')
  nonlinear=false;
end

  
solidmech_static=CreatePhysics(M,geom,tag,'SolidMechanics'); % note: displacements are solidmech_staticu, solidmech_staticv, solidmech_staticw


addprop(solidmech_static,'timedomain');
solidmech_static.timedomain=false;

% Force equation form to always be stationary
solidmech_static.node.prop('EquationForm').setIndex('form', 'Stationary', 0);

% Create boundary conditions for solidmech_static 
BuildBoundaryConditions(M,geom,solidmech_static,'solidmech_static');

% Define stationary study
addprop(solidmech_static,'study');
solidmech_static.study=CreateStudy(M,geom,[tag '_study']);
addprop(solidmech_static,'step');
solidmech_static.step=StudyAddStep(M,geom,solidmech_static.study,[tag '_step'],'Stationary',solidmech_static);
if nonlinear
  solidmech_static.step.node.set('geometricNonlinearity','on');
end

% Create custom solution for stationary step
addprop(solidmech_static,'solution');
solidmech_static.solution=CreateSolution(M,solidmech_static.study,[tag '_solution'],solidmech_static.step,'Stationary');
if nonlinear
  solidmech_static.solution.solutionsolver.node.set('nonlin','on');
end

% Select BC's once all Physicses have been created

if crackdiscontinuity 
  bcclasses={'continuities','staticloading','crackdiscontinuity','fixed'};
else
  bcclasses={'continuities','staticloading','crackcontinuity','fixed'};
end  
  
addprop(solidmech_static,'rl_selectbcs');
solidmech_static.rl_selectbcs=RunLater(M,[tag '_rl_selectbcs'],'select_boundaryconditions', ...
				       @(M,rlobj) ...
				       SelectBoundaryConditionsForStudy(M,solidmech_static.study, ...
									bcclasses)); % Activate boundary conditions of specified classes

