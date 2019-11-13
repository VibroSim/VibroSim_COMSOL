function [contactor] = CreateThinContactor(M,geom,tag,specimen,shape,pos,normalvec,angle,leng,width)
  % NOTE: For now normalvec must be numeric because the face identification algorithm
  % operates numerically. 

  % NOTE: Does not specify material or meshing

  contactor=ModelWrapper(M,tag);
BuildThinContactor(M,geom,contactor,specimen,shape,pos,normalvec,angle,leng,width);

