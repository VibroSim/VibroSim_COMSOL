%> function node=CreateOrReplace(parent,tag,type,...)
%> Remove any existing COMSOL child of parent with the specified tag. Then create a new
%> COMSOL node with the specified tag and type
function node=CreateOrReplace(parent,tag,varargin)



% Remove preexisting conflicting tag(s)...
existingtags=to_cellstr_array(parent.tags);
for cnt=1:length(existingtags)
  if strcmp(existingtags{cnt},tag)
    % Found match! Remove it.
    parent.remove(existingtags{cnt});
  end
end

% Create new tag
node=parent.create(tag,varargin{:});
