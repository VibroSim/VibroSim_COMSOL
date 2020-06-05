%> function [crackpos,cracknormal]=CrackPointNormal(model,geomtag,cracktag)
%>
%> Determine the location of the crack and the vector normal to its face.
%>
%> Prototype:
%> CrackPointNormal(model,'Geom','crack');
%>
%> Parameters:
%> @param model:               COMSOL model node
%> @param geomtag:             COMSOL tag for the main geometry node (usually
%>                      	   'Geom'
%> @param cracktag:            Tag for the crack to investigate (usually
%>                      	   'crack'
function [crackpos,cracknormal] = CrackPointNormal(model,geomtag,cracktag)

cracknode=model.geom(geomtag).feature(cracktag);

% crack center is first row of genpoints
genpoints=cracknode.getDoubleMatrix('genpoints');
crackpos=genpoints(1,:);

% crack semimajor axis is 2nd row - first row
cracksemimajor=genpoints(2,:)-crackpos;  % along surface

% crack semiminor axis is 3rd row - first row
cracksemiminor=genpoints(3,:)-crackpos; % into depth

cracknormal=cross( cracksemimajor, cracksemiminor);

cracknormal = cracknormal/norm(cracknormal)
