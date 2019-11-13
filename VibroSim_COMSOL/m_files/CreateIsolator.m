function [isolator] = CreateIsolator(M,geom,tag,shape,pos,normalvec,angle)

if ~exist('angle','var')
  angle=0;
end


isolator=ModelWrapper(M,tag);

BuildIsolator(M,geom,isolator,shape,pos,normalvec,angle);


