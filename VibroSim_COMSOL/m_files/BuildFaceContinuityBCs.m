%> Build a set of continuity boundary conditions for a selection that
%> presumably has  identity contact pairs with another object.
%>
%> We error out if no such pair is found.
%>
%> Returns a cell array of boundary conditinos
function bcobj = BuildFaceContinuityBCs(M,geom,physics,object,bcobj,getfaceselectionfunc)

  pairs=FindPairs(M,geom,object,getfaceselectionfunc);
  if length(pairs)==0
    error(sprintf('BuildFaceContinuityBC: Could not find contact/identity pair attached to face of object %s. Perhaps object is not quite in contact.',object.tag));
  end

  bcobj.children={};

  for cnt=1:length(pairs)

    bc=ModelWrapper(M,sprintf('%s%.2d',bcobj.tag,cnt),physics.node.feature);

    bc.node=physics.node.feature.create(bc.tag,'Continuity',2);  % 2 is the dimensionality
    bc.node.label(bc.tag);


    %bc.node.set('pairs',pairs);
    %pairs
    %pairs{1}
    bc.node.setIndex('pairs',pairs{cnt},0);

    bcobj.children{length(bcobj.children)+1}=bc;
  end

  %bcs=bcobj.children;
