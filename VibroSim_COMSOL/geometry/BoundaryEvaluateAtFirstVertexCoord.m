function res=BoundaryEvaluateAtFirstVertexCoord(M,geom,boundaryentity,fcn)

% Get boundary vertices
boundary_vertices=mphgetadj(M.node,geom.tag,'point','boundary',boundaryentity);
vertexcoords=geom.node.getVertexCoord();
vertexcoord=vertexcoords(:,boundary_vertices(1));
res=fcn(vertexcoord);
