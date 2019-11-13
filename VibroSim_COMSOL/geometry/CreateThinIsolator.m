function [isolator] = CreateThinIsolator(M,geom,tag,specimen,shape,pos,normalvec,angle)

if ~exist('angle','var')
  angle=0;
end


isolator=ModelWrapper(M,tag);

BuildThinIsolator(M,geom,isolator,specimen,shape,pos,normalvec,angle);


