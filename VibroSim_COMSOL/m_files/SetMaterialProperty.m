function SetMaterialProperty(M,material,matprop,value_or_expression)
% ,createvariables)

if ~exist('createvariables','var')
  createvariables=false;
end

%if createvariables
%  var_or_prop=CreateVariable(M,[ material.tag '_' matprop ],valueunitsstr);
%else 
%  var_or_prop=CreateParameter(M,[ material.tag '_' matprop ],valueunitsstr);
%end

material.node.propertyGroup('def').set(matprop,value_or_expression);
