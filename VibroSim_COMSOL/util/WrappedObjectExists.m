%> Determine whether a tagged object of the specified tag exists
function exists=WrappedObjectExists(M,tag)

global WrappedObjectDB;


if ~exist('WrappedObjectDB','var')
  WrappedObjectDB=struct;
end

if isfield(WrappedObjectDB,tag)  
  exists=true;
else
  exists=false;
end

