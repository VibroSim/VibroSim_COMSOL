%> Measure the boundary displacement magnitude at each boundary point of a geometric object,
%> at solnum=closestfreqidx
function boundarydisp = GetBoundaryDisplacement(model,geomtag,physicstag,objecttag,closestfreqidx)

boundaryname=[ geomtag '_' objecttag '_bnd' ]; % COMSOL autocreated named boundary
solutiontag=[physicstag '_solution'];

evalobj=mpheval(model, { [ physicstag 'u' ], ...
			[ physicstag 'v' ], ...
			[ physicstag 'w' ] }, ...
		'edim','boundary', ...
		'selection',boundaryname, ... % should be Geom_specimen_bnd
		'dataset',GetDataSetForSolution(model,solutiontag),  ...
		'solnum',closestfreqidx);

u=evalobj.d1;
v=evalobj.d2;
w=evalobj.d3;
	     
boundarydisp=sqrt(abs(u.^2 + v.^2 + w.^2));
