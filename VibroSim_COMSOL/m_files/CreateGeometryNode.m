%> CREATEGEOMETRYNODE Creates a New Geometry and Mesh Node in a Given Model
%>   [geom,mesh] = CREATEGEOMETRYNODE(M,tag,meshtag,ndim) Creates a New mD Geometry with Provided Tag names
function [geom,mesh] = CreateGeometryNode(M,tag,meshtag,ndim)

  % Create Geometry if it doesn't already exist (may have been loaded in from an mph file)

  if ~isprop(M,'geom') | isa(M.geom,'double')
    % Add geometry to top level object
    addprop(M,'geom');

    M.geom=ModelWrapper(M,tag);
    M.geom.node=M.node.geom.create(M.geom.tag, ndim);

  end
  geom=M.geom;

  % Create top-level Meshing Node for Geometry
  % addprop(M,'mesh');  % all wrapped objects have a .mesh property (defined in ModelWrapper)

  if isa(M.mesh,'double')
    % Need to define mesh
    M.mesh=ModelWrapper(M,meshtag);
    M.mesh.node=M.node.mesh.create(M.mesh.tag, geom.tag);
  end

  mesh=M.mesh;

end
