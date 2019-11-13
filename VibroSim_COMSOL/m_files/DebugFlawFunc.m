%> To debug a flawfunc, set any extrinsic variables, 
%> Execute your script up to where the FlawFunc (bldcrack) is defined, then call:
%> [M,geom,specimen,tag]=DebugFlawFunc(M,geometryfunc,tag,flawfunc)
%> (flawfunc, as usual, is optional)
%> Then you can copy and paste your code.
function [M,geom,specimen,tag]=DebugFlawFunc(M,GeometryFunc,tag,flawfunc)

  WrappedObjectDebug(true);  % set debug mode

  % Build Geometry
  [geom,mesh] = CreateGeometryNode(M,'Geom','Mesh',3);
  SetGeometryFinalization(M,geom,'assembly',true);

  % call geometry function
  global specimen
  specimen=geometryfunc(M,geom,'specimen');

  addprop(M,'specimen');
  M.specimen=specimen;

  % run flawfunc, if provided
  global flaw
  addprop(M,'flaw');
  if exist('flawfunc','var') & ~strcmp(class(flawfunc),'double')      
    M.flaw=flawfunc(M,geom,specimen);
    flaw=M.flaw;
  else
    flaw=[];
  end

