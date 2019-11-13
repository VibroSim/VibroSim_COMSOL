%> block must have been created with 'createselection' 'on'!!!
%> returns a vector of boundary id numbers
function [desiredboundaryentities]=GetBlockFace(M,geom,block,outwardnormal)

% Convert outwardnormal to column vector
outwardnormal=reshape(outwardnormal,prod(size(outwardnormal)),1);


% Get actual position and size of block
blockpos=block.node.getDoubleArray('pos');
blocksize=block.node.getDoubleArray('size');
blockbase=block.node.getString('base'); % 'corner' or 'center'?

if strcmp(blockbase,'corner')
  centerpos=blockpos+blocksize/2;
elseif strcmp(blockbase,'center')
  centerpos=blockpos;
else
  error(['GetBlockFace(): Unknown base ' base]);
end

% Identify the boundary entities of block
boundaryselection=mphgetselection(M.node.selection([ geom.tag '_', block.tag, '_bnd']));


desiredboundaryentities=GetNormalBoundaries(M,geom,boundaryselection.entities,centerpos,outwardnormal);

