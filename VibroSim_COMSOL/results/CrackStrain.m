%> function strainmag=CrackStrain(model,cracktag,freqidx,solutiontag)
%>
%> Determine the magnitude of the strain across the specified crack
%> in the center of its face (NOTE: Does not work if the crack center is
%> outside the material)
%>
%> *** VERY IMPORTANT!!! *** This will only give a meaningful strain if the
%> specified physics has continuity boundary conditions across the crack face.
%> That means, when creating the physics, you must NOT have set the
%> crackdiscontinuity option
%>
%> Parameters:
%> @param model:               COMSOL model node
%> @param geomtag:             COMSOL tag for the main geometry node (usually
%>                      	   'Geom'
%> @param cracktag:            Tag for the crack to investigate (usually
%>                      	   'crack'
%> @param physicstag:          Tag for the physics solved for. Usually
%>                      	   solidmech_harmonic or solidmech_harmonicper
%> @param solutiontag:         Optional. Tag for the solution to use (usually
%>                      	   solidmech_harmonic_solution or
%>                      	   solidmech_harmonicper_solution). Defaults
%>                      	   to [ physicstag '_solution' ]
function [normalstrain,shearstrain] = CrackStrain(model,geomtag,cracktag,physicstag,freqidx,solutiontag)

if ~exist('solutiontag','var')
  solutiontag=[ physicstag '_solution' ];
end

cracknode=model.geom(geomtag).feature(cracktag);

% crack center is first row of genpoints
genpoints=cracknode.getDoubleMatrix('genpoints');
crackpos=genpoints(1,:);

% crack semimajor axis is 2nd row - first row
cracksemimajor=genpoints(2,:)-crackpos;  % along surface

% crack semiminor axis is 3rd row - first row
cracksemiminor=genpoints(3,:)-crackpos; % into depth

cracknormal=cross( cracksemimajor, cracksemiminor);

% Evaluate strain tensor components



[eXX,eXY,eXZ,eYY,eYZ,eZZ] = mphinterp(model, ...
						  { [ physicstag '.eXX' ], ...
						    [ physicstag '.eXY' ], ...
						    [ physicstag '.eXZ' ], ...
						    [ physicstag '.eYY' ], ...
						    [ physicstag '.eYZ' ], ...
						    [ physicstag '.eZZ' ] }, ...
						  'Coord', crackpos.', ...
						  'dataset', GetDataSetForSolution(model,solutiontag), ...
						  'Coorderr', 'on');



straintensor=[ eXX(freqidx) eXY(freqidx) eXZ(freqidx) ;
	       eXY(freqidx) eYY(freqidx) eYZ(freqidx) ;
	       eXZ(freqidx) eYZ(freqidx) eZZ(freqidx) ];

strainvector=(cracknormal/norm(cracknormal))*straintensor; 

%strainmag=norm(strainvector);
normalstrain = strainvector*(cracknormal'/norm(cracknormal));

shearstrain = strainvector*(cracksemimajor'/norm(cracksemimajor));
