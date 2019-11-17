%> function sorted_boundaries=GetCrackBoundaries(M,geom,crack)
%>
%> Return a list of the boundary entity numbers that make up the
%> specified crack. This uses an algorithm that is not quite perfect
%> but most likely problems are diagnosed by the assert()
%> below.
%>
%> The list of entity numbers is sorted from the center of the
%> crack to the outside.

%>
%> Our algorithm for identifying the boundaries:
%> For each boundary in 'Geom_crack_bnd' (automatically created selection of the crack object)
%> measure the total length of adjacent edges.
%> Sort the boundaries by total length and use them from shortest to
%> longest, checking adjacency each time
%>
%> (Might fail if only a corner of the crack intersects the specimen, but this would be a badly
%> placed crack)
%>
%> Will fail if crack intersects an internal boundary or similar
function sorted_boundaries=GetCrackBoundaries(M,geom,crack)

% crack boundaries are the set of semi-annuli, the union of which form the crack.
crack_boundaries=mphgetselection(M.node.selection([ geom.tag '_' crack.tag '_bnd' ]));
% entity numbers are now in crack_boundaries.entities

crack_boundary_edge_lengths=[];

for cnt=1:length(crack_boundaries.entities)
  % measure the total length
  crack_boundary_edge_lengths(cnt)=BoundaryMeasureEdgeLength(M,geom,crack_boundaries.entities(cnt));  
end
  
[junk,sortorder]=sort(crack_boundary_edge_lengths);

sorted_boundaries=crack_boundaries.entities(sortorder); % sorted from shortest to longest (inner->outer)


% If this assertion fails, then probably the crack got split on an internal boundary of some sort and there are 
% extra boundaries. Would need a more sophisticated algorithm here to sort that out. 
% Suggested algorithm: Go back to the ellipses, calculate their equations, and check which edges have points that 
% (nearly) satisfy the equations of which ellipses. That will identify the edges, from which the boundaries can be 
% properly organized from innermost group to outermost group

%assert(length(sorted_boundaries)==size(crack.closure,1));
assert(length(sorted_boundaries)==size(crack.annuliradii,2));
