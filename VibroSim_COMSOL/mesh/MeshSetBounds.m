%> Also set the min and max parameters of the
%> automatic global mesh size object
function MeshSetBounds(M,mesh,sizemin,sizemax)

  % global mesh size object was extracted and placed as mesh.size
  % in CreateGeometryNode()

  if ~isprop(M.mesh,'size')
    addprop(M.mesh,'size');
  end

  if ~string_in_cellstr_array('size',to_cellstr_array(M.mesh.node.feature.tag))
    % For some reason the default 'size' feature hasn't been created (?)
    % Create a junk size feature
    M.mesh.node.feature.create('JunkSize','Size');
    % now delete it, leaving the auto-created size node behind
    M.mesh.node.feature.remove('JunkSize');
  end
  M.mesh.size=M.mesh.node.feature('size'); % automatically-created default size node
  


  mesh.size.set('hmax',sizemax);
  mesh.size.set('hmin',sizemin);

