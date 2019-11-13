%> You can define parameters using AddParamToParamdb.
%> As an alternative you can define COMSOL parameters with CreateParameter()
%> As another alternative you can store parameters in the M structure
%> (fields can be added to M, with addprop()).

function straincoefficient_params(M,isolators_and_couplant,using_datacollect)

% crack parameters
AddParamToParamdb(M,'cracksemimajoraxislen',3e-3,'m');
AddParamToParamdb(M,'cracksemiminoraxislen',1.5e-3,'m');


%AddParamToParamdb(M,'staticload_mount',10000,'N');
%AddParamToParamdb(M,'xducerforce',100,'N');
%AddParamToParamdb(M,'simulationfreqstart',14000,'Hz');
%AddParamToParamdb(M,'simulationfreqstep',25,'Hz');
%AddParamToParamdb(M,'simulationfreqend',14050,'Hz');
if ~using_datacollect
  AddParamToParamdb(M,'simulationneigs',40);  % Number of frequencies for modal analysis to seek out
  AddParamToParamdb(M,'simulationeigsaround',10000,'Hz'); % Center frequency for modal analysis
end

%AddParamToParamdb(M,'simulationtimestart',0.0,'s');
%AddParamToParamdb(M,'simulationtimestep',0.01,'s');
%AddParamToParamdb(M,'simulationtimeend',1.8,'s');

% Laser (displacement or velocity detection) coordinates and direction vector
if ~using_datacollect
  AddParamToParamdb(M,'calcvib',1);
  AddParamToParamdb(M,'calcvib2',0);
  AddParamToParamdb(M,'laserx',.07,'m');
  AddParamToParamdb(M,'lasery',.0254/4.0,'m');
  AddParamToParamdb(M,'laserz',0.0,'m');
  AddParamToParamdb(M,'laserdx',0);
  AddParamToParamdb(M,'laserdy',0);
  AddParamToParamdb(M,'laserdz',1);

  AddParamToParamdb(M,'laser2x',.07,'m');
  AddParamToParamdb(M,'laser2y',.0254/4.0,'m');
  AddParamToParamdb(M,'laser2z',0.0,'m');
  AddParamToParamdb(M,'laser2dx',0);
  AddParamToParamdb(M,'laser2dy',0);
  AddParamToParamdb(M,'laser2dz',1);

else 
  % The post processing code needs COMSOL params, but strings
  % can't be COMSOL params.  So, let's convert here.
  dcv1=GetDCParamStringValue(M,'vibactive');
  dcv2=GetDCParamStringValue(M,'vib2active');
  if strcmp(dcv1.value,'Yes')
      AddParamToParamdb(M,'calcvib',1);
  else
      AddParamToParamdb(M,'calcvib',0);
  end 
  if strcmp(dcv2.value,'Yes')
      AddParamToParamdb(M,'calcvib2',1);
  else
      AddParamToParamdb(M,'calcvib2',0);
  end
end


if ~using_datacollect
  % Crack position
  AddParamToParamdb(M,'simulationcrackx',.07,'m');
  AddParamToParamdb(M,'simulationcracky',.0254/2.0,'m');
  AddParamToParamdb(M,'simulationcrackz',0.0,'m');
end

%AddParamToParamdb(M,'amplitude',1.0,'V');
%AddParamToParamdb(M,'xducercalib',fullfile(fileparts(mfilename('fullpath')),'..','support','constant_10micronpervolt_displacementampl.dat'));

if ~using_datacollect 
  AddParamToParamdb(M,'spclength',.14,'m');
  AddParamToParamdb(M,'spcwidth',.0254,'m');
  AddParamToParamdb(M,'spcthickness',.012,'m');
  AddParamToParamdb(M,'spcviscousdamping',0.0,'N*s'); 
  
  AddParamToParamdb(M,'specimen','C12-12345Q');
  AddParamToParamdb(M,'spcmaterial','Titanium');
  AddParamToParamdb(M,'spcYoungsModulus',117.9,'GPa');
  AddParamToParamdb(M,'spcDensity',4410,'kg/m^3');
  AddParamToParamdb(M,'spcPoissonsRatio',0.32,'');
end

%AddParamToParamdb(M,'spcThermalConductivity',6.7,'W/m/K');
%AddParamToParamdb(M,'spcSpecificHeatCapacity',529,'J/kg/K');

if ~using_datacollect
  AddParamToParamdb(M,'spcmeshtype','TETRAHEDRAL');
  %AddParamToParamdb(M,'spcmeshtype','HEXAHEDRAL');
  AddParamToParamdb(M,'spcmeshsize',.002,'m');
  %AddParamToParamdb(M,'spcfacemethod','FreeQuad'); 
  %AddParamToParamdb(M,'spcsweepelements',15)
end

if isolators_and_couplant
  AddParamToParamdb(M,'tlmountoffsetx',.01,'m');
  AddParamToParamdb(M,'blmountoffsetx',.02,'m');
  AddParamToParamdb(M,'brmountoffsetx',.12,'m');
  AddParamToParamdb(M,'trmountoffsetx',.13,'m');
  AddParamToParamdb(M,'xduceroffsetx',.07,'m');



  % NOTE: isolatornlayers removed -- assume something else 
  % is doing the multiplication to determine total isolatorthickness
  AddParamToParamdb(M,'isolatorthickness',.003,'m');
  AddParamToParamdb(M,'isolatorlength',.010,'m');
  AddParamToParamdb(M,'isolatorwidth',.0254,'m');
  AddParamToParamdb(M,'isolatormeshtype','HEXAHEDRAL');
  AddParamToParamdb(M,'isolatorfacemethod','FreeQuad');
  AddParamToParamdb(M,'isolatormeshsize',.002,'m');
  AddParamToParamdb(M,'isolatorsweepelements',6,'');
  AddParamToParamdb(M,'isolatorThermalConductivity',.05,'W/m/K');  % this number may not be very meaningful
  AddParamToParamdb(M,'isolatorSpecificHeatCapacity',2500,'J/kg/K');  % this number may not be very meaningful

  % WARNING: These values do not correspond to any particular material
  AddParamToParamdb(M,'isolatormaterial','isocardstock');
  AddParamToParamdb(M,'isolatorYoungsModulus',200,'MPa');
  AddParamToParamdb(M,'isolatorDensity',800,'kg/m^3');
  AddParamToParamdb(M,'isolatorPoissonsRatio',0.3,'');
  %AddParamToParamdb(M,'isolatorEta',.05,'');
  AddParamToParamdb(M,'isolatordashpotcoeff',27e3,'Pa*s/m');
  
  AddParamToParamdb(M,'couplantthickness',.001,'m');
  AddParamToParamdb(M,'couplantlength',.010,'m');
  AddParamToParamdb(M,'couplantwidth',.010,'m');
  AddParamToParamdb(M,'couplantmeshtype','HEXAHEDRAL');
  AddParamToParamdb(M,'couplantfacemethod','FreeQuad');
  AddParamToParamdb(M,'couplantmeshsize',.002,'m');
  AddParamToParamdb(M,'couplantsweepelements',4,'');

  % WARNING: These values do not correspond to any particular material
  AddParamToParamdb(M,'couplantmaterial','coupcardstock');
  AddParamToParamdb(M,'couplantYoungsModulus',200,'MPa');
  AddParamToParamdb(M,'couplantDensity',800,'kg/m^3');
  AddParamToParamdb(M,'couplantPoissonsRatio',0.3,'');
  %AddParamToParamdb(M,'couplantEta',.05,'');
  AddParamToParamdb(M,'couplantThermalConductivity',.05,'W/m/K');  % this number may not be very meaningful
  AddParamToParamdb(M,'couplantSpecificHeatCapacity',2500,'J/kg/K');  % this number may not be very meaningful
end

AddParamToParamdb(M,'meshsizemin',.001,'m');
AddParamToParamdb(M,'meshsize',.004,'m');

% Load in xducercalib file to xducercalib function, set up xducerdisplacement as variable (WARNING: This step can be slow!)
%CreateTransducerDisplacementVariable(M);


% LaserDisplacement() requires that these already be converted into COMSOL parameters...
ObtainDCParameter(M,'calcvib');
ObtainDCParameter(M,'calcvib2');
ObtainDCParameter(M,'laserx','m');
ObtainDCParameter(M,'lasery','m');
ObtainDCParameter(M,'laserz','m');
ObtainDCParameter(M,'laserdx');
ObtainDCParameter(M,'laserdy');
ObtainDCParameter(M,'laserdz');
ObtainDCParameter(M,'laser2x','m');
ObtainDCParameter(M,'laser2y','m');
ObtainDCParameter(M,'laser2z','m');
ObtainDCParameter(M,'laser2dx');
ObtainDCParameter(M,'laser2dy');
ObtainDCParameter(M,'laser2dz');
ObtainDCParameter(M,'spcviscousdamping','N*s');
