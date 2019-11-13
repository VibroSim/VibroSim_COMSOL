%> To debug or interactively develop a geometryfunc, set any extrinsic variables, 
%> Execute your script up to where the GeometryFunc (bldgeom) is defined, then call:
%> [M,geom,tag]=DebugGeometryFunc(M,'specimen',GeometryFunc);  (GeometryFunc is optional)
%> Then you can copy and paste your code.
%> When done, you can try DebugTryFlawFunc() and/or
%> DebugBuildRemainingGeometry() and/or DebugTryPhysics()
function [M,geom,tag]=DebugGeometryFunc(M,tag,GeometryFunc)

  WrappedObjectDebug(true);  % set debug mode

  % Build Geometry
  [geom,mesh] = CreateGeometryNode(M,'Geom','Mesh',3);
  SetGeometryFinalization(M,geom,'assembly',true);
  
  % run geometryfunc, if provided
  addprop(M,'specimen');
  global specimen

  if exist('GeometryFunc','var') & ~strcmp(class(GeometryFunc),'double')      
    M.specimen=GeometryFunc(M,geom);
    specimen=M.specimen;
  else
    specimen=[];
  end
