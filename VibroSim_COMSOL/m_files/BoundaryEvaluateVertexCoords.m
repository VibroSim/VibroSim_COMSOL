%> returns matrix of column vectors, each representing vertex coords
function vertexcoords=BoundaryEvaluateVertexCoords(M,geom,boundaryentity)

% Get boundary vertices
boundary_vertices=mphgetadj(M.node,geom.tag,'point','boundary',boundaryentity);
allvertexcoords=geom.node.getVertexCoord();

vertexcoords=allvertexcoords(:,boundary_vertices);
