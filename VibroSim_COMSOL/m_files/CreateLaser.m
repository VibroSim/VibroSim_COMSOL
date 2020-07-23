function obj=CreateLaser(M,tag,physicstag,laserx,lasery,laserz,laserdx,laserdy,laserdz)

  laserdx=to_string(laserdx);
  laserdy=to_string(laserdy);
  laserdz=to_string(laserdz);

  laserx=to_string(laserx,'m');
  lasery=to_string(lasery,'m');
  laserz=to_string(laserz,'m');


  obj=CreateWrappedModel(M,tag,M.node.probe,'DomainPoint');
  obj.node.model(M.component.tag); % Set as a component definition not global definition
  obj.node.label(obj.tag);
  obj.node.set('frame','geometry');
  obj.node.set('method','none');
  obj.node.set('bndsnap3','on');   % Snap to boundary
  
  % This should just be: 
  % obj.node.set('coords3', { laserx, lasery, laserz });
  % ... but for some reason COMSOL 5.0 can't handle this (bug?)
  % so instead we evaluate numerically into strings without units   
  obj.node.setIndex('coords3', laserx,0,0);
  obj.node.setIndex('coords3', lasery,0,1);
  obj.node.setIndex('coords3', laserz,0,2);

  % When a DomainPoint is created it automatically creates a 
  % Displacement Probe that we really don't want (not compatible with
  % our naming scheme)
  tags_cell = cell(obj.node.feature.tags);
  autoprobetagname=tags_cell{1};
  obj.node.feature.remove(autoprobetagname);

  % Create displacement probe from preexisting feature (note tagname will not match!)
  %addprop(obj,'displ');
  %obj.displ=ModelWrapper(M,[tag '_displ'],obj.node.feature);
  %obj.displ.node=obj.node.feature(autoprobetagname);

  CreateWrappedProperty(M,obj,'displ',[ tag '_displ' ],obj.node.feature,'PointExpr');
  obj.displ.node.label(obj.displ.tag);

  u=[ physicstag 'u' ];
  v=[ physicstag 'v' ];
  w=[ physicstag 'w' ];  

  obj.displ.node.set('expr',[ '((' u ')*(' laserdx ') + (' v ')*(' laserdy ') + (' w ')*(' laserdz '))/(' magnitude_cellstr_array({ laserdx, laserdy, laserdz }) ')']);
  obj.displ.node.set('descr', 'Displacement in laser direction');
  obj.displ.node.set('probename',obj.displ.tag);


  % Create velocity probe
  CreateWrappedProperty(M,obj,'vel',[ tag '_vel' ],obj.node.feature,'PointExpr');
  obj.vel.node.label(obj.vel.tag);

  dudt=[ physicstag '.u_tX' ];
  dvdt=[ physicstag '.u_tY' ];
  dwdt=[ physicstag '.u_tZ' ];  

  obj.vel.node.set('expr',[ '((' dudt ')*(' laserdx ') + (' dvdt ')*(' laserdy ') + (' dwdt ')*(' laserdz '))/(' magnitude_cellstr_array({ laserdx, laserdy, laserdz }) ')']);
  obj.vel.node.set('descr', 'Velocity in laser direction');
  obj.vel.node.set('probename',obj.vel.tag);
