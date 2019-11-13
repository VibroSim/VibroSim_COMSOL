%> Mesh a block or similar object using datacollect parameters
%> prefixed by dcprefix.
%> Parameters:
%>  @param M: the class ModelWrapper containing our representation of the model
%>  @param geom: the ModelWrapper containing our representation of the geometry
%>  @param mesh: the ModelWrapper containing our representation of the top level mesh object
%>  @param object: The ModelWrapper containing our block
%>  @param meshobj: The ModelWrapper or BuildLater object to build
%>  @param dcprefix: prefix on datacollect parameters, e.g. 'spc' for specimen
%>  @param domainselectionfunct: function returning domain entities to be meshed
%>  @param namededgesselectiontag: name of selection corresponding to edges of domain to be meshed
%>  @param sourcefaceselectionfunc: function returning source face boundary entities
%>  @param targetfaceselectionfunc: function returning target face boundary entities
%>  @param sweep_use_distributions (true/false, optional default false): Should we
%>                                 Create the edge distributions to bound the element size
%>                                 along edges when using the sweep?
%>
%>  (note: object and namededgeselectiontag are not currently used, except object
%>  is passed to another function that doesn't use it)
%>
%> If the given mesh type (dcprefix 'meshtype') is 'TETRAHEDRAL' then a
%> simple FreeTet object is created. Otherwise the mesh type should be
%> HEXAHEDRAL. In this case the meshing is done through a sweep from
%> the specified source face to the specified target face.
%> datacollect parameters:
%>   dcprefix 'meshtype':   TETRAHEDRAL or HEXAHEDRAL
%>   dcprefix 'facemethod': For HEXAHEDRAL, 'FreeTri', 'FreeQuad', or 'Map
%>   dcprefix 'meshsize':   For HEXAHEDRAL, Meshing size, in the sweep source/target face planes
%>   dcprefix 'sweepelements': For HEXAHEDRAL, Number of elements in the sweep direction
function meshobj=BuildMeshDCObject(M,geom,mesh,object,meshobj,dcprefix,domainselectionfunc,namededgesselectiontag,sourcefaceselectionfunc,targetfaceselectionfunc,sweep_use_distributions)

  if ~exist('sweep_use_distributions','var')
    sweep_use_distributions=false;
  end


  meshtype=GetDCParamStringValue(M,[ dcprefix 'meshtype' ]);


  if strcmp(upper(meshtype.repr),'TETRAHEDRAL')
    %meshsize = GetDCParamNumericValue(M,[ dcprefix 'meshsize'], 'm');
    meshsize=ObtainDCParameter(M,[ dcprefix 'meshsize'], 'm');
    BuildMeshFreeTet(M,geom,mesh,object,meshobj,[],meshsize,domainselectionfunc);
    
  elseif strcmp(upper(meshtype.repr),'HEXAHEDRAL')
    facemethod=GetDCParamStringValue(M,[ dcprefix 'facemethod' ]); 
    %meshsize = GetDCParamNumericValue(M,[ dcprefix 'meshsize'], 'm');
    meshsize=ObtainDCParameter(M,[ dcprefix 'meshsize'], 'm');
    %sweepelements = GetDCParamNumericValue(M,[ dcprefix 'sweepelements']);
    sweepelements = ObtainDCParameter(M,[ dcprefix 'sweepelements'],'');

    BuildMeshSweep(M,geom,mesh,object,meshobj,facemethod.repr,meshsize,sweepelements,domainselectionfunc,namededgesselectiontag,sourcefaceselectionfunc,targetfaceselectionfunc,sweep_use_distributions);

    
  else
    error('CreateMesh:MeshTypeError', ['Mesh type "', mesh.type, '" not implemented']);
  end


