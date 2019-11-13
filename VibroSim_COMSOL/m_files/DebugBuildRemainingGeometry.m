function DebugBuildRemainingGeometry(M)

  % Create meshes prior to BuildWithNormals
  MeshSetBounds(M,M.mesh,ObtainDCParameter(M,'meshsizemin','m'),ObtainDCParameter(M,'meshsize','m'));
  MeshRemainingObjects(M,M.geom,M.mesh);

  % Create empty study to find normals
  if ~isprop(M,'normalstudy')
    addprop(M,'normalstudy');
  end
  M.normalstudy=CreateStudy(M,M.geom,'getnormals');
  M.normalstudy.node.run;
  
  % Build all buildlater objects now that we have the normals
  BuildWithNormals(M,M.geom);

  % Now mesh the newly-created objects
  MeshRemainingObjects(M,M.geom,M.mesh);

  % Apply materials to objects
  ApplyMaterials(M,M.geom);
