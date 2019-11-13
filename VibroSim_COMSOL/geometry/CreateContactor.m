%> NOTE: For now normalvec must be numeric because the face identification algorithm
%> operates numerically.

%> NOTE: Does not specify material or meshing
function [contactor] = CreateContactor(M,geom,tag,shape,pos,normalvec,angle,leng,width,thickness)


  contactor=ModelWrapper(M,tag);
  BuildContactor(M,geom,contactor,shape,pos,normalvec,angle,leng,width,thickness);

