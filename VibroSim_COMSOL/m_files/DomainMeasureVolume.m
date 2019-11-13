function volume=DomainMeasureVolume(M,geom,domainentities)

%boundary_edges=mphgetadj(M.node,geom.tag,'edge','boundary',boundaryentity);

geom.node.measureFinal.selection.geom(geom.tag,3); % measure in 2-dimensional space
geom.node.measureFinal.selection.set(domainentities);
volume=geom.node.measureFinal.getVolume(); % measure total volume

if volume < 0
  domainentities
  LogMsg(sprintf('DomainMeasureVolume(): Domains show negative net volume %f\nThis could be symptomatic of major problems in the geometry.\n.',volume),1);
  dbstack;  % show stack trace
end