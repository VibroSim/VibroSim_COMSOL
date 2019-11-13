function boundaries=FindContactBoundaries(M,geom,domain1entities, domain2entities)

domain1boundaries=mphgetadj(M.node,geom.tag,'boundary','domain',domain1entities);
domain2boundaries=mphgetadj(M.node,geom.tag,'boundary','domain',domain2entities);

boundaries=intersect(domain1boundaries,domain2boundaries);

