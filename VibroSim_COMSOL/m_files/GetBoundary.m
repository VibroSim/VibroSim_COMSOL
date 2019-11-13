function boundaryentities=GetBoundary(M,geom,object)
% This function extracts the boundary entities of an object
% must have been created with createselections enabled!
boundaryselection=mphgetselection(M.node.selection([ geom.tag '_', object.tag, '_bnd']));
boundaryentities=boundaryselection.entities;
