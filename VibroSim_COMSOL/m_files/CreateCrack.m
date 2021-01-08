%> CREATECRACK Creates a a crack at a given position
%>   [crack] = CREATECRACK(M, geom, tag, specimen, centerpoint, semimajoraxislen,
%>                         semiminoraxislen, axismajordirection,
%>                         axisminordirection, subradii,
%>                         vibration_physicstags,
%>                         heatingfile, cracktype)
%> Parameters:
%> -----------
%> M:                   Top level ModelWrapper
%> geom:                Top level geometry
%> tag:                 Tag for crack's WorkPlane
%> specimen:            Object in which to place the crack
%> centerpoint:         Center point for the crack. Should be on or
%>                      in the specimen
%> semimajoraxislen:    Half-crack length, along semi-major (surface) axis
%> semiminoraxislen:    Half-crack length, along semi-minor (depth) axis
%> axismajordirection:  Direction of semi-major (surface) axis
%> axisminordirection:  Direction of semi-minor (depth) axis
%> subradii:            A vector of axismajor_endboundary values.
%>                      The last element should match the value of
%>                      semimajoraxislen. The crack boundary will be split
%>                      into sub boundaries, with the real purpose of enforcing
%>                      a sufficiently fine mesh to be able to resolve the
%>                      spatial distribution of predicted heating. The shape 
%>                      depend on the crack type, annuli for penny shaped
%>                      and rectangles for through cracks.
%> vibration_physicstags: A cell array of tag names representing physics models
%>                      used for vibration calculation. For each of these a
%>                      variable [ cracktag '_centerstress_' physicstag ]
%>                      will be created representing the local stress field
%>                      at the centerpoint. Please note that for this to be
%>                      meaningful that physics should be configured for
%>                      continuity mechanical boundary conditions across the
%>                      crack (otherwise stress isn't well defined for a
%>                      discontinuity).
%> heatingfile:         Optional file with crack heating data. It should have four
%>                      columns: Time, surface radius, side1 heating, 
%>                      side2 heating. Side 1 corresponds to the negative
%>                      major axis direction; side2 corresponds to the 
%>                      positive major axis direction. 
%>                      If not provided then the heat generation boundary 
%>                      condition will not be created. 
%> cracktype:           A string that is either 'through' or 'penny'


% Documentation of obsolete (removed) parameters: 
  
%> closure:             A 2 column matrix of (axismajor_endboundary,
%>                      closurestate_MPa). Last entry of first column of
%>                      closure should match the value of semimajoraxislen.
%>  weakformpdephysicstag (obsolete, removed) A parameter, may be blank [] that is passed to 
%>                       BuildBoundaryHeatSourceBCs to accelerate MATLAB 
%>                       heat source calculations through an intermediate
%>                       weak form PDE physics calculation 
%>
%> Closure is measured in MPa. Positions should be in order, representing the
%> outer radius of each semi-annular ring, with the corresponding closure stress
%> representing the average closure stress over that semi-annular ring.

%> QbExpressions:       An optional parameter, used for or to generate the
%>                      expressions used for the heat source intensity Qb.
%>                      It can be:
%>                       * An sprintf-style string with up to one '%d'-type
%>                         substitution, which gets the corresponding row
%>                         number of the closure parameter, or
%>                       * A cell array of strings, with length matching closure
%>                         -- passed directly as the heating parameter
%>                       * Numeric values -- passed directly as heating param.
%>                       * If QbExpressions is not provided, the vibrothermography
%>                         crack heating model is used instead.

  %> Example parameter values:
  %> centerpoint=[.07,.0254/2,.012];
  %> semimajoraxislen=.003;
  %> semiminoraxislen=.0028;
  %> axismajordirection=[0,1,0];
  %> axisminordirection=[0,0,-1];
  %> closure=[ .001, -30 ; .002, 0 ; .003, 60];
  %> QbExpressions='heatintensity%.2d'
function [crack] = CreateCrack(M,geom, tag, specimen, centerpoint, semimajoraxislen, semiminoraxislen, axismajordirection,axisminordirection,subradii,vibration_physicstags,heatingfile,cracktype)

  % Assert cracktype is either 'penny' or 'through'
  assert( strcmp(cracktype,'penny') || strcmp(cracktype,'through') );

  % axismajordirection, axisminordirection, subradii are row vectors
  axismajordirection=reshape(axismajordirection,1,3);
  axisminordirection=reshape(axisminordirection,1,3);
  subradii = reshape(subradii,1,prod(size(subradii)));
  

  % axisminor should not have any component parallel to axismajordirection.
  % remove it if present. This is like a Gram-Schimdt orthonormalization step
  axisminordirection=axisminordirection - (axisminordirection*(axismajordirection.'))/(axismajordirection*(axismajordirection.'))*axismajordirection;

  % instantiate crack as a WorkPlane
  crack=ModelWrapper(M,tag,geom.node.feature);
  crack.node=geom.node.feature.create(crack.tag,'WorkPlane');
  crack.node.label(crack.tag);

  crack.node.set('unite',true);  % 'Unite objects' option
  crack.node.set('planetype','general');

  % Origin of the local system
  WPgenpoint1 = to_cellstr_array(centerpoint,'m'); % Origin of the local system
  WPgenpoint2 = add_cellstr_array(WPgenpoint1,mul_cellstr_array_scalar(to_cellstr_array(axismajordirection),semimajoraxislen));   % X axis of the local system is in direction from WPgenpoint1 to here
  WPgenpoint3 = add_cellstr_array(WPgenpoint1,mul_cellstr_array_scalar(to_cellstr_array(axisminordirection),semiminoraxislen));   % Y axis of the local system is in this direction

  addprop(crack,'genpoints');
  crack.genpoints=[WPgenpoint1;WPgenpoint2;WPgenpoint3];
  crack.node.set('genpoints',crack.genpoints);

  % save parameters in object

  addprop(crack,'semimajoraxislen');
  crack.semimajoraxislen=semimajoraxislen;

  addprop(crack,'semiminoraxislen');
  crack.semiminoraxislen=semiminoraxislen;

  addprop(crack,'axismajordirection');
  crack.axismajordirection=axismajordirection;

  addprop(crack,'axisminordirection');
  crack.axisminordirection=axisminordirection;

  addprop(crack,'subradii');
  crack.subradii=subradii;


  % Create sub-shapes on workplane % CHANGE TO RECTANGLE
  addprop(crack,'subs');
  crack.subs={};
  for cnt=1:size(subradii,2)
    crack.subs{cnt}=ModelWrapper(M,sprintf('%s_sub%.3d',crack.tag,cnt),crack.node.geom.feature);
    thissemimajoraxislen = to_string(subradii(1,cnt),'m');
    if strcmp(cracktype,'through')
      thissemiminoraxislen = ['(' to_string(subradii(1,size(subradii,2)),'m') ')' '*' '(' to_string(semiminoraxislen) ')' '/' '(' to_string(semimajoraxislen) ')' ];
      crack.subs{cnt}.node=crack.node.geom.feature.create(crack.subs{cnt}.tag,'Rectangle');
      crack.subs{cnt}.node.set('size',{thissemimajoraxislen, thissemiminoraxislen});
    else
      thissemiminoraxislen = ['(' to_string(subradii(1,cnt),'m') ')' '*' '(' to_string(semiminoraxislen) ')' '/' '(' to_string(semimajoraxislen) ')' ];
      crack.subs{cnt}.node=crack.node.geom.feature.create(crack.subs{cnt}.tag,'Ellipse');
      crack.subs{cnt}.node.set('a',{thissemimajoraxislen}); % length along major axis
      crack.subs{cnt}.node.set('b',{thissemiminoraxislen}); % length along minor axis
    end
    crack.subs{cnt}.node.label(crack.subs{cnt}.tag);
    crack.subs{cnt}.node.set('type','solid');
    crack.subs{cnt}.node.set('base','center');
    crack.subs{cnt}.node.set('pos',{ '0','0' });
  end

  crack.node.set('createselection','on');

  % Create Partition object
  addprop(crack,'partition');
  crack.partition=ModelWrapper(M,[ tag '_partition' ],geom.node);
  crack.partition.node=geom.node.create(crack.partition.tag,'Partition');
  crack.partition.node.label(crack.partition.tag);
  crack.partition.node.selection('input').set({specimen.specimenunion.tag}); % object to be partition
  crack.partition.node.selection('tool').set({crack.tag}); % object doing partitioning (our work plane)
  crack.partition.node.set('createselection','on');


  % Create Point at crack center, and an integration that evaluates
  % expressions (such as crack relative motion) at that point

  % In the future, since this location technique assumes the centerpoint
  % is inside the material, and that assumption might not always be
  % satisfied, we might switch to creating the point at buildnormals
  % phase, by finding the nearest mesh node.

  CreateWrappedProperty(M,crack,'centerpoint',[tag '_centerpoint'],geom.node.feature,'Point');
  crack.centerpoint.node.label(crack.centerpoint.tag);
  crack.centerpoint.node.set('p',centerpoint); % set location
  crack.centerpoint.node.set('createselection','on');

  % Create a union representing specimen+crack+crackcenterpoint
  CreateWrappedProperty(M,crack,'unionwithspecimen',[tag '_unionwithspecimen'],geom.node.feature,'Union');
  crack.unionwithspecimen.node.label(crack.unionwithspecimen.tag);
  crack.unionwithspecimen.node.set('createselection','on');
  % specimen+crack is represented by our partition object
  crack.unionwithspecimen.node.selection('input').set({ crack.partition.tag, crack.centerpoint.tag });
  % Mark our union object as new representation of specimen.
  specimen.specimenunion=crack.unionwithspecimen;

  % Create an Integration node to represent the value there.
  CreateWrappedProperty(M,crack,'centerevaluate',[tag '_centerevaluate'],M.node.cpl,'Integration',geom.tag);
  crack.centerevaluate.node.selection.geom(geom.tag,0); % select points
  crack.centerevaluate.node.selection.named([ geom.tag '_' crack.centerpoint.tag '_pnt' ]);
  crack.centerevaluate.node.set('method','summation');  % sum over single point -- get value at that point.

  % Create a variable node to represent dynamic stress

  % obtain cellstr array representing normal direction to crack
  cracknormal=normalize_cellstr_array(crossproduct_cellstr_array(to_cellstr_array(axismajordirection),to_cellstr_array(axisminordirection)));
  nX=cracknormal{1};
  nY=cracknormal{2};
  nZ=cracknormal{3};


  % vibration_physicstags can be either a single tag or a cell array...
  % ... convert to cell array
  if isa(vibration_physicstags,'char')
    vibration_physicstags={ vibration_physicstags };
  end

  % create a variable <cracktag>_centerstress_<physicstag
  % representing the stress at the crack for each physics.
  % Create a single variable node that will hold multiple variables
  % (one per physics)
  CreateWrappedProperty(M,crack,'centerstress',[tag '_centerstress'],M.node.variable);
  crack.centerstress.node.model(M.component.tag); % variable goes under component, not top level model
  crack.centerstress.node.selection.global; % Set "Geometric entity level" to "entire model"

  % Create a variable <cracktag>_stress_<physicstag>
  % representing stress as a function of position for each physics
  % This represents a transform of the stress field to the crack
  % plane coordinate frame
  CreateWrappedProperty(M,crack,'stress',[tag '_stress'],M.node.variable);
  crack.centerstress.node.model(M.component.tag); % variable goes under component, not top level model
    
  for cnt=1:length(vibration_physicstags)
    vibration_physicstag=vibration_physicstags{cnt};

    % Obtain strain tensor components
    %eXX=[ tag '_centerevaluate(' vibration_physicstag '.eXX)' ];
    %eXY=[ tag '_centerevaluate(' vibration_physicstag '.eXY)' ];
    %eXZ=[ tag '_centerevaluate(' vibration_physicstag '.eXZ)' ];
    %eYY=[ tag '_centerevaluate(' vibration_physicstag '.eYY)' ];
    %eYZ=[ tag '_centerevaluate(' vibration_physicstag '.eYZ)' ];
    %eZZ=[ tag '_centerevaluate(' vibration_physicstag '.eZZ)' ];

    % Obtain stress tensor components
    % ... at center
    center_sx=[ tag '_centerevaluate(' vibration_physicstag '.sx)' ];
    center_sxy=[ tag '_centerevaluate(' vibration_physicstag '.sxy)' ];
    center_sxz=[ tag '_centerevaluate(' vibration_physicstag '.sxz)' ];
    center_sy=[ tag '_centerevaluate(' vibration_physicstag '.sy)' ];
    center_syz=[ tag '_centerevaluate(' vibration_physicstag '.syz)' ];
    center_sz=[ tag '_centerevaluate(' vibration_physicstag '.sz)' ];

    % ... everywhere
    sx=[ vibration_physicstag '.sx' ];
    sxy=[ vibration_physicstag '.sxy' ];
    sxz=[ vibration_physicstag '.sxz' ];
    sy=[ vibration_physicstag '.sy' ];
    syz=[ vibration_physicstag '.syz' ];
    sz=[ vibration_physicstag '.sz' ];


    % The differential motion is evaluated from the the normal
    % [ nX nY nZ ] multiplied by the local
    % strain tensor [ eXX eXY eXZ
    %                 eXY eYY eYZ
    %                 eXZ eYZ eZZ ]
    %
    % The result is
    % { eXX nX + eXY nY + eXZ nZ,
    %   eXY nX + eYY nY + eYZ nZ,
    %   eXZ nX + eYZ nY + eZZ nZ }

    % obtain cellstr array representing this product

    %centerstrainvec = {[ '(' eXX ')*(' nX ') + (' eXY ')*(' nY ') + (' eXZ ')*(' nZ ')' ], ...
    %		       [ '(' eXY ')*(' nX ') + (' eYY ')*(' nY ') + (' eYZ ')*(' nZ ')' ], ...
    %		       [ '(' eXZ ')*(' nX ') + (' eYZ ')*(' nY ') + (' eZZ ')*(' nZ ')' ]};

    centerstressvec = {[ '(' center_sx ')*(' nX ') + (' center_sxy ')*(' nY ') + (' center_sxz ')*(' nZ ')' ], ...
    		       [ '(' center_sxy ')*(' nX ') + (' center_sy ')*(' nY ') + (' center_syz ')*(' nZ ')' ], ...
    		       [ '(' center_sxz ')*(' nX ') + (' center_syz ')*(' nY ') + (' center_sz ')*(' nZ ')' ]};

    stressvec = {[ '(' sx ')*(' nX ') + (' sxy ')*(' nY ') + (' sxz ')*(' nZ ')' ], ...
    		       [ '(' sxy ')*(' nX ') + (' sy ')*(' nY ') + (' syz ')*(' nZ ')' ], ...
    		       [ '(' sxz ')*(' nX ') + (' syz ')*(' nY ') + (' sz ')*(' nZ ')' ]};

    
    % calculate magnitude of strain vector

    %centerstrainmag = magnitude_cellstr_array(centerstrainvec);
    centerstressmag = magnitude_cellstr_array(centerstressvec);
    stressmag = magnitude_cellstr_array(stressvec);


    
    % normal strain is inner product of strain vector with unit vector in crack normal direction
    %centerstrainnormal = innerprod_cellstr_array(centerstrainvec,cracknormal);

    % normal stress is inner product of stress vector with unit vector in crack normal direction
    centerstressnormal = innerprod_cellstr_array(centerstressvec,cracknormal);
    stressnormal = innerprod_cellstr_array(stressvec,cracknormal);
    
    % shear strain is inner product of strain vector with unit vector in crack semimajor (surface) direction 

    %centerstrainshear = innerprod_cellstr_array(centerstrainvec,normalize_cellstr_array(to_cellstr_array(axismajordirection)));


    % shear stress major is inner product of stress vector with unit vector in crack semimajor (surface) direction 
    centerstressshearmajor = innerprod_cellstr_array(centerstressvec,normalize_cellstr_array(to_cellstr_array(axismajordirection)));
    stressshearmajor = innerprod_cellstr_array(stressvec,normalize_cellstr_array(to_cellstr_array(axismajordirection)));
    % shear stress minor is inner product of stress vector with unit vector in crack semimajor (surface) direction 
    centerstressshearminor = innerprod_cellstr_array(centerstressvec,normalize_cellstr_array(to_cellstr_array(axisminordirection)));
    stressshearminor = innerprod_cellstr_array(stressvec,normalize_cellstr_array(to_cellstr_array(axisminordirection)));

    %CreateVariable(M,[tag '_centerstrainmag'],centerstrainmag);
    % add this variable to our variable node
    crack.centerstress.node.set([tag '_centerstressmag_' vibration_physicstag ],centerstressmag);
    crack.centerstress.node.set([tag '_centerstressnormal_' vibration_physicstag ],centerstressnormal);
    crack.centerstress.node.set([tag '_centerstressshearmajor_' vibration_physicstag ],centerstressshearmajor);
    crack.centerstress.node.set([tag '_centerstressshearminor_' vibration_physicstag ],centerstressshearminor);


    crack.stress.node.set([tag '_stressmag_' vibration_physicstag ],stressmag);
    crack.stress.node.set([tag '_stressnormal_' vibration_physicstag ],stressnormal);
    crack.stress.node.set([tag '_stressshearmajor_' vibration_physicstag ],stressshearmajor);
    crack.stress.node.set([tag '_stressshearminor_' vibration_physicstag ],stressshearminor);
    
    

  end


  % Create variables representing equivalent surface radius from crack center and which side
  % we are on

  position = { 'x', 'y', 'z' };
  position_from_center = sub_cellstr_array(position,to_cellstr_array(centerpoint,'m'));
  position_along_surface = innerprod_cellstr_array(position_from_center,to_cellstr_array(axismajordirection));
  position_into_depth = innerprod_cellstr_array(position_from_center,to_cellstr_array(axisminordirection));

  
  if strcmp(cracktype,'through') 
    % r_equiv_surface and position_along_surface are the same for a through crack. Keeping both to minimize changes in Heatflow study.
    r_equiv_surface =  [ 'abs(' position_along_surface ')' ] ;
  else

    scaled_position_into_depth = ['((' to_string(semimajoraxislen) ')/(' to_string(semiminoraxislen) '))*(' position_into_depth ')'];
    r_equiv_surface = [ 'sqrt(' '(' position_along_surface ')^2' '+' '(' scaled_position_into_depth ')^2' ')' ]; 

  end 

  addprop(crack,'r_equiv_surface');
  crack.r_equiv_surface = CreateVariable(M,[tag '_r_equiv_surface'],r_equiv_surface); % NOTE: CreateVariable returns the variable name, not the variable object itself. 

  %addprop(crack,'crack_side'); % has value 1 for left side of crack, 2 for right side of crack
  %crack.crack_side = CreateVariable(M,[tag '_crack_side'],[ 'if((' position_along_surface ') < 0,1,2)' ]); 

  addprop(crack,'position_along_surface'); 
  crack.position_along_surface = CreateVariable(M,[tag '_position_along_surface'],position_along_surface); 

  if exist('heatingfile','var') 
    if ~isempty(heatingfile)
      % Create an interpolation function representing crack heating --
      %  data to be loaded from an external file based on external (non-COMSOL) calculations
      addprop(crack,'heatingfunction');
      crack.heatingfunction = CreateFunction(M,[ tag '_heatingfunction' ], 'Interpolation');
      crack.heatingfunction.node.label([ tag '_heatingfunction' ]);
      crack.heatingfunction.node.set('sourcetype','user');
      crack.heatingfunction.node.set('source','file');
      crack.heatingfunction.node.set('struct','spreadsheet');
      crack.heatingfunction.node.set('filename',buildabspath(heatingfile)); % must use absolute path here because COMSOL current directory is the mli (LiveLink) directory
      crack.heatingfunction.node.set('interp','linear');
      crack.heatingfunction.node.set('argunit','s,m');  
      crack.heatingfunction.node.set('fununit','W/m^2');  
      crack.heatingfunction.node.set('nargs',2); % function of two parameters (first column time, second column radius)
      % side 1 is first column after parameter columns
      crack.heatingfunction.node.setIndex('funcs', [ tag '_heatingfunction_side1' ], 0,0);
      crack.heatingfunction.node.setIndex('funcs', '1' , 0,1);
      
      % side 2 is second column after parameter columns
      crack.heatingfunction.node.setIndex('funcs', [ tag '_heatingfunction_side2' ], 1,0);
      crack.heatingfunction.node.setIndex('funcs', '2' , 1,1);
    end
  end
  % Add thin elastic layers for each half-annulus

  % geom.node.run;  % build geometry

  % crack.elasticlayers={};
  % for cnt=1:size(annuliradii,2)


  % Create thin elastic layer on crack surfaces, to represent discontinuity if that is desired
  % (BC class 'crackdiscontinuity')
  % Please note that as of 2/12/15 this is inoperable -- for some reason
  % continuity is still enforced -- at least in the static case
  AddBoundaryCondition(M,geom,crack, sprintf('%s_ellayer',crack.tag), ...
		         { 'solidmech_static', 'solidmech_harmonicper', 'solidmech_harmonic', 'solidmech_modal','solidmech_timedomain'}, ... % physicses
                         { 'crackdiscontinuity' }, ...  % BC classes
                         @(M,physics,bcobj) ...
                         BuildCrackElasticLayerBCs(M,geom,physics,crack,bcobj));

  % Create continuity BC on crack faces if that is what is desired
  % (BC class 'crackcontinuity')
  %  *** No explicit BC is required *** -- continuity is the default for internal boundaries
  %AddBoundaryCondition(M,geom,crack, sprintf('%s_ellayer',crack.tag), ...
  %		         { 'solidmech_static', 'solidmech_harmonicper', 'solidmech_harmonic', 'solidmech_modal'}, ... % physicses
  %                       { 'crackcontinuity' }, ...  % BC classes
  %                       @(M,physics,bcobj) ...
  %                       BuildCrackElasticLayerBCs(M,geom,physics,crack,bcobj));


  % Apply a series of boundary conditions to the different half-annuli of the crack.
  % GetCrackBoundaries() returns a sorted list of boundaries (contact areas) from the
  % center to the outside. We provide a cell array of heat intensity parameters
  % as input.
  %if ~exist('QbExpressions','var')
  %  % No explicit parameter provided... Use Crack Heating Model
  %  prevpos='0.0[m]';
  %  for cnt=1:size(annuliradii,2)
  %
  %    CrackBoundaryQbs{cnt}=['meeker_statmodel_040815_eval(freq, ' tag '_centerstrainmag_' vibration_physicstags{length(vibration_physicstags)} ',' to_string(semimajoraxislen,'m') ',' to_string(closure(cnt,2),'MPa') ', ' prevpos ',' to_string(closure(cnt,1),'m') ', wh, 50.0)' ];
  %
  %    prevpos=to_string(closure(cnt,1),'m');
  %  end
  %
  %elseif isa(QbExpressions,'cell')
  %  % QbExpressions passed as cell array... use it directly
  %  CrackBoundaryQbs=QbExpressions;
  %elseif isa(QbExpressions,'char')
  %% Apply sprintf in loop to provided expression string
  %  CrackBoundaryQbs={};
  %  for cnt=1:size(closure,1)
  %    CrackBoundaryQbs{cnt}=sprintf(QbExpressions,cnt);
  %  end
  %  
  %else
  %  assert(isa(QbExpressions,'double'));
      
      % numeric parameter
  %  %

  %  if prod(size(QbExpressions)) > 1
  %    % multiple values
  %    CrackBoundaryQbs={};
  %    for cnt=1:size(closure,1)
  %      CrackBoundaryQbs{cnt}=to_string(QbExpressions(cnt),'W/m^2');
  %    end
  %  else
  %    % single value
  %    CrackBoundaryQbs={};
  %    for cnt=1:size(closure,1)
  %      CrackBoundaryQbs{cnt}=to_string(QbExpressions,'W/m^2');
  %    end
  %
  %  end
  %end
  

  if exist('heatingfile','var') 
    if ~isempty(heatingfile)
      AddBoundaryCondition(M,geom,crack, sprintf('%s_heatsrc',crack.tag), ...
  			   { 'heatflow' }, ... % physicses
			   { 'crackheating' }, ...  % BC classes
			   @(M,physics,bcobj) ...
			    BuildBoundaryHeatSourceBCs(M,geom,physics,crack,bcobj, ...
						       @(M,geom,crack) ...
							GetCrackBoundaries(M,geom,crack), ...
						       ['if((' crack.position_along_surface ') < 0[m],' tag '_heatingfunction_side1(t,' crack.r_equiv_surface '),' tag '_heatingfunction_side2(t,' crack.r_equiv_surface '))' ]));
      
    end
  end
end
