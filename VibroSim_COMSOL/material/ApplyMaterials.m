%> Apply materials, in creation order -- by searching the TaggedObjectDB
%> for objects with a 'applymaterial' property, and applying the given selections.
%>
%> applymaterial property is called as applymaterial(M,geom,object)
function ApplyMaterials(M,geom)

[sortedapplymaterials]=FindBuildLater(M,'applymaterial');

for cnt=1:length(sortedapplymaterials)
  %	  sortedapplymaterials{cnt}
  sortedapplymaterials{cnt}.buildfcn(M,sortedapplymaterials{cnt});
  sortedapplymaterials{cnt}.is_built=true;
end

