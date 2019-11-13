function [couplant] = CreateCouplant(M,geom,tag,shape,pos,normalvec,angle)

if ~exist('angle','var')
  angle=0;
end

couplant=ModelWrapper(M,tag);

BuildCouplant(M,geom,couplant,shape,pos,normalvec,angle);
