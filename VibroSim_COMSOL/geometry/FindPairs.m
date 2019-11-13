%> Find and return identify contact or identity pairs referring to
%> the face (boundary) entities returned by faceselectionfunc(M,geom,object)
%> returned pairs are identified by their tag names
function  pairs=FindPairs(M,geom,object,faceselectionfunc);

% Look up entity numbers corresponding to entities returned by faceselectionfunc

%faceselection=mphgetselection(M.node.selection(namedfaceselection));
%faceentities=faceselection.entities;
faceentities=faceselectionfunc(M,geom,object);

pairs={};
pairtagnames=M.node.pair.tags();


for cnt=1:length(pairtagnames)
  pairtagname=pairtagnames(cnt); % pairtagnames is java.lang.string array, so we reference it with regular parentheses, not braces
  
  % look up source and destination of this contact or identify pair
  source=M.node.pair(pairtagname).source;
  source_entities=source.entities(source.dimension);

  destination=M.node.pair(pairtagname).destination;
  destination_entities=destination.entities(destination.dimension);

  % look to see if any of souce_entities or destination_entities
  % match the face entities
  matches=intersect(faceentities,union(source_entities,destination_entities));

  % faceentities 
  % source_entities
  % destination_entities

  if length(matches) > 0
    % got a match, therefore this contact pair corresponds to faceselection
    pairs{length(pairs)+1}=pairtagname;
  end
end

%pairs{1}