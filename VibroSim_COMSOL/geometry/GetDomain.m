%> This function extracts the domain entities of an object
function domainentities=GetDomain(M,geom,object)

domainselection=mphgetselection(M.node.selection([ geom.tag '_', object.tag, '_dom']));
domainentities=domainselection.entities;
%explicitselection=CreateExplicitSelection(M,tag,'domain',domainentities);
