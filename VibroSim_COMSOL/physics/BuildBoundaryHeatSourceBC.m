%> Create a boundary condition representing a heat source  on a face.
function bcobj = BuildBoundaryHeatSourceBC(M,geom,physics,object,bcobj,getfaceselectionfunc,heatflowQb)

  bcobj.parent=physics.node.feature; % store how to remove this object

  bcobj.node=physics.node.feature.create(bcobj.tag,'BoundaryHeatSource',2);  % 2 is the dimensionality
  bcobj.node.label(bcobj.tag);

  faceentity=getfaceselectionfunc(M,geom,object);
  bcobj.node.selection.set(faceentity);
  bcobj.node.set('Qb',heatflowQb);
