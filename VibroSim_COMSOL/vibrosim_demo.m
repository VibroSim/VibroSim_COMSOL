%> @brief Here is an example of how to use BuildVibroModel

%> You can pass additional parameters into the anonymous functions below,
%> but they must still be called the same way
%>  (i.e.. the '@(M,geom,tag)' portion must remain fixed)

%> You can debug the different components using 
%> DebugGeometryFunc, DebugFlawFunc, DebugPhysicsFunc, etc.

%> Note: to auto-set the crack in the middle of the top of the specimen,
%> you could use:
%> { [ '(' ObtainDCParameter(M,'spclength','m') ')/2.0' ], ... % X-coordinate
%>   [ '(' ObtainDCParameter(M,'spcwidth','m') ')/2.0' ], ... % Y-coordinate
%>   0.0 }, ... % Z-coordinate
%> instead of simulationcrackx, simulationcracky, simulationcrackz

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

% Define a procedure for building the geometry. Steps can be sequenced by using
% the pipe (vertical bar | ) character. 
bldgeom = @(M,geom) CreateRectangularBarSpecimen(M,geom,'specimen');

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
						       [ .001, -30 ; .002, 0 ; .003, 60],...,
						       'solidmech_harmonic',[],100.0);

% Define a procedure for creating the various physics definitions. Steps can be 
% sequenced by using the pipe (vertical bar | ) character. 
bldphysics = @(M,geom,specimen,flaw) example_physics2(M,geom,specimen,flaw);

% Define a procedure to create needed COMSOL result nodes. Generally can pass
% either the wrapped model (M) or unwrapped (model). Pipelining will only work
% with the wrapped model 'M'.
genresults = [];  % No results procedure

% Define a path and filename for saving the generated COMSOL model.
% BuildVibroModel() will create the model's directory if necessary
savefilename = fullfile('/','tmp',sprintf('vibrosim_%s',char(java.lang.System.getProperty('user.name'))),'vibrosim_demo.mph');

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
