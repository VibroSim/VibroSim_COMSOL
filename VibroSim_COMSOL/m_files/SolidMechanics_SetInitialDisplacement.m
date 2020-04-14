function SolidMechanics_SetInitialDisplacement(M,physics,initdisplvals)

% 'init1' is the automatically generated feature within the 
% SolidMechanics Physics representing the default initial conditions

physics.node.feature('init1').set([physics.tag 'u'],initdisplvals);
