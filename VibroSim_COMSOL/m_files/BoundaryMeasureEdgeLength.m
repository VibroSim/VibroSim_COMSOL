function length=BoundaryMeasureEdgeLength(M,geom,boundaryentity)

boundary_edges=mphgetadj(M.node,geom.tag,'edge','boundary',boundaryentity);

% Measure the length of the edges
geom.node.measureFinal.selection.geom(geom.tag,1); % measure in 1-dimensional space
geom.node.measureFinal.selection.set(boundary_edges);
length=geom.node.measureFinal.getVolume(); % measure total area
