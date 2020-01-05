%> function [normalstress,shearstress]=CrackStress(model,cracktag,freqidx,solutiontag)
%>
%> Determine the magnitude of the engineering stress across the specified crack
%> in the center of its face (NOTE: Does not work if the crack center is
%> outside the material)
%>
%> *** VERY IMPORTANT!!! *** This will only give a meaningful stress if the
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
function [normalstress,shearstress] = CrackStress(model,geomtag,cracktag,physicstag,freqidx,solutiontag)

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

% Evaluate stress tensor components



[sx,sxy,sxz,sy,syz,szz] = mphinterp(model, ...
						  { [ physicstag '.sx' ], ...
						    [ physicstag '.sxy' ], ...
						    [ physicstag '.sxz' ], ...
						    [ physicstag '.sy' ], ...
						    [ physicstag '.syz' ], ...
						    [ physicstag '.szz' ] }, ...
						  'Coord', crackpos.', ...
						  'dataset', GetDataSetForSolution(model,solutiontag), ...
						  'Coorderr', 'on');



stresstensor=[ sx(freqidx) sxy(freqidx) sxz(freqidx) ;
	       sxy(freqidx) sy(freqidx) syz(freqidx) ;
	       sxz(freqidx) syz(freqidx) sz(freqidx) ];

stressvector=(cracknormal/norm(cracknormal))*stresstensor; 

%strainmag=norm(strainvector);
normalstress = stressvector*(cracknormal'/norm(cracknormal));

shearstress = stressvector*(cracksemimajor'/norm(cracksemimajor));
