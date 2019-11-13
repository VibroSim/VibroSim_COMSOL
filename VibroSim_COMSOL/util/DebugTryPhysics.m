%> function DebugTryPhysicsFunc(M,physicsfunc)
%> You can call this after manually creating geometry and running
%> DebugBuildRemainingGeometry() to see if your boundary conditions
%> get built OK
function DebugTryPhysics(M,physicsstudyfunc)

if ~isprop(M,'specimen')
  % Set 'specimen' property as is usually done after creating geometry.
  addprop(M,'specimen');
  M.specimen=FindWrappedObject('specimen');
end

physicsstudyfunc(M,M.geom,M.specimen,M.flaw);
