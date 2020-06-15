%> AddView creates a named view for a specimen with the specified parameters
%> This view is automatically used when viewing mode shapes, heating etc.
%> Returns the specimen with view attribute added

%> function specimen=AddView(M,specimen,
%>                        zoomanglefull,
%>                        position,
%>			  target,
%>			  up,
%>			  rotationpoint)
%>
%> specimen:              Specimen object the view should be added to
%> position:              Position vector or cellstr array representing camera position
%> target:                Position vector or cellstr array representing camera target
%> up:                    Unit vector or cellstr array representing up direction
%> rotationpoint:         Position vector or cellstr array representing rotation point
function specimen=AddView(M,specimen,zoomanglefull,position,target,up,rotationpoint)

  CreateWrappedProperty(M,specimen,'view',[ specimen.tag '_view' ],M.node.view,3);
  specimen.view.node.label(specimen.view.tag);
  specimen.view.node.camera().set('zoomanglefull',zoomanglefull);
  specimen.view.node.camera().set('position',to_cellstr_array(position,'m'));
  specimen.view.node.camera().set('target',to_cellstr_array(target,'m'));
  specimen.view.node.camera().set('up',to_cellstr_array(up));
  specimen.view.node.camera().set('rotationpoint', to_cellstr_array(rotationpoint,'m'));
