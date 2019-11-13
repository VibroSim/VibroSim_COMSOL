%> To debug a physicsfunc, set any extrinsic variables, then call:
%> Execute your script up to where the PhysicsFunc (bldphysics) is defined, then call:
%> [M,geom,specimen,flaw]=DebugPhysicsFunc(M,geometryfunc,flawfunc)
%> (flawfunc, as usual, is optional)
%> Then you can copy and paste your code.
function [M,geom,specimen,flaw]=DebugPhysicsFunc(M,geometryfunc,flawfunc)

  WrappedObjectDebug(true);  % set debug mode

  % Build Geometry
  [geom,mesh] = CreateGeometryNode(M,'Geom','Mesh',3);
  SetGeometryFinalization(M,geom,'assembly',true);

  % call geometry function
  specimen=geometryfunc(M,geom,'specimen');

  addprop(M,'specimen');
  M.specimen=specimen;

  % run flawfunc, if provided
  addprop(M,'flaw');
  if exist('flawfunc','var') & ~strcmp(class(flawfunc),'double')      
    M.flaw=flawfunc(M,geom,specimen);
    flaw=M.flaw;
  else
    flaw=[]
  end

  % Create meshes prior to BuildWithNormals
  MeshSetBounds(M,M.mesh,ObtainDCParameter(M,'meshsizemin','m'),ObtainDCParameter(M,'meshsize','m'));
  MeshRemainingObjects(M,M.geom,M.mesh);


  % Create empty study to find normals
  addprop(M,'normalstudy');
  M.normalstudy=CreateStudy(M,geom,'getnormals');
  M.normalstudy.node.run;


  % Build all buildlater objects now that we have the normals
  BuildWithNormals(M,geom);

  % Now mesh the newly-created objects
  MeshRemainingObjects(M,M.geom,M.mesh);


  % Apply materials to objects
  ApplyMaterials(M,geom);

% now ready for Physics creation!
