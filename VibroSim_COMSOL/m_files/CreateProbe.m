%> CREATEPROBE Create a probe point where displacement and velocity can be measured
%>   obj = CreateProbe(M, tag, physicstag, coordx,coordy,coordz,directionx,directiony,directionz,...) Creates displacement probe at a specified point that is sensitive to motion in a specified direction
%>    Required parameters:
%>    -------------------
%>    M - (obj) comsol model object
%>    tag - (str) name tag of domain probe to be created
%>    physics - (str) name tag of physics domain for probe to be created
%>    coordx, coordy,coordz - point coordinates (may be numbers or strings)
%>    directionx,directiony,directionz - sensitivity direction vector (will be normalized to a unit vector)
%>    (additional parameters) - Additional parameters are (set parameter name, set parameter value) pairs, e.g   'bndsnap3','on' will enable snap to boundary

%>
%>    Returns:
%>    --------
%>    obj -- wrappedobject 

function  obj = CreateProbe(M, tag, physicstag, coordx,coordy,coordz,directionx,directiony,directionz,varargin)
  coordx=to_string(coordx,'m');
  coordy=to_string(coordy,'m');
  coordz=to_string(coordz,'m');

  directionx=to_string(directionx);
  directiony=to_string(directiony);
  directionz=to_string(directionz);

  obj=CreateWrappedModel(M,tag,M.node.probe,'DomainPoint');

  obj.node.model(M.component.tag); % Set as a component definition not global definition
  obj.node.label(obj.tag);
  obj.node.set('frame','geometry');
  obj.node.set('method','none');

  for vacnt=1:(length(varargin)/2)
    paramname=varargin(1+(vacnt-1)/2);
    paramval=varargin(1+(vacnt-1)/2 + 1);
    obj.node.set(paramname,paramval);
    % obj.node.set('bndsnap3','on');   % Snap to boundary
  end

  % This should just be: 
  % obj.node.set('coords3', { coordx, coordy, coordz });
  % ... but for some reason COMSOL 5.0 can't handle this (bug?)
  % so instead we evaluate numerically into strings without units   
  obj.node.setIndex('coords3', coordx,0,0);
  obj.node.setIndex('coords3', coordy,0,1);
  obj.node.setIndex('coords3', coordz,0,2);

  % When a DomainPoint is created it automatically creates a 
  % Displacement Probe that we really don't want (not compatible with
  % our naming scheme)
  tags_cell = cell(obj.node.feature.tags);
  autoprobetagname=tags_cell{1};
  obj.node.feature.remove(autoprobetagname);

  CreateWrappedProperty(M,obj,'displ',[ tag '_displ' ],obj.node.feature,'PointExpr');
  obj.displ.node.label(obj.displ.tag);

  u=[ physicstag 'u' ];
  v=[ physicstag 'v' ];
  w=[ physicstag 'w' ];  

  obj.displ.node.set('expr',[ '((' u ')*(' directionx ') + (' v ')*(' directiony ') + (' w ')*(' directionz '))/(' magnitude_cellstr_array({ directionx, directiony, directionz }) ')']);
  obj.displ.node.set('descr', 'Displacement in specified direction');
  obj.displ.node.set('probename',obj.displ.tag);


  % Create velocity probe
  CreateWrappedProperty(M,obj,'vel',[ tag '_vel' ],obj.node.feature,'PointExpr');
  obj.vel.node.label(obj.vel.tag);

  dudt=[ physicstag '.u_tX' ];
  dvdt=[ physicstag '.u_tY' ];
  dwdt=[ physicstag '.u_tZ' ];  

  obj.vel.node.set('expr',[ '((' dudt ')*(' directionx ') + (' dvdt ')*(' directiony ') + (' dwdt ')*(' directionz '))/(' magnitude_cellstr_array({ directionx, directiony, directionz }) ')']);
  obj.vel.node.set('descr', 'Velocity in specified direction');
  obj.vel.node.set('probename',obj.vel.tag);



end
