%> Create physics, study, step, and solution for a harmonic (NON-perturbation) vibration analysis
%> Consisting of three sub-sweeps No static analysis is required.
%>
%> Parameters
%> ----------
%> @param M:                  ModelWrapper around top level model
%> @param geom:               Wrapped top level geometry
%> @param tag :               Tag for physics. Should usually be 'solidmech_harmonic'
%> @param seg1_freqrange:     Single frequency or range of frequencies to use.
%>                            can be 'range(freqstart,freqstep,freqend)'
%> @param seg2_freqrange:     Single frequency or range of frequencies to use.
%>                            can be 'range(freqstart,freqstep,freqend)'
%> @param seg3_freqrange:     Single frequency or range of frequencies to use.
%>                            can be 'range(freqstart,freqstep,freqend)'
%> @param seg4_freqrange:     Single frequency or range of frequencies to use.
%>                            can be 'range(freqstart,freqstep,freqend)'
%>
%> Uses solidmech_harmonic physicsclass boundary conditions
%> The crack face boundary conditions are continuity conditions. This function uses the impulseforceexcitation class which is just a simple impulse force.
%>
%> @retval solidmech_multisweep

function solidmech_multisweep=CreateVibroMultiSweep(M,geom,tag,seg1_freqrange,seg2_freqrange,seg3_freqrange,seg4_freqrange)

crackdiscontinuity=false;
use_impulse_force_excitation=true;



% Create physics for harmonic analysis
solidmech_multisweep=CreatePhysics(M,geom,tag,'SolidMechanics');

addprop(solidmech_multisweep,'timedomain');
solidmech_multisweep.timedomain=false;

% Fix equation form to frequency domain
solidmech_multisweep.node.prop('EquationForm').setIndex('form', 'Frequency', 0);

% Add damping to default linear elastic material node...
% Physics has default "Linear Elastic Material" node lemm1
% to which we add damping
viscosity = ObtainDCParameter(M,'spcviscousdamping','N*s');
CreateWrappedProperty(M,solidmech_multisweep,'damping',[ solidmech_multisweep.tag '_damping' ], solidmech_multisweep.node.feature('lemm1').feature,'Damping',3); % 3-dimensional domains
solidmech_multisweep.damping.node.set('DampingType','ViscousDamping');


solidmech_multisweep.damping.node.set('etab',viscosity);
solidmech_multisweep.damping.node.set('etav',viscosity);


% Boundary conditions
BuildBoundaryConditions(M,geom,solidmech_multisweep,'solidmech_harmonic'); % apply boundary condtions


% Add laser vibrometer that probes motion 
addprop(solidmech_multisweep,'laser');
solidmech_multisweep.laser=CreateLaser(M,[ tag '_laser' ], solidmech_multisweep.tag, ...
				       ObtainDCParameter(M,'laserx','m'), ...
				       ObtainDCParameter(M,'lasery','m'), ...
				       ObtainDCParameter(M,'laserz','m'), ...
				       ObtainDCParameter(M,'laserdx'), ...
				       ObtainDCParameter(M,'laserdy'), ...
				       ObtainDCParameter(M,'laserdz'));


% Create harmonic study 
addprop(solidmech_multisweep,'seg1_study');
solidmech_multisweep.seg1_study=CreateStudy(M,geom,[ tag '_seg1_study' ]);

addprop(solidmech_multisweep,'seg2_study');
solidmech_multisweep.seg2_study=CreateStudy(M,geom,[ tag '_seg2_study' ]);

addprop(solidmech_multisweep,'seg3_study');
solidmech_multisweep.seg3_study=CreateStudy(M,geom,[ tag '_seg3_study' ]);

addprop(solidmech_multisweep,'seg4_study');
solidmech_multisweep.seg4_study=CreateStudy(M,geom,[ tag '_seg4_study' ]);

addprop(solidmech_multisweep,'seg1_step');
solidmech_multisweep.seg1_step=StudyAddFrequencyStep(M,geom,solidmech_multisweep.seg1_study,[ tag '_seg1_step' ],seg1_freqrange,solidmech_multisweep); % only solidmech_multisweep physics enabled...

addprop(solidmech_multisweep,'seg2_step');
solidmech_multisweep.seg2_step=StudyAddFrequencyStep(M,geom,solidmech_multisweep.seg2_study,[ tag '_seg2_step' ],seg2_freqrange,solidmech_multisweep); % only solidmech_multisweep physics enabled...

addprop(solidmech_multisweep,'seg3_step');
solidmech_multisweep.seg3_step=StudyAddFrequencyStep(M,geom,solidmech_multisweep.seg3_study,[ tag '_seg3_step' ],seg3_freqrange,solidmech_multisweep); % only solidmech_multisweep physics enabled...

addprop(solidmech_multisweep,'seg4_step');
solidmech_multisweep.seg4_step=StudyAddFrequencyStep(M,geom,solidmech_multisweep.seg4_study,[ tag '_seg4_step' ],seg4_freqrange,solidmech_multisweep); % only 


% Create custom solution for frequency domain study
% Set up solver 
addprop(solidmech_multisweep,'seg1_solution');
solidmech_multisweep.seg1_solution=CreateSolution(M,solidmech_multisweep.seg1_study,[ tag '_seg1_solution' ],solidmech_multisweep.seg1_step,'Stationary');

addprop(solidmech_multisweep,'seg2_solution');
solidmech_multisweep.seg2_solution=CreateSolution(M,solidmech_multisweep.seg2_study,[ tag '_seg2_solution' ],solidmech_multisweep.seg2_step,'Stationary');

addprop(solidmech_multisweep,'seg3_solution');
solidmech_multisweep.seg3_solution=CreateSolution(M,solidmech_multisweep.seg3_study,[ tag '_seg3_solution' ],solidmech_multisweep.seg3_step,'Stationary');

addprop(solidmech_multisweep,'seg4_solution');
solidmech_multisweep.seg4_solution=CreateSolution(M,solidmech_multisweep.seg4_study,[ tag '_seg4_solution' ],solidmech_multisweep.seg4_step,'Stationary');

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


% Create combined study that triggers all 4 pieces
addprop(solidmech_multisweep,'combined_study');
solidmech_multisweep.combined_study=CreateStudy(M,geom,[ tag '_combined_study' ]);

addprop(solidmech_multisweep.combined_study,'seg1_reference');
solidmech_multisweep.combined_study.seg1_reference = ModelWrapper(M,[ tag '_combined_study_seg1_reference' ],solidmech_multisweep.combined_study.node);
solidmech_multisweep.combined_study.seg1_reference.node=solidmech_multisweep.combined_study.node.create([ tag '_combined_study_seg1_reference' ],'StudyReference');
solidmech_multisweep.combined_study.seg1_reference.node.set('studyref',[ tag '_seg1_study' ]);

addprop(solidmech_multisweep.combined_study,'seg2_reference');
solidmech_multisweep.combined_study.seg2_reference = ModelWrapper(M,[ tag '_combined_study_seg2_reference' ],solidmech_multisweep.combined_study.node);
solidmech_multisweep.combined_study.seg2_reference.node=solidmech_multisweep.combined_study.node.create([ tag '_combined_study_seg2_reference' ],'StudyReference');
solidmech_multisweep.combined_study.seg2_reference.node.set('studyref',[ tag '_seg2_study' ]);

addprop(solidmech_multisweep.combined_study,'seg3_reference');
solidmech_multisweep.combined_study.seg3_reference = ModelWrapper(M,[ tag '_combined_study_seg3_reference' ],solidmech_multisweep.combined_study.node);
solidmech_multisweep.combined_study.seg3_reference.node=solidmech_multisweep.combined_study.node.create([ tag '_combined_study_seg3_reference' ],'StudyReference');
solidmech_multisweep.combined_study.seg3_reference.node.set('studyref',[ tag '_seg3_study' ]);


addprop(solidmech_multisweep.combined_study,'seg4_reference');
solidmech_multisweep.combined_study.seg4_reference = ModelWrapper(M,[ tag '_combined_study_seg4_reference' ],solidmech_multisweep.combined_study.node);
solidmech_multisweep.combined_study.seg4_reference.node=solidmech_multisweep.combined_study.node.create([ tag '_combined_study_seg4_reference' ],'StudyReference');
solidmech_multisweep.combined_study.seg4_reference.node.set('studyref',[ tag '_seg4_study' ]);



% Select BC's once all Physicses have been created
addprop(solidmech_multisweep,'rl_selectbcs_seg1');
solidmech_multisweep.rl_selectbcs_seg1=RunLater(M,[ tag 'rl_selectbcs_seg1' ],'select_boundaryconditions', ...
						@(M,rlobj) ...
						 SelectBoundaryConditionsForStudy(M,solidmech_multisweep.seg1_study,bcclasses)); % Activate boundary conditions of specified classes

addprop(solidmech_multisweep,'rl_selectbcs_seg2');
solidmech_multisweep.rl_selectbcs_seg2=RunLater(M,[ tag 'rl_selectbcs_seg2' ],'select_boundaryconditions', ...
						@(M,rlobj) ...
						 SelectBoundaryConditionsForStudy(M,solidmech_multisweep.seg2_study,bcclasses)); % Activate boundary conditions of specified classes

addprop(solidmech_multisweep,'rl_selectbcs_seg3');
solidmech_multisweep.rl_selectbcs_seg3=RunLater(M,[ tag 'rl_selectbcs_seg3' ],'select_boundaryconditions', ...
						@(M,rlobj) ...
						 SelectBoundaryConditionsForStudy(M,solidmech_multisweep.seg3_study,bcclasses)); % Activate boundary conditions of specified classes

addprop(solidmech_multisweep,'rl_selectbcs_seg4');
solidmech_multisweep.rl_selectbcs_seg4=RunLater(M,[ tag 'rl_selectbcs_seg4' ],'select_boundaryconditions', ...
						@(M,rlobj) ...
						 SelectBoundaryConditionsForStudy(M,solidmech_multisweep.seg4_study,bcclasses)); % Activate boundary conditions of specified classes
