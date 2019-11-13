function bcobj = BuildFaceSpringFoundationBC(M,geom,physics,object,bcobj,getfaceselectionfunc,k_A,DampPerArea)
% Create a spring foundation boundary condition for a face identified via a selection function
%
% k_A, DampPerArea can be matrices, read out in Fortran order

  BuildWrappedModel(M,bcobj,physics.node.feature,'SpringFoundation2',2);
  bcobj.node.label(bcobj.tag);

  faceentities=getfaceselectionfunc(M,geom,object);

  bcobj.node.selection.set(faceentities);

  bcobj.node.set('SpringType','kPerArea');
  bcobj.node.set('kPerArea',k_A);

  if exist('DampPerArea','var')
    bcobj.node.set('ViscousType','DampPerArea');
    bcobj.node.set('DampPerArea',DampPerArea);
  end

