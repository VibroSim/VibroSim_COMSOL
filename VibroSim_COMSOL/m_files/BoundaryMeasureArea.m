function area=BoundaryMeasureArea(M,geom,boundaryentities)

%boundary_edges=mphgetadj(M.node,geom.tag,'edge','boundary',boundaryentity);

geom.node.measureFinal.selection.geom(geom.tag,2); % measure in 2-dimensional space
geom.node.measureFinal.selection.set(boundaryentities);
area=geom.node.measureFinal.getVolume(); % measure total area
