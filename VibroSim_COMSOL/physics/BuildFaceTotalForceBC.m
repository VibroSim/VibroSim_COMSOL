%> Create a boundary condition representing the total force vector on a face.
%> if isharmonicperturbation (optional) is true, the harmonicPerturbation flag
%> will be set to enable this for frequency studies
function bcobj = BuildFaceTotalForceBC(M,geom,physics,object,bcobj,getfaceselectionfunc,forcevec,isharmonicperturbation)


  if ~exist('isharmonicperturbation','var')
    isharmonicperturbation=false;
  end


  bcobj.parent=physics.node.feature; % store how to remove this object
  bcobj.node=physics.node.feature.create(bcobj.tag,'BoundaryLoad',2);  % 2 is the dimensionality ... we might need to concatenate it into the string
  bcobj.node.label(bcobj.tag);

  faceentities=getfaceselectionfunc(M,geom,object);
  bcobj.node.selection.set(faceentities);


  bcobj.node.set('LoadType','TotalForce');
  bcobj.node.set('Ftot',forcevec);

  if isharmonicperturbation
    bcobj.node.set('harmonicPerturbation','1');
  else
    bcobj.node.set('harmonicPerturbation','0');
  end

