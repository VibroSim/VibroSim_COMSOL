%> @param type can be 'SolidMechanics' or other types of COMSOL-supported physics
function [physics]=CreatePhysics(M,geom,tag,type,varargin)


  physics=ModelWrapper(M,tag,M.node.physics);
  physics.node=M.node.physics.create(physics.tag,type,geom.tag,varargin{:});
  physics.node.identifier(physics.tag); % for some reason, this doesn't take the first time.
  physics.node.label(physics.tag);

  % set cref (nominal wavespeed cp) equal to the value from this physics
  % (re-link it now that we have renamed the physics node)
  if strcmp(type,'SolidMechanics')
    physics.node.prop('cref').set('cref',[ physics.tag '.cp' ]);
  end

  % Store physics type for later access
  addprop(physics,'type');
  physics.type=type;

  % Create a place to store created boundary conditions
  % NOTE: As distinct from the .boundarycondition field,
  % which is used by geometric objects to store functions
  % to call to create boundaryconditions later when
  % Physics is created.
  addprop(physics,'bcs');
  physics.bcs=struct;  % indexed by tag


  if strcmp(type,'SolidMechanics')
    % Label displacement fields according to physics tag
    physics.node.field('displacement').field([ tag 'u' ]);
    physics.node.field('displacement').component(1,[ tag 'u' ]);
    physics.node.field('displacement').component(2,[ tag 'v' ]);
    physics.node.field('displacement').component(3,[ tag 'w' ]);
  end
