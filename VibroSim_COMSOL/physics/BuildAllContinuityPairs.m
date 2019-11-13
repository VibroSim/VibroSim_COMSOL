function bcobj = BuildAllContinuityPairs(M,geom,physics,object,bcobj)
%Build all remaining identity pairs into continuity boundary conditions for
%the supplied physics and geometry. Use this as the buildfcn during complex
%geometry import and assembly with AddBoundaryCondition to supply
%continuity conditions to ALL identity pairs within a model. Using with
%AddBoundaryCondition will create a BuildLater class for the supplied bcs.
% Returns a cell array of boundary conditions

  contnodetags=M.node.pair.tags();
  
  for ii=1:1:length(contnodetags)
    pairs{ii}=contnodetags(ii);
  end
 

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
