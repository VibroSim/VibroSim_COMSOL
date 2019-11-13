[M,model]=InitializeVibroSimScript;

AddParamToParamdb(M,'staticload_mount',10000,'N');
AddParamToParamdb(M,'xducerforce',100,'N');
AddParamToParamdb(M,'simulationfreqstart',14000,'Hz');
AddParamToParamdb(M,'simulationfreqstep',25,'Hz');
AddParamToParamdb(M,'simulationfreqend',15000,'Hz');

AddParamToParamdb(M,'amplitude',1.0,'V');
AddParamToParamdb(M,'xducercalib',fullfile(fileparts(mfilename('fullpath')),'support','constant_10micronpervolt_displacementampl.dat'));
AddParamToParamdb(M,'spclength',.14,'m');
AddParamToParamdb(M,'spcwidth',.0254,'m');
AddParamToParamdb(M,'spcthickness',.012,'m');

AddParamToParamdb(M,'specimen','C12-12345Q');
AddParamToParamdb(M,'spcmaterial','Titanium');
% WARNING: These values do not correspond to any particular material
			     AddParamToParamdb(M,'spcYoungsModulus',200,'GPa');
AddParamToParamdb(M,'spcDensity',4000,'kg/m^3');
AddParamToParamdb(M,'spcPoissonsRatio',0.2,'');

%AddParamToParamdb(M,'spcmeshtype','TETRAHEDRAL');
AddParamToParamdb(M,'spcmeshtype','HEXAHEDRAL');
AddParamToParamdb(M,'spcmeshsize',.004,'m');
AddParamToParamdb(M,'spcfacemethod','FreeQuad');
AddParamToParamdb(M,'spcsweepelements',15)

AddParamToParamdb(M,'tlmountoffsetx',.01,'m');
AddParamToParamdb(M,'blmountoffsetx',.02,'m');
AddParamToParamdb(M,'brmountoffsetx',.12,'m');
AddParamToParamdb(M,'trmountoffsetx',.13,'m');
AddParamToParamdb(M,'xduceroffsetx',.07,'m');


AddParamToParamdb(M,'meshsizemin',.002,'m');
AddParamToParamdb(M,'meshsize',.01,'m');


% NOTE: isolatornlayers removed -- assume something else 
% is doing the multiplication to determine total isolatorthickness
AddParamToParamdb(M,'isolatorthickness',.003,'m');
AddParamToParamdb(M,'isolatorlength',.010,'m');
AddParamToParamdb(M,'isolatorwidth',.050,'m');
AddParamToParamdb(M,'isolatormeshtype','HEXAHEDRAL');
AddParamToParamdb(M,'isolatorfacemethod','FreeQuad');
AddParamToParamdb(M,'isolatormeshsize',.002,'m');
AddParamToParamdb(M,'isolatorsweepelements',6,'');

AddParamToParamdb(M,'couplantthickness',.001,'m');
AddParamToParamdb(M,'couplantlength',.010,'m');
AddParamToParamdb(M,'couplantwidth',.010,'m');
AddParamToParamdb(M,'couplantmeshtype','HEXAHEDRAL');
AddParamToParamdb(M,'couplantfacemethod','FreeQuad');
AddParamToParamdb(M,'couplantmeshsize',.002,'m');
AddParamToParamdb(M,'couplantsweepelements',4,'');

AddParamToParamdb(M,'isolatormaterial','cardstock');
AddParamToParamdb(M,'couplantmaterial','cardstock');
% WARNING: These values do not correspond to any particular material
AddParamToParamdb(M,'cardstockYoungsModulus',200,'MPa');
AddParamToParamdb(M,'cardstockDensity',800,'kg/m^3');
AddParamToParamdb(M,'cardstockPoissonsRatio',0.3,'');
AddParamToParamdb(M,'cardstockEta',.05,'');



% Initialize the Model
%[M,component] = CreateModel('Model','Component');



% Build Geometry
[geom,mesh] = CreateGeometryNode(M,'Geom','Mesh',3);

CreateDCMaterialIfNeeded(M,geom,'couplant','cardstock');
CreateDCMaterialIfNeeded(M,geom,'isolator','cardstock');

%tag='rectbarspec';
%specimen=CreateRectangularBarSpecimen(M,geom,'rectbarspec');
%isolator1=CreateIsolator(M,geom,'isolator1','Rectangle',[.02,.01,0],[0,0,-1]);
%isolator2=CreateIsolator(M,geom,'isolator2','Rectangle',[.08,.01,0],[0,0,-1]);

specimen=CreateRectangularBarGeometry(M,geom,'specimen');

SetGeometryFinalization(M,geom,'assembly',true);

MeshSetBounds(M,mesh,ObtainDCParameter(M,'meshsizemin','m'),ObtainDCParameter(M,'meshsize','m'));


% Mesh all objects created up to this point
MeshRemainingObjects(M,geom,mesh);
% specimen.mesh.buildfcn(M,specimen.mesh);



% Create empty study to find normals
normalstudy=CreateStudy(M,geom,'getnormals');
normalstudy.node.run;

% Build all buildlater objects now that we have the normals
BuildWithNormals(M,geom);

% Now mesh the newly-created objects
MeshRemainingObjects(M,geom,mesh);

%specimen.applymaterial.buildfcn(M,specimen.applymaterial);
ApplyMaterials(M,geom);




% Create first SolidMechanics for static deformation study
solidmech_static=CreatePhysics(M,geom,'solidmech_static','SolidMechanics'); % note: displacements are solidmech_staticu, solidmech_staticv, solidmech_staticw

% Boundary conditions 
										BuildBoundaryConditions(M,geom,solidmech_static,'solidmech_static');


% Create second solidmechanics, for harmonic perturbation
solidmech_harmonicper=CreatePhysics(M,geom,'solidmech_harmonicper','SolidMechanics');
% Boundary conditions
BuildBoundaryConditions(M,geom,solidmech_harmonicper,'solidmech_harmonicper');



stationarystudy=CreateStudy(M,geom,'stationarystudy');
stationarystep=StudyAddStep(M,geom,stationarystudy,'stationarystudy_step','Stationary',solidmech_static);
%stationarystep.node.set('geometricNonlinearity','on');
stationarysolution=CreateSolution(M,stationarystudy,'stationarystudy_solution',stationarystep,'Stationary');
stationarysolution.solutionsolver.node.set('nonlin','on');

SelectBoundaryConditionsForStudy(M,stationarystudy,{'continuities','staticloading'});




% Initial conditions
initstrainvals={'solidmech_static.eX','solidmech_static.eXY','solidmech_static.eXZ','solidmech_static.eXY','solidmech_static.eY','solidmech_static.eYZ','solidmech_static.eXZ','solidmech_static.eYZ','solidmech_static.eZ'};
initdisplvals={'solidmech_staticu','solidmech_staticv','solidmech_staticw'};
SolidMechanics_SetInitialStrain(M,solidmech_harmonicper,initstrainvals);
SolidMechanics_SetInitialDisplacement(M,solidmech_harmonicper,initdisplvals);

freqstart=ObtainDCParameter(M,'simulationfreqstart','Hz');
freqstep=ObtainDCParameter(M,'simulationfreqstep','Hz');
freqend=ObtainDCParameter(M,'simulationfreqend','Hz');
freqrange=[ 'range(' freqstart ',' freqstep ',' freqend ')' ];

harmonicperstudy=CreateStudy(M,geom,'harmonicperstudy');
harmonicperstep=StudyAddFrequencyStep(M,geom,harmonicperstudy,'harmonicperstudy_step', ...
				      freqrange, ...
				      solidmech_harmonicper,solidmech_static); % both solidmech_harmonicper and solidmech_static are turned on...
StudyStepEnablePhysicsInSolvers(M,harmonicperstep,solidmech_static,false); % ... but solidmech_static is not to be solved)

harmonicperstep.node.set('geometricNonlinearity','on');
harmonicperstep.node.set('usesol','on'); % Set 'Use Solution Method' on
harmonicperstep.node.set('notsolmethod','sol'); % Set dependent variable selection to 'sol', not 'init'
harmonicperstep.node.set('notstudy',stationarystudy.tag); % tag for study to be used to set dependent variables

% Create custom solver for frequency domain study
% Set up solver so that the harmonicper study is a linear perturbation solution linearized about the output of stationary solver
freqsolution=CreateSolution(M,harmonicperstudy,'harmonicperstudy_solution',harmonicperstep,'Stationary');
freqsolution.solutionsolver.node.set('nonlin','off');
freqsolution.solutionsolver.node.set('linpmethod','sol');
freqsolution.solutionsolver.node.set('linpsol',stationarysolution.tag);
freqsolution.solutionsolver.node.set('storelinpoint','on');

SelectBoundaryConditionsForStudy(M,harmonicperstudy,{'continuities','excitation','fixedisolators'});

CreateTransducerDisplacementVariable(M);  % Load in xducercalib file to xducercalib function, set up xducerdisplacement as variable (WARNING: This step is slow!)


%stationarystudy.node.run;
%harmonicperstudy.node.run;


% Plan:
% ----
%  * Use automatically-generated identity pairs
%  * Create continuity boundary conditions
%    * look up pairs in pairtags=M.node.pair.tags()
%      * source=M.node.pair(pairtags(1)).source
%      * source_entities=source.entities(source.dimension)
%      * destination=
%
%  * Make sure all couplants and isolators have pairs on their contact sides. 
%
%  * To find couplant locations
%    * Create blank study
%    * Create 3D plot group
%    * Create surface feature, plotting expression nx 
%    * User can click on locations
%    * Can ask Comsol for normals at those locations. 

