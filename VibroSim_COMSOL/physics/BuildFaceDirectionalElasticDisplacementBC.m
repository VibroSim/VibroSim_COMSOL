function bcobj = BuildFaceDirectionalElasticDisplacementBC(M,geom,physics,object,bcobj,getfaceselectionfunc,direction,magnitude,harmonicperdirection,harmonicpermagnitude,stiffnessperunitarea, dashpotcoeffperunitarea)
% NOTE: Direction MUST be a unit vector
% harmonicperdirection, harmonicpermagnitude are optional and if given
% result in the creation of a harmonic perturbation
%
% NOTE: If the physics is time domain, then magnitude should be 
% the displacement as a function of time in the specified direction
%
% If the physics is not timedomain then magnitude should be the (possibly 
% frequency-dependent) amplitude of the sinusoidal excitation 
% For a modal analysis, magnitude should be 0.0


if harmonicpermagnitude ~= 0.0
  error('BuildFaceDirectionElasticDisplacementBC: Harmonic perturbation mode not currently supported or tested');
end

direction_ca=to_cellstr_array(direction);

if isa(magnitude,'double')
  magnitude=num2str(magnitude,18);
end

if isa(stiffnessperunitarea,'double')
  stiffnessperunitarea=num2str(stiffnessperunitarea,18);
end

if isa(dashpotcoeffperunitarea,'double')
  dashpotcoeffperunitarea=num2str(dashpotcoeffperunitarea,18);
end

% Force/area = direction * -(stiffnessperunitarea*(1+i*eta_s)) * ((u-u0)*direction - magnitude )

u={ [ physics.tag 'u' ], [ physics.tag 'v' ], [ physics.tag 'w' ] }; % displacement
if physics.timedomain
  ut={ [ physics.tag 'ut' ], [ physics.tag 'vt' ], [ physics.tag 'wt' ] }; % displacement time derivative 
else
  ut=mul_cellstr_array_scalar(u,'i*2*pi*freq');
end

% u0={ [ physics.tag '.u0' ], [ physics.tag '.v0' ], [ physics.tag '.w0' ] };

% displacementcomponent = innerprod_cellstr_array(sub_cellstr_array(u,u0),direction_ca);
displacementcomponent = innerprod_cellstr_array(u,direction_ca);
velocitycomponent = innerprod_cellstr_array(ut,direction_ca);

springstretch = [ '(' displacementcomponent ') - (' magnitude ')' ];
%complexstiffness = [ '(' stiffnessperunitarea ') * (1.0 + i*(' eta_s '))' ];
%FperArea=mul_cellstr_array_scalar(direction_ca,[ '-(' complexstiffness ')*(' springstretch ')' ]);
ElasticFperArea = mul_cellstr_array_scalar(direction_ca,[ '-(' stiffnessperunitarea ')*(' springstretch ')' ]);

% Absorptive stress =  - c xdot = dashpotcoeffperunitarea * (d/dt)(displacementcomponent-magnitude) * direction
%       = -dashpotcoeffperunitarea*velocitycomponent*direction + dashpotcoeffperunitarea * (d/dt)magnitude * direction
% if displacement wave  = magnitude*exp(i2*pi*freq*t)
% d/dt magnitude = i*2*pi*freq * magnitude
% absorptive stress      = -dashpotcoeffperunitarea*velocitycomponent*direction + dashpotcoeffperunitarea * (i*2*pi*freq)*magnitude * direction

if physics.timedomain
  velocity_magnitude = [ 'd(' magnitude ',t)' ];
else
  velocity_magnitude = [ 'i*2*pi*freq*' '(' magnitude ')' ];
end

AbsorptiveFperArea = add_cellstr_array(mul_cellstr_array_scalar(direction_ca,['-' '(' velocitycomponent ')' '*' '(' dashpotcoeffperunitarea ')']),mul_cellstr_array_scalar(direction_ca,['(' dashpotcoeffperunitarea ')' '*' velocity_magnitude ]));
FperArea=add_cellstr_array(ElasticFperArea ,AbsorptiveFperArea);


BuildWrappedModel(M,bcobj,physics.node.feature,'BoundaryLoad',2);
bcobj.node.label(bcobj.tag);
bcobj.node.set('FperArea',FperArea);


faceentities=getfaceselectionfunc(M,geom,object);

bcobj.node.selection.set(faceentities);
