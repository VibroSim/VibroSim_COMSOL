%> Identify and return those of the provided edge entities which have an
%> vector matching direc (99%) 
function [desirededgeentities]=GetParallelEdges(M,geom,edgeentities,direc)

desirededgeentities=[];

% For each edge entity...
for edgecnt=1:length(edgeentities)
  thisedgeentity=edgeentities(edgecnt);

  % Find it's adjacent vertex points
  thisedgepoints=mphgetadj(M.node,geom.tag,'point','edge',thisedgeentity);
  vertexcoord=geom.node.getVertexCoord();

  % We find the normal from the cross-product between two in-plane vectors
  % thisboundarypoints
  % thisboundarypoints(1)
  % thisboundarypoints(2)
  % thisboundarypoints(3)
  % size(vertexcoord)
  vector=vertexcoord(:,thisedgepoints(2))-vertexcoord(:,thisedgepoints(1));
  
  vectorhat=vector/norm(vector); % obtain unit vector 

  % Take the dot product of vectorhat with direchat

  parallelcomponent=vectorhat.'*(direc/norm(direc));

  % from the center to one of the points on this face. 
  % if negative, we negate -- ensuring that the new
  % normalhat is outward pointing
  if parallelcomponent < 0
    parallelcomponent=-parallelcomponent;
  end

  % See if vector and direc are in the same direction
  % to 99% accuracy
  if parallelcomponent >= .99
    desirededgeentities(length(desirededgeentities)+1)=thisedgeentity;
  end
end
