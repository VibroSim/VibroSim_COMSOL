%> You can define parameters using AddParamToParamdb.
%> As an alternative you can define COMSOL parameters with CreateParameter()
%> As another alternative you can store parameters in the M structure
%> (fields can be added to M, with addprop()).

function VibroSim_default_params(M)

% crack parameters
AddParamToParamdb(M,'cracksemimajoraxislen',3e-3,'m');
AddParamToParamdb(M,'cracksemiminoraxislen',1.5e-3,'m');


% Parameters for static loading step -- we usually don't bother with this anymore
%AddParamToParamdb(M,'staticload_mount',10000,'N');
%AddParamToParamdb(M,'xducerforce',100,'N');

% Parameters for the sweep -- generally overridden by parameters entered during testing and/or by the experiment log
AddParamToParamdb(M,'simulationfreqstart',15150,'Hz');
AddParamToParamdb(M,'simulationfreqstep',10,'Hz');
AddParamToParamdb(M,'simulationfreqend',15350,'Hz');

% Parameters for burst step -- generally overridden by parameters entered during testing and/or by the experiment log
AddParamToParamdb(M,'simulationburstfreq',15270,'Hz');

% Parameters for eigenvalue (modal) analysis
AddParamToParamdb(M,'simulationneigs',40);  % Number of frequencies for modal analysis to seek out
AddParamToParamdb(M,'simulationeigsaround',10000,'Hz'); % Center frequency for modal analysis


% Assumed surface emissivity
AddParamToParamdb(M,'simulationsurfaceemissivity',1.0);
ObtainDCParameter(M,'simulationsurfaceemissivity');

% Laser (displacement or velocity detection) coordinates
% Generally override this from model definition or experiment log
AddParamToParamdb(M,'laserx',.07,'m');
AddParamToParamdb(M,'lasery',.0254/4.0,'m');
AddParamToParamdb(M,'laserz',0.0,'m');

% Laser (displacement or velocity detection) direction vector
% Generally override this from model definition or experiment log
AddParamToParamdb(M,'laserdx',0);
AddParamToParamdb(M,'laserdy',0);
AddParamToParamdb(M,'laserdz',1);

% Crack position
%% Generally override this from model definition or experiment log
%AddParamToParamdb(M,'simulationcrackx',.07,'m');
%AddParamToParamdb(M,'simulationcracky',.0254/2.0,'m');
%AddParamToParamdb(M,'simulationcrackz',0,'m');

% Specimen geometry 
% -- generally specify in model definition or experiment log
%AddParamToParamdb(M,'spclength',.14,'m');
%AddParamToParamdb(M,'spcwidth',.0254,'m');
%AddParamToParamdb(M,'spcthickness',.012,'m');

% Meshing characteristics
AddParamToParamdb(M,'spcmeshtype','TETRAHEDRAL');
%AddParamToParamdb(M,'spcmeshtype','HEXAHEDRAL');
AddParamToParamdb(M,'spcmeshsize',.004,'m');
%AddParamToParamdb(M,'spcfacemethod','FreeQuad');
%AddParamToParamdb(M,'spcsweepelements',15)


% Mount coordinates
%AddParamToParamdb(M,'tlmountoffsetx',.13,'m');
%AddParamToParamdb(M,'blmountoffsetx',.12,'m');
%AddParamToParamdb(M,'brmountoffsetx',.02,'m');
%AddParamToParamdb(M,'trmountoffsetx',.01,'m');
%AddParamToParamdb(M,'xduceroffsetx',.07,'m');



% Isolator size/matprops/meshing parameters 

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

% Overall mesh size parameters
AddParamToParamdb(M,'meshsizemin',.001,'m');
AddParamToParamdb(M,'meshsize',.004,'m');


% Sharpness of impulse excitation for time-domain analysis that
% we usually don't do anymore
AddParamToParamdb(M,'impulseexcitation_t0',0.0,'s');
AddParamToParamdb(M,'impulseexcitation_width',2.0e-6,'s');

% Parameters for time-domain vibration simulations
AddParamToParamdb(M,'timedomain_start_time',-4e-6,'s');
AddParamToParamdb(M,'timedomain_step_time',1e-6,'s');
AddParamToParamdb(M,'timedomain_end_time',10e-3,'s');


%CreateExcitationWindow(M,'excitationwindow', ...
%		       ObtainDCParameter(M,'excitation_t0','s'), ...
%		       ObtainDCParameter(M,'excitation_t1','s'), ...
%		       ObtainDCParameter(M,'excitation_t2','s'), ...
%		       ObtainDCParameter(M,'excitation_t3','s'));

CreateImpulseExcitation(M,'impulse_excitation', ...
			ObtainDCParameter(M,'impulseexcitation_t0','s'), ...
			ObtainDCParameter(M,'impulseexcitation_width','s'));

%CreateCameraNoise(M,'cameranoise',ObtainDCParameter(M,'simulationcameranetd','K')); % camera NETD parameter moved to experiment log -- CreateCameraNoise() should be explicit in the model construction

