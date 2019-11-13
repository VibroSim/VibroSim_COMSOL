%> Create a fixed boundary condition for a face identified via a selection function
function bcobj = BuildFaceFixedBC(M,geom,physics,object,bcobj,getfaceselectionfunc)

  bcobj.parent=physics.node.feature; % store what to call to remove this object
  bcobj.node=physics.node.feature.create(bcobj.tag,'Fixed',2);  % 2 is the dimensionality
  bcobj.node.label(bcobj.tag);

  faceentities=getfaceselectionfunc(M,geom,object);

  bcobj.node.selection.set(faceentities);


