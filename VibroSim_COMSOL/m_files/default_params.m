%> You can define parameters using AddParamToParamdb.
%> As an alternative you can define COMSOL parameters with CreateParameter()
%> As another alternative you can store parameters in the M structure
%> (fields can be added to M, with addprop()).

function default_params(M)

% crack parameters
AddParamToParamdb(M,'cracksemimajoraxislen',3e-3,'m');
AddParamToParamdb(M,'cracksemiminoraxislen',1.5e-3,'m');


AddParamToParamdb(M,'staticload_mount',10000,'N');
AddParamToParamdb(M,'xducerforce',100,'N');
AddParamToParamdb(M,'simulationfreqstart',15150,'Hz');
AddParamToParamdb(M,'simulationfreqstep',10,'Hz');
AddParamToParamdb(M,'simulationfreqend',15350,'Hz');
AddParamToParamdb(M,'simulationburstfreq',15270,'Hz');
AddParamToParamdb(M,'simulationneigs',40);  % Number of frequencies for modal analysis to seek out
AddParamToParamdb(M,'simulationeigsaround',10000,'Hz'); % Center frequency for modal analysis

AddParamToParamdb(M,'simulationtimestart',0.2,'s');
AddParamToParamdb(M,'simulationtimestep',0.02,'s');
AddParamToParamdb(M,'simulationtimeend',1.8,'s');

AddParamToParamdb(M,'simulationcameranetd',.022,'K');
AddParamToParamdb(M,'simulationsurfaceemissivity',1.0);
ObtainDCParameter(M,'simulationsurfaceemissivity');

% Laser (displacement or velocity detection) coordinates
AddParamToParamdb(M,'laserx',.07,'m');
AddParamToParamdb(M,'lasery',.0254/4.0,'m');
AddParamToParamdb(M,'laserz',0.0,'m');

% Laser (displacement or velocity detection) direction vector
AddParamToParamdb(M,'laserdx',0);
AddParamToParamdb(M,'laserdy',0);
AddParamToParamdb(M,'laserdz',1);

% Crack position
AddParamToParamdb(M,'simulationcrackx',.07,'m');
AddParamToParamdb(M,'simulationcracky',.0254/2.0,'m');
AddParamToParamdb(M,'simulationcrackz',0,'m');

% Crack heating model parameters
%AddParamToParamdb(M,'expV0',20000e6,'W*Pa/m^2/Hz'); % Power law strain dependence: leading coefficient
%AddParamToParamdb(M,'V1',1.7); % Power law strain dependence: exponent
%AddParamToParamdb(M,'m1',0.00152,'m')
%AddParamToParamdb(M,'l0',1.0/0.000762,'1/m')
AddParamToParamdb(M,'wh',20e6,'Pa');

% Crack heating model requires these parameters instantiated
%ObtainDCParameter(M,'expV0','W*Pa/m^2/Hz');
%ObtainDCParameter(M,'V1');
%ObtainDCParameter(M,'m1','m');
%ObtainDCParameter(M,'l0','1/m');
ObtainDCParameter(M,'wh','Pa');
CreateCrackHeatingModel(M,'crackheatingmodel');



AddParamToParamdb(M,'amplitude',1.0,'V');
AddParamToParamdb(M,'xducercalib',fullfile(fileparts(which('BuildVibroModel')),'m_files','constant_10micronpervolt_displacementampl.dat'));
AddParamToParamdb(M,'spclength',.14,'m');
AddParamToParamdb(M,'spcwidth',.0254,'m');
AddParamToParamdb(M,'spcthickness',.012,'m');
AddParamToParamdb(M,'spcviscousdamping',0,'N*s'); 

% These parameters are book values for Ti-6-4 material 
AddParamToParamdb(M,'spcmaterial','Ti-6-4');
AddParamToParamdb(M,'spcYoungsModulus',113.8e9,'Pa');
AddParamToParamdb(M,'spcDensity',4430,'kg/m^3');
AddParamToParamdb(M,'spcPoissonsRatio',0.34,''); % book value
AddParamToParamdb(M,'spcThermalConductivity',6.7,'W/m/K');
AddParamToParamdb(M,'spcSpecificHeatCapacity',526.3,'J/kg/K');

%% These parameters are book values for Inconel 718  material 
%AddParamToParamdb(M,'spcmaterial','Inconel-718');
%AddParamToParamdb(M,'spcYoungsModulus',200e9,'Pa');
%AddParamToParamdb(M,'spcDensity',8190,'kg/m^3');
%AddParamToParamdb(M,'spcPoissonsRatio',0.33,''); % book value
%AddParamToParamdb(M,'spcEta',1e-5,'');
%AddParamToParamdb(M,'spcThermalConductivity',11.4,'W/m/K');
%AddParamToParamdb(M,'spcSpecificHeatCapacity',435.0,'J/kg/K');

AddParamToParamdb(M,'spcmeshtype','TETRAHEDRAL');
%AddParamToParamdb(M,'spcmeshtype','HEXAHEDRAL');
AddParamToParamdb(M,'spcmeshsize',.004,'m');
%AddParamToParamdb(M,'spcfacemethod','FreeQuad');
%AddParamToParamdb(M,'spcsweepelements',15)

AddParamToParamdb(M,'tlmountoffsetx',.13,'m');
AddParamToParamdb(M,'blmountoffsetx',.12,'m');
AddParamToParamdb(M,'brmountoffsetx',.02,'m');
AddParamToParamdb(M,'trmountoffsetx',.01,'m');
AddParamToParamdb(M,'xduceroffsetx',.07,'m');



% NOTE: isolatornlayers removed -- assume something else 
% is doing the multiplication to determine total isolatorthickness
AddParamToParamdb(M,'isolatorthickness',.00125,'m');
AddParamToParamdb(M,'isolatorlength',.010,'m');
AddParamToParamdb(M,'isolatorwidth',.0254,'m');
AddParamToParamdb(M,'isolatormeshtype','HEXAHEDRAL');
AddParamToParamdb(M,'isolatorfacemethod','FreeQuad');
AddParamToParamdb(M,'isolatormeshsize',.004,'m');
AddParamToParamdb(M,'isolatorsweepelements',6,'');
AddParamToParamdb(M,'isolatorThermalConductivity',.05,'W/m/K');  % this number may not be very meaningful
AddParamToParamdb(M,'isolatorSpecificHeatCapacity',2500,'J/kg/K');  % this number may not be very meaningful

% WARNING: These values do not correspond to any particular material
AddParamToParamdb(M,'isolatormaterial','isocardstock');
AddParamToParamdb(M,'isolatorYoungsModulus',3.5e6,'Pa');
AddParamToParamdb(M,'isolatorDensity',870,'kg/m^3');
AddParamToParamdb(M,'isolatorPoissonsRatio',0.3,'');
% 6/11/18 change isolator damping behavior from Eta to d_A.... where d_A=(spring_constant_per_unit_area/(2*pi*f))*eta  
% This works in time domain and is more physically consistent with observations (behaves like dashpot)
% !!!*** Should do the same for couplant and perhaps specimen
%AddParamToParamdb(M,'isolatorEta',.5,'');
AddParamToParamdb(M,'isolatordashpotcoeff',11e3,'Pa*s/m');

AddParamToParamdb(M,'couplantthickness',.00025,'m');
AddParamToParamdb(M,'couplantlength',.010,'m');
AddParamToParamdb(M,'couplantwidth',.010,'m');
AddParamToParamdb(M,'couplantmeshtype','HEXAHEDRAL');
AddParamToParamdb(M,'couplantfacemethod','FreeQuad');
AddParamToParamdb(M,'couplantmeshsize',.004,'m');
AddParamToParamdb(M,'couplantsweepelements',4,'');

% WARNING: These values do not correspond to any particular material
AddParamToParamdb(M,'couplantmaterial','coupcardstock');
AddParamToParamdb(M,'couplantYoungsModulus',3.5e6,'Pa');
AddParamToParamdb(M,'couplantDensity',870,'kg/m^3');
AddParamToParamdb(M,'couplantPoissonsRatio',0.3,'');
%AddParamToParamdb(M,'couplantEta',.5,'');
AddParamToParamdb(M,'couplantdashpotcoeff',11e3,'Pa*s/m');

AddParamToParamdb(M,'couplantThermalConductivity',.05,'W/m/K');  % this number may not be very meaningful
AddParamToParamdb(M,'couplantSpecificHeatCapacity',2500,'J/kg/K');  % this number may not be very meaningful


AddParamToParamdb(M,'meshsizemin',.001,'m');
AddParamToParamdb(M,'meshsize',.004,'m');

AddParamToParamdb(M,'excitation_t0',0.2,'s');
AddParamToParamdb(M,'excitation_t1',0.21,'s');
AddParamToParamdb(M,'excitation_t2',1.199,'s');
AddParamToParamdb(M,'excitation_t3',1.2,'s');

AddParamToParamdb(M,'impulseexcitation_t0',0.0,'s');
AddParamToParamdb(M,'impulseexcitation_width',2.0e-6,'s');

AddParamToParamdb(M,'timedomain_start_time',-4e-6,'s');
AddParamToParamdb(M,'timedomain_step_time',1e-6,'s');
AddParamToParamdb(M,'timedomain_end_time',10e-3,'s');

% Load in xducercalib file to xducercalib function, set up xducerdisplacement as variable (WARNING: This step can be slow!)
CreateTransducerDisplacementVariable(M);

CreateExcitationWindow(M,'excitationwindow', ...
		       ObtainDCParameter(M,'excitation_t0','s'), ...
		       ObtainDCParameter(M,'excitation_t1','s'), ...
		       ObtainDCParameter(M,'excitation_t2','s'), ...
		       ObtainDCParameter(M,'excitation_t3','s'));

CreateImpulseExcitation(M,'impulse_excitation', ...
			ObtainDCParameter(M,'impulseexcitation_t0','s'), ...
			ObtainDCParameter(M,'impulseexcitation_width','s'));

CreateCameraNoise(M,'cameranoise',ObtainDCParameter(M,'simulationcameranetd','K'));

