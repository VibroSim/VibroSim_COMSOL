%> Add a mesh size property to meshobj.
%> Parameters:
%>  @param M:    the ModelWrapper containing our representation of the model
%>  @param geom: the ModelWrapper containing our representation of the geometry
%>  @param mesh: the ModelWrapper containing our representation of the top level mesh object
%>  @param meshobj: The meshing object to get the new property. This MUST be the
%>                  the object you want the size applied to (can't be an ancestor) as
%>                  it is used to extract the parent.
%>  @param propname: Name of new property (typically 'size')
%>  @param tag:  Tag -- typically [tag '_size']
%>  @param meshsizemin: minimum mesh element size, or [] to disable
%>  @param meshsize: maximum mesh element size, or [] to disable
%>  @param dimensionality: 2 if parent is meshing a boundary, 3 if a domain
%>  @param entities: boundary or domain entities.
function sizeobj=CreateMeshSizeProperty(M,geom,mesh,meshobj,propname,tag,meshsizemin,meshsize,dimensionality,entities)

sizeobj=CreateWrappedProperty(M,meshobj,propname,tag,meshobj.node.feature,'Size');

sizeobj.node.label(sizeobj.node.tag);
sizeobj.node.set('custom','on'); % custom size, not preset size

sizeobj.node.selection.geom(geom.tag,dimensionality); % set dimensionality
sizeobj.node.selection.set(entities); % apply to supplied entities

if (~isa(meshsize,'double') & ~isa(meshsize,'cell')) | prod(size(meshsize))
    % set meshsize if its not a double or cell array, or if its size > 0
  sizeobj.node.set('hmaxactive','on'); % limit maximum element size
  sizeobj.node.set('hmax',meshsize); % set size limit
end

if (~isa(meshsizemin,'double') & ~isa(meshsizemin,'cell')) | prod(size(meshsizemin))
  % set meshsize if its not a double or cell array, or if its size > 0
  sizeobj.node.set('hminactive','on'); % limit maximum element size
  sizeobj.node.set('hmin',meshsizemin); % set size limit
end

