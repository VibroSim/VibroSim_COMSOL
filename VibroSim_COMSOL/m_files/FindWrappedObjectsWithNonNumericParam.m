function [sortedobjects]=FindWrappedObjectsWithNonNumericParam(M,paramname)
%
% Also sorts by index, so results are in a consistent order

global WrappedObjectDB;

objects={};
indexes=[];

if ~exist('WrappedObjectDB','var')
  WrappedObjectDB=struct;
end

WrappedObjectNames=fieldnames(WrappedObjectDB);

for cnt=1:length(WrappedObjectNames)
  WrappedObject=WrappedObjectDB.(WrappedObjectNames{cnt});

  if isprop(WrappedObject,paramname)
    if ~strcmp(class(WrappedObject.(paramname)),'double')
      resultindex=length(objects)+1;
      objects{resultindex}=WrappedObject;
      indexes(resultindex)=WrappedObject.index;
    end
  end
end

[junk,sortorder]=sort(indexes);

sortedobjects={};

for resultcnt=1:length(indexes)
  sortedobjects{resultcnt}=objects{sortorder(resultcnt)};
end

