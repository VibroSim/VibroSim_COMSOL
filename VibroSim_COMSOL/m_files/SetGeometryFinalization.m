%> Set_Geometry_Finalization selects the geometry finalization action:
%> 'union' vs 'assembly'.
%> You can also optionally select whether, for an assembly, to create pairs and whether
%> the pairs should be 'identity' pairs or 'contact' pairs
%> Also runs the geometry
function  SetGeometryFinalization(M,geom,action,createpairs,pairtype)

  if ~exist('createpairs','var')
    createpairs=true;
  end

  if ~exist('pairtype','var')
    pairtype='identity';
  end

  % The geometry finalization object was created with the geometry, and
  % is always named 'fin'
  geom.node.feature('fin').name(['Form ' action]);
  geom.node.feature('fin').set('action',action);

  % Optional, create pairs
  if createpairs
    geom.node.feature('fin').set('createpairs','on');
    geom.node.feature('fin').set('pairtype',pairtype);
  end

  geom.node.run;
    
end
