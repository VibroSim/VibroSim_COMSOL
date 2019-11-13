%> function disp=LaserDisplacement(model,geomtag,physicstag,freqidx,vibnum,solutiontag)
%>
%> Determine the displacement at a particular point, as would be measured
%> using a laser vibrometer.
%>
%> Assumes the following parameters have been set up
%>  -- probably by ObtainDCParameter()
%>  Laser position:
%>    laserx
%>    lasery
%>    laserz
%>  Laser direction:
%>    laserdx
%>    laserdy
%>    laserdz
%>
%> Parameters:
%> model:               COMSOL model node
%> geomtag:             COMSOL tag for the main geometry node (usually
%>                      'Geom'
%> physicstag:          Tag for the physics solved for. Usually
%>                      solidmech_harmonic or solidmech_harmonicper
%> solutiontag:         Optional. Tag for the solution to use (usually
%>                      solidmech_harmonic_solution or
%>                      solidmech_harmonicper_solution). Defaults
%>                      to [ physicstag '_solution' ]
%> vibnum:              Number of vibrometer in use
function disp=LaserDisplacement(model,geomtag,physicstag,freqidx,vibnum,solutiontag)

if ~exist('solutiontag','var')
  solutiontag=[ physicstag '_solution' ];
end

  if vibnum==1
      pfx = 'laser';
  else
      pfx = ['laser',num2str(vibnum)];
  end

  laserx=mphevaluate(model,[pfx,'x'],'m');
  lasery=mphevaluate(model,[pfx,'y'],'m');
  laserz=mphevaluate(model,[pfx,'z'],'m');

  % Evaluate displacement components
  [ux,uy,uz] = mphinterp(model, ...
			 { [ physicstag 'u' ], ...
			   [ physicstag 'v' ], ...
			   [ physicstag 'w' ] }, ...
			   'Coord', [ laserx lasery laserz ].', ...
			   'dataset', GetDataSetForSolution(model,solutiontag), ...
			   'Coorderr', 'on');
  
  
  laserd=[ mphevaluate(model,[pfx,'dx'])
	   mphevaluate(model,[pfx,'dy'])
	   mphevaluate(model,[pfx,'dz']) ];
  
  % normalize laser direction
  laserd=laserd/norm(laserd);

  % Return dot product of laser direction with displacement
  disp=(laserd.')*[ux(freqidx);uy(freqidx);uz(freqidx)];
  


  
  
