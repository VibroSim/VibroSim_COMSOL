%> @brief Here is a second example of how to use BuildVibroModel

% In this case, our geometry is specified simply as the geometry of
% the bare specimen and is passed through AttachCouplantIsolators()
% to generate the total geometry.
%
%                 x          y         z      angle
couplant_coord=[ .14/2,   .0254/2,     .012,      NaN    ];
isolator_coords=[.13,     .0254/2,     0,   0.0,  % top-left
		 .01,     .0254/2,     0,   0.0,  % top-right
                 .12,     .0254/2,     .012,      0.0,  % bottom-left
		 .02,     .0254/2,     .012,      0.0]; % bottom-right

% ( NaN for angle causes it to create a circular isolator)

% You may wish to uncomment these next two lines if this is part of a function
% -- that way if the function fails you can access the wrapped and unwrapped model 
% variables just because they are globals. 
%global M
%global model 


% InitializeVibroSimScript() connects to COMSOL and initializes and 
% returns the wrapped model variable (M) and the unwrapped node (model). 
[M,model]=InitializeVibroSimScript();



% Call a function that sets various parameters to be used by the model. 
default_params(M);


% Amplitude setting for the excitation system
AddParamToParamdb(M,'amplitude',1.0,'V');

% simulationtimestart, simulationtimestep, and simulationtimeend specify the time range of the heat flow simulation
AddParamToParamdb(M,'simulationtimestart',0.2,'s');
AddParamToParamdb(M,'simulationtimestep',0.02,'s');
AddParamToParamdb(M,'simulationtimeend',1.8,'s');


% Define a procedure for building the geometry. Steps can be sequenced by using
% the pipe (vertical bar | ) character. 
bldgeom = @(M,geom) CreateRectangularBarSpecimen(M,geom,'specimen') | ...
	  @(specimen) AttachThinCouplantIsolators(M,geom,specimen,couplant_coord,isolator_coords); 

% Define a procedure for building the crack. Steps can be sequenced by using
% the pipe (vertical bar | ) character. 
bldcrack = @(M,geom,specimen) CreateCrack(M,geom,'crack',specimen, ...
						       { ObtainDCParameter(M,'simulationcrackx','m'), ...
							 ObtainDCParameter(M,'simulationcracky','m'), ...
							 ObtainDCParameter(M,'simulationcrackz','m') }, ...
						       ObtainDCParameter(M,'cracksemimajoraxislen','m'), ...
						       ObtainDCParameter(M,'cracksemiminoraxislen','m'), ...
						       [0,1,0], ...
						       [0,0,-1], ...
						       [ .001, -30 ; .002, 0 ; .003, 60], ...
		                                       {'solidmech_harmonicsweep','solidmech_harmonicburst'}, ...
						       'vibroheatconvert');

% Define a procedure for creating the various physics definitions. Steps can be 
% sequenced by using the pipe (vertical bar | ) character. 
bldphysics = @(M,geom,specimen,flaw) VibroPhysics(M,geom,specimen,flaw,'process');

% Define a procedure to create needed COMSOL result nodes. Generally can pass
% either the wrapped model (M) or unwrapped (model). Pipelining will only work
% with the wrapped model 'M'.
genresults = @(M) VibroResults(M);

% Define a path and filename for saving the generated COMSOL model.
% BuildVibroModel() will create the model's directory if necessary
savefilename = fullfile(tempdir,sprintf('vibrosim_%s',char(java.lang.System.getProperty('user.name'))),'vibrosim_demo2.mph');

% Given the model wrapper, the procedures for building the geometry, the crack, the physics,
% and for storing the results, and a file name for saving, have COMSOL build the model.x
BuildVibroModel(M,...
		bldgeom, ...
		bldcrack, ...
		bldphysics, ...
		genresults, ...
		savefilename);

% Uncomment these next two lines to run the model and save the output after building the model
%RunAllStudies(model);
%mphsave(M.node,savefilename);

