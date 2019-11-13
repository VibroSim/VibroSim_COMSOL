%> Identify and return those of the provided boundary entities which have an
%> outward normal matching (99%) outwardnormal
function [desiredboundaryentities]=GetNormalBoundaries(M,geom,boundaryentities,centerpos,outwardnormal)

desiredboundaryentities=[];

% For each boundary entity...
for boundarycnt=1:length(boundaryentities)
  thisboundaryentity=boundaryentities(boundarycnt);

  % Find it's adjacent vertex points
  thisboundarypoints=mphgetadj(M.node,geom.tag,'point','boundary',thisboundaryentity);
  vertexcoord=geom.node.getVertexCoord();

  % We find the normal from the cross-product between two in-plane vectors
  % thisboundarypoints
  % thisboundarypoints(1)
  % thisboundarypoints(2)
  % thisboundarypoints(3)
  % size(vertexcoord)
  vectora=vertexcoord(:,thisboundarypoints(2))-vertexcoord(:,thisboundarypoints(1));
  vectorb=vertexcoord(:,thisboundarypoints(3))-vertexcoord(:,thisboundarypoints(1));
  
  normal=cross(vectora,vectorb);

  normalhat=normal/norm(normal); % obtain unit vector 
  % normalhat is normal to thisboundary, but it is not 
  % necessarily outward. 

  % Take the dot product of normalhat with the vector 
  % from the center to one of the points on this face. 
  % if negative, we negate -- ensuring that the new
  % normalhat is outward pointing
  if (normalhat.') * (vertexcoord(:,thisboundarypoints(1))-centerpos) < 0
    normalhat=-normalhat;
  end

  % See if normalhat and outwardnormal are in the same direction
  % to 99% accuracy
  if abs(norm(outwardnormal)-(normalhat.')*outwardnormal) < .01
    desiredboundaryentities(length(desiredboundaryentities)+1)=thisboundaryentity;
  end
end
