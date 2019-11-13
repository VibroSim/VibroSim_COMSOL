%> cylinder must have been created with 'createselection' 'on'!!!
%> outwardnormal must be numeric!!!
%> returns a vector of boundary id numbers
function [desiredboundaryentities]=GetCylinderFace(M,geom,cyl,outwardnormal)

% Convert outwardnormal to column vector
outwardnormal=reshape(outwardnormal,prod(size(outwardnormal)),1);


% Get actual position and size of block
cylinderpos=cyl.node.getDoubleArray('pos');
cylinderlen=cyl.node.getDouble('h');
cylinderax3=cyl.node.getDoubleArray('ax3');

centerpos=cylinderpos+(cylinderlen/2)*cylinderax3;

% Identify the boundary entities of cylinder
boundaryselection=mphgetselection(M.node.selection([ geom.tag '_', cyl.tag, '_bnd']));

desiredboundaryentities=GetNormalBoundaries(M,geom,boundaryselection.entities,centerpos,outwardnormal);

