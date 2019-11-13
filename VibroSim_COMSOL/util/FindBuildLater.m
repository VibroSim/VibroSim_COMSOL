%> function [sortedobjects]=FindBuildLater(M,buildlaterclass)
%> function [sortedobjects]=FindBuildLater(M,buildlaterclass,includebuilt)
%>
%> Find and return a cell array of all of the BuildLater objects matching
%> the specified class. Only those that have not been built are
%> returned unless 'includebuilt' is passed as true.
%>
%> Also sorts by index, so results are in a consistent order
%>
%> AFTER YOU BUILD EACH OBJECT DON'T FORGET TO SET object.is_built!!!
function [sortedobjects]=FindBuildLater(M,buildlaterclass,includebuilt)

global WrappedObjectDB;

if ~exist('includebuilt','var')
  includebuilt=false;
end


objects={};
indexes=[];

if ~exist('WrappedObjectDB','var')
  WrappedObjectDB=struct;
end

WrappedObjectTags=fieldnames(WrappedObjectDB);

for cnt=1:length(WrappedObjectTags)
  WrappedObject=WrappedObjectDB.(WrappedObjectTags{cnt});

  if isa(WrappedObject,'BuildLater') & (includebuilt | ~WrappedObject.is_built)
    % Found a BuildLater object that is unbuilt (or we're including even unbuilt objects)
    for classcnt=1:length(WrappedObject.buildlaterclasses)
      if strcmp(WrappedObject.buildlaterclasses{classcnt},buildlaterclass)
	% Found a class match!
	resultindex=length(objects)+1;
	objects{resultindex}=WrappedObject;
	indexes(resultindex)=WrappedObject.index;
	break;  % Go on to next object
      end
    end
  end
end

[junk,sortorder]=sort(indexes);

sortedobjects={};

for resultcnt=1:length(indexes)
  sortedobjects{resultcnt}=objects{sortorder(resultcnt)};
end

