%>  This function creates a Weak Form Boundary PDE that converts the output
%>  Of the statistical crack heating model into a result value that doesn't 
%>  Horribly slow down COMSOL. If we just refer to the crack heating model result
%>  Directly, the heatflow model is VERY slow to run. 
%> @retval heatconvert

function heatconvert = CreateVibroHeatConvert(M,geom,tag,vibration_physics,vibrationsolutionindex)

heatconvert=CreatePhysics(M,geom,tag,'WeakFormBoundaryPDE',{'wfb'});
% set field name to 'wfb' along with dependent variable
heatconvert.node.field('dimensionless').field('wfb');

% Disable all boundaries in PDE... They will be added in piecemeal as needed
% in BuildBoundaryHeatSourceBCs()
heatconvert.node.selection.set([]);



% Edit default node to solve to wfb=0
% mphnavigator(M.node)

% This next line actually screws it up!!!! 
% heatconvert.node.feature('wfeq1').setIndex('weak','test(wfb)*(wfb-0)',0);

% vibroheatconvert does not have boundary conditions, other than the PDE's
% which are constructed with the heatflow boundary conditions.

% BuildBoundaryConditions(M,geom,heatflow,'heatflow'); % apply boundary condtions
