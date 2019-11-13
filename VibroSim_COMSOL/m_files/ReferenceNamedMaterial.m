function ReferenceNamedMaterial(M,geom,obj,materialtag,domainselectionfunc)

% Find material object
% materialtag
material=FindWrappedObject(M,materialtag);

% Extract domain selection to apply to 
selectionentities=domainselectionfunc(M,geom,obj);

% Extract existing entities of that material
existingselection=mphgetselection(material.node.selection());

% merge

if isfield(existingselection,'entities')
  totalentities=union(selectionentities,existingselection.entities);
else
  totalentities=selectionentities;
end

% Apply this material to that selection
material.node.selection.geom(geom.tag,3); % 3D geometry
material.node.selection.set(totalentities);
