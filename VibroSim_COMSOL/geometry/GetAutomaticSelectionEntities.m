%> scope can be 'pnt', 'edg', 'bnd', or 'dom'
function entities=GetAutomaticSelectionEntities(M,geom,object,scope)

entities=GetNamedSelectionEntities(M,[ geom.tag '_' object.tag '_' scope]);
