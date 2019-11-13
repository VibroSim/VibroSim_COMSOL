%> Mesh an object using Free Tetrahedral meshing
%> Parameters:
%>  @param M:    the ModelWrapper containing our representation of the model
%>  @param geom: the ModelWrapper containing our representation of the geometry
%>  @param mesh: the ModelWrapper containing our representation of the top level mesh object
%>  @param object: The ModelWrapper containing our block
%>  @param meshobj: The ModelWrapper or BuildLater to store the mesh in
%>  @param meshsizemin: minimum mesh element size, or [] to disable
%>  @param meshsize: maximum mesh element size, or [] to disable
%>  @param domainselectionfunc: function returning domain entities to be meshed
function meshobj=BuildMeshFreeTet(M,geom,mesh,object,meshobj,meshsizemin,meshsize,domainselectionfunc)


  meshobj.parent=mesh.node.feature; % Store how to remove this mesh
  meshobj.node=mesh.node.feature.create(meshobj.tag,'FreeTet');
  meshobj.node.label(meshobj.tag);
  %domain=mphgetselection(M.node.selection(nameddomainselectiontag));
  domain=domainselectionfunc(M,geom,object);
  meshobj.node.selection.set(domain);

  % Create the Size object
  CreateMeshSizeProperty(M,geom,mesh,meshobj,'size',[meshobj.tag '_size'],meshsizemin,meshsize,3,domain);

  
