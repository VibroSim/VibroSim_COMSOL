function BuildBoundaryConditions(M,geom,physics,physicsclass)




  
BCobjects=FindBuildLater(M,[ 'bctemplate_' physicsclass ]);

% for all the objects
for objectcnt=1:length(BCobjects)
  origbcobj=BCobjects{objectcnt};

  % origbcobj is a BuildLater object

  % Clone origbcobj into a regular ModelWrapper
  % origbcobj tag should have a suffix of '_' physicsclass '_bct'
  suffix=[ '_' physicsclass '_bct'];
  assert(strcmp(origbcobj.tag((length(origbcobj.tag)-length(suffix)+1):length(origbcobj.tag)),suffix));
  tagbase=origbcobj.tag(1:(length(origbcobj.tag)-length(suffix))); % tag without suffix

  % new tag is [ tagbase '_' physics.tag ]
  bcobj=BuildLater(M,[ tagbase '_' physics.tag ],[ 'bcinstance_' physics.tag ],origbcobj.buildfcn);
  % copy classnames field
  addprop(bcobj,'classnames');
  bcobj.classnames=origbcobj.classnames;

  % bcobj.classnames  is a cell array of class names
  % bcobj.tag tag name)
  % and bcobj.buildfcn  (anonymous build function) parameters

  % Now that we've created this BuildLater object (so that stuff can 
  % be found later in SelectBoundaryConditionsForStudyStep()), 
  % build it immediately -- call previously provided function
  % and have it operate on our newly generated bcobj
  bcobj.buildfcn(M,physics,bcobj);
  bcobj.is_built=true;   

  % Add to children of origbcobj
  origbcobj.children{length(origbcobj.children)+1}=bcobj;
  % origbcobj NEVER gets 'built'
 
end
