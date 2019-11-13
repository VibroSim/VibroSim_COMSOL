%> Get the normal vector at the closest boundary node to pos, flipped
%> to point away from refpos. To get the outward normal from a convex object,
%> refpos should be a point inside (not on the surface of) the object.
%> Note that this doesn't necessarily guarantee which geometric object the normal
%> comes from, so you might still get the wrong normal if you aren't careful
%>
%> THIS FUNCTION MAY ONLY BE CALLED ONCE GEOM IS MESHED AND getnormals STUDY COMPLETED
%>
%> So far, this works only on numeric vectors pos and refpos
function [normal,numpos]=GetOutwardNormal(M,geom,pos,refpos)

[normal,numpos]=GetNormal(M,geom,pos);

numrefpos=to_numeric_vector(M,refpos,'m');

vectorfromrefpos=numpos-numrefpos;

% take dot product of normal with vectorfromrefpos
% if the normal is pointing outward, this should be positive.

dotproduct=vectorfromrefpos*(normal.');

% if the dotproduct is netgative, then we netgate normal
if dotproduct < 0
  normal=-normal;
end