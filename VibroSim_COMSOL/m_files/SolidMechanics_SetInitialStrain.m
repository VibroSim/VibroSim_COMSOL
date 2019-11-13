function SolidMechanics_SetInitialStrain(M,physics,initstrainvals)

% 'lemm1' is the automatically generated feature within the 
% SolidMechanics Physics representing the default Linear Elastic Material
addprop(physics,'initialstrain');
physics.initialstrain=ModelWrapper(M,[ physics.tag '_initialstrain'],physics.node.feature('lemm1').feature);
physics.initialstrain.node=physics.node.feature('lemm1').feature.create(physics.initialstrain.tag,'InitialStressandStrain',3);
physics.initialstrain.node.set('eil',initstrainvals);



