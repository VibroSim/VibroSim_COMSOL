%> Create a boundary condition representing heatflow permitted across a boundary. Please note that this can only be specified across objects in an assembly, not within a union. Because insulating is the default boundary condition, we have to find the automatically-generated pair objects and create continuity boundary conditions referencing them 
function bcobj = BuildBoundaryHeatConductivePairBC(M,geom,physics,object,bcobj,getfaceselectionfunc)


  entities=getfaceselectionfunc(M,geom,object);
  
  pairtbl=containers.Map();

  for cnt=1:length(entities)
    %geom.bndpairdb_byboundary.keys()
    %entities(cnt)
    pairname=geom.bndpairdb_byboundary(int64(entities(cnt))); % If you get a keyerror or similar here, you probably forgot to turn on create selections, or the specified boundary has no pair
    if pairtbl.isKey(pairname)  
      pairtbl(pairname)=[pairtbl(pairname) entities(cnt)];
    else
      pairtbl(pairname)=entities(cnt);
    end
  end

  % Create continuity pairs

  addprop(bcobj,'continuitypairs');
  bcobj.continuitypairs={};

  pairnames=pairtbl.keys();  

  for cnt=1:length(pairnames)
    bcobj.continuitypairs{cnt}=CreateWrappedModel(M,sprintf('%s_contpair%3.3d',bcobj.tag,cnt),physics.node.feature,'Continuity',2);
    bcobj.continuitypairs{cnt}.node.setIndex('pairs',pairnames{cnt},0);
    
  end
