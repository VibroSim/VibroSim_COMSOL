function [couplant] = CreateThinCouplant(M,geom,tag,specimen,shape,pos,normalvec,angle)

if ~exist('angle','var')
  angle=0;
end

couplant=ModelWrapper(M,tag);

BuildCouplant(M,geom,couplant,specimen,shape,pos,normalvec,angle);
