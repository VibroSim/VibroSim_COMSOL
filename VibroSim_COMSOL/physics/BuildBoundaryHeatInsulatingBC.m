%> Create a boundary condition representing no heatflow permitted across a boundary.
function bcobj = BuildBoundaryHeatInsulatingBC(M,geom,physics,object,bcobj,getfaceselectionfunc)

  bcobj.parent=physics.node.feature; % store how to remove this object

  bcobj.node=physics.node.feature.create(bcobj.tag,'ThermalInsulation',2);  % 2 is the dimensionality
  bcobj.node.label(bcobj.tag);

  faceentity=getfaceselectionfunc(M,geom,object);
  bcobj.node.selection.set(faceentity);
