%> function DebugTryFlawFunc(M,flawfunc)
%> You can call this after manually creating geometry to see if your FlawFunc
%> runs OK.
function DebugTryFlawFunc(M,flawfunc)

if ~isprop(M,'specimen')
  % Set 'specimen' property as is usually done after creating geometry.
  addprop(M,'specimen');
  M.specimen=FindWrappedObject('specimen');
end

M.flaw=flawfunc(M,M.geom,M.specimen);
