%> Create physics, study, step, and solution for a harmonic (NON-perturbation) vibration analysis
%> for Vibrothermography. No static analysis is required.
%>
%> Parameters
%> ----------
%> @param M:                  ModelWrapper around top level model
%> @param geom:               Wrapped top level geometry
%> @param tag :               Tag for physics. Should usually be 'solidmech_harmonic'
%> @param freqrange:          Single frequency or range of frequencies to use.
%>                            can be 'range(freqstart,freqstep,freqend)'
%> @param crackdiscontinuity: Optional boolean, default false. If false the crack
%>                            face boundary conditions are continuity conditions.
%>                            If true, the thin elastic layer BC is used.
%> @param use_impulse_force_excitation: Optional boolean, default false. If false use the
%>                            excitation boundary condition class, which enables the couplant model.
%>                            If true, use the impulseforceexcitation class which is just a simple impulse force.
%>
%> @retval solidmech_harmonic

function solidmech_harmonic=CreateVibroHarmonic(M,geom,tag,freqrange,crackdiscontinuity,use_impulse_force_excitation)

if ~exist('crackdiscontinuity','var')
  crackdiscontinuity=false;
end

if ~exist('use_impulse_force_excitation','var')
  use_impulse_force_excitation=false;
end


% Create physics for harmonic analysis
solidmech_harmonic=CreatePhysics(M,geom,tag,'SolidMechanics');

addprop(solidmech_harmonic,'timedomain');
solidmech_harmonic.timedomain=false;

% Fix equation form to frequency domain
solidmech_harmonic.node.prop('EquationForm').setIndex('form', 'Frequency', 0);

% Add damping to default linear elastic material node...
% Physics has default "Linear Elastic Material" node lemm1
% to which we add damping

CreateWrappedProperty(M,solidmech_harmonic,'damping',[ solidmech_harmonic.tag '_damping' ], solidmech_harmonic.node.feature('lemm1').feature,'Damping',3); % 3-dimensional domains

dampingtype=GetDCParamStringValue(M,'spcmaterialdampingtype');
if strcmp(dampingtype.value,'ViscousDamping')
  solidmech_harmonic.damping.node.set('DampingType','ViscousDamping');

  viscosity = ObtainDCParameter(M,'spcviscousdamping','N*s');

  
  solidmech_harmonic.damping.node.set('etab',viscosity);
  solidmech_harmonic.damping.node.set('etav',viscosity);
elseif strcmp(dampingtype.value,'RayleighDamping')
  solidmech_harmonic.damping.node.set('DampingType','RayleighDamping');

  spcrayleighdamping_alpha = ObtainDCParameter(M,'spcrayleighdamping_alpha','1/s');
  spcrayleighdamping_beta = ObtainDCParameter(M,'spcrayleighdamping_beta','s');

  solidmech_harmonic.damping.node.set('alpha_dM',spcrayleighdamping_alpha);
  solidmech_harmonic.damping.node.set('beta_dK',spcrayleighdamping_beta);
else
  fprintf(1,'CreateVibroModal(): Unknown damping type "%s"\n',dampingtype.value);
end

% Boundary conditions
BuildBoundaryConditions(M,geom,solidmech_harmonic,'solidmech_harmonic'); % apply boundary condtions


% Add laser vibrometer that probes motion 
addprop(solidmech_harmonic,'laser');
solidmech_harmonic.laser=CreateLaser(M,[ tag '_laser' ], solidmech_harmonic.tag, ...
				     ObtainDCParameter(M,'laserx','m'), ...
				     ObtainDCParameter(M,'lasery','m'), ...
				     ObtainDCParameter(M,'laserz','m'), ...
				     ObtainDCParameter(M,'laserdx'), ...
				     ObtainDCParameter(M,'laserdy'), ...
				     ObtainDCParameter(M,'laserdz'));


% Create harmonic study 
addprop(solidmech_harmonic,'study');
solidmech_harmonic.study=CreateStudy(M,geom,[ tag '_study' ]);
addprop(solidmech_harmonic,'step');
solidmech_harmonic.step=StudyAddFrequencyStep(M,geom,solidmech_harmonic.study,[ tag '_step' ],freqrange,solidmech_harmonic); % only solidmech_harmonic physics enabled...



% Create custom solution for frequency domain study
% Set up solver 
addprop(solidmech_harmonic,'solution');
solidmech_harmonic.solution=CreateSolution(M,solidmech_harmonic.study,[ tag '_solution' ],solidmech_harmonic.step,'Stationary');

if use_impulse_force_excitation
  if crackdiscontinuity 
    bcclasses={'continuities','impulseforceexcitation','fixedisolators','crackdiscontinuity','fixed'};
  else
    bcclasses={'continuities','impulseforceexcitation','fixedisolators','crackcontinuity','fixed'};
  end  
else
  if crackdiscontinuity 
    bcclasses={'continuities','excitation','fixedisolators','crackdiscontinuity','fixed'};
  else
    bcclasses={'continuities','excitation','fixedisolators','crackcontinuity','fixed'};
  end  

end


% Select BC's once all Physicses have been created
addprop(solidmech_harmonic,'rl_selectbcs');
solidmech_harmonic.rl_selectbcs=RunLater(M,[ tag 'rl_selectbcs' ],'select_boundaryconditions', ...
					 @(M,rlobj) ...
					 SelectBoundaryConditionsForStudy(M,solidmech_harmonic.study,bcclasses)); % Activate boundary conditions of specified classes

