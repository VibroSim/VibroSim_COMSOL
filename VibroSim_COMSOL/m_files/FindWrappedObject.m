function [object]=FindWrappedObject(M,tagname)

global WrappedObjectDB;


if ~exist('WrappedObjectDB','var')
  WrappedObjectDB=struct;
end

if isfield(WrappedObjectDB,tagname)  
  object=WrappedObjectDB.(tagname);
else
  error(sprintf('FindWrappedObject: Object ''%s'' does not exist in database',tagname))
end
