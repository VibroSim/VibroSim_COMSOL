%> block must have been created with 'createselection' 'on'!!!
%> returns a vector of boundary id numbers
function [desirededgeentities]=GetEdgesInDirec(M,geom,geomobj,direc)

% Convert direc to column vector
direc=reshape(direc,prod(size(direc)),1);


% Identify the edge entities of geomobj
edgeselection=mphgetselection(M.node.selection([ geom.tag '_', geomobj.tag, '_edg']));


desirededgeentities=GetParallelEdges(M,geom,edgeselection.entities,direc);

