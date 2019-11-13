%> CREATECRACK Creates a a crack at a given position
%>   [crack] = CREATECRACK(M, geom, tag, specimen, centerpoint, semimajoraxislen,
%>                         semiminoraxislen, axismajordirection,
%>                         axisminordirection,closure,
%>                         vibration_physicstags,QbExpressions)
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
%> axismajordirection:  Direction of semi-major axis
%> axisminordirection:  Direction of semi-minor axis
%> closure:             A 2 column matrix of (axismajor_endboundary,
%>                      closurestate_MPa). Last entry of first column of
%>                      closure should match the value of semimajoraxislen.
%> vibration_physicstags: A cell array of tag names representing physics models
%>                      used for vibration calculation. For each of these a
%>                      variable [ cracktag '_centerstrainmag_' physicstag ]
%>                      will be created representing the local strain field
%>                      at the centerpoint. Please note that for this to be
%>                      meaningful that physics should be configured for
%>                      continuity mechanical boundary conditions across the
%>                      crack (otherwise strain isn't well defined for a
%>                      discontinuity). The LAST of the physicstags provided
%>                      will be the one used for the heatsrc (Qb) boundary condition
%> weakformpdephysicstag A parameter, may be blank [] that is passed to 
%>                       BuildBoundaryHeatSourceBCs to accelerate MATLAB 
%>                       heat source calculations through an intermediate
%>                       weak form PDE physics calculation 
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
%>
%> Closure is measured in MPa. Positions should be in order, representing the
%> outer radius of each semi-annular ring, with the corresponding closure stress
%> representing the average closure stress over that semi-annular ring.


  %> Example parameter values:
  %> centerpoint=[.07,.0254/2,.012];
  %> semimajoraxislen=.003;
  %> semiminoraxislen=.0028;
  %> axismajordirection=[0,1,0];
  %> axisminordirection=[0,0,-1];
  %> closure=[ .001, -30 ; .002, 0 ; .003, 60];
  %> QbExpressions='heatintensity%.2d'
function [crack] = CreateCrack(M,geom, tag, specimen, centerpoint, semimajoraxislen, semiminoraxislen, axismajordirection,axisminordirection,closure,vibration_physicstags,weakformpdephysicstag,QbExpressions)

  % axismajordirection, axisminordirection are row vectors
  axismajordirection=reshape(axismajordirection,1,3);
  axisminordirection=reshape(axisminordirection,1,3);

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

  addprop(crack,'closure');
  crack.closure=closure;


  % Create ellipses on workplane
  addprop(crack,'ellipses');
  crack.ellipses={};
  for cnt=1:size(closure,1)
    crack.ellipses{cnt}=ModelWrapper(M,sprintf('%s_ellipse%.3d',crack.tag,cnt),crack.node.geom.feature);
    crack.ellipses{cnt}.node=crack.node.geom.feature.create(crack.ellipses{cnt}.tag,'Ellipse');
    crack.ellipses{cnt}.node.label(crack.ellipses{cnt}.tag);
    crack.ellipses{cnt}.node.set('type','solid');
    crack.ellipses{cnt}.node.set('base','center');
    crack.ellipses{cnt}.node.set('pos',{ '0','0' });
    thissemimajoraxislen = to_string(closure(cnt,1),'m');
    thissemiminorlen = ['(' to_string(closure(cnt,1),'m') ')' '*' '(' to_string(semiminoraxislen) ')' '/' '(' to_string(semimajoraxislen) ')' ];
    crack.ellipses{cnt}.node.set('a',{thissemimajoraxislen}); % length along major axis
    crack.ellipses{cnt}.node.set('b',{thissemiminorlen}); % length along minor axis
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

  % Create a variable node to represent dynamic strain

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

  % create a variable <cracktag>_centerstrainmag_<physicstag
  % representing the motion at the crack for each physics.
  % Create a single variable node that will hold multiple variables
  % (one per physics)
  CreateWrappedProperty(M,crack,'centerstrainmag',[tag '_centerstrainmag'],M.node.variable);
  crack.centerstrainmag.node.model(M.component.tag); % variable goes under component, not top level model
  crack.centerstrainmag.node.selection.global; % Set "Geometric entity level" to "entire model"

  for cnt=1:length(vibration_physicstags)
    vibration_physicstag=vibration_physicstags{cnt};

    % Obtain strain tensor components
    eXX=[ tag '_centerevaluate(' vibration_physicstag '.eXX)' ];
    eXY=[ tag '_centerevaluate(' vibration_physicstag '.eXY)' ];
    eXZ=[ tag '_centerevaluate(' vibration_physicstag '.eXZ)' ];
    eYY=[ tag '_centerevaluate(' vibration_physicstag '.eYY)' ];
    eYZ=[ tag '_centerevaluate(' vibration_physicstag '.eYZ)' ];
    eZZ=[ tag '_centerevaluate(' vibration_physicstag '.eZZ)' ];


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

    centerstrainvec = {[ '(' eXX ')*(' nX ') + (' eXY ')*(' nY ') + (' eXZ ')*(' nZ ')' ], ...
    		       [ '(' eXY ')*(' nX ') + (' eYY ')*(' nY ') + (' eYZ ')*(' nZ ')' ], ...
    		       [ '(' eXZ ')*(' nX ') + (' eYZ ')*(' nY ') + (' eZZ ')*(' nZ ')' ]};

    % calculate magnitude of strain vector

    centerstrainmag = magnitude_cellstr_array(centerstrainvec);

    %CreateVariable(M,[tag '_centerstrainmag'],centerstrainmag);
    % add this variable to our variable node
    crack.centerstrainmag.node.set([tag '_centerstrainmag_' vibration_physicstag ],centerstrainmag);

  end


  % Add thin elastic layers for each half-annulus

  % geom.node.run;  % build geometry

  % crack.elasticlayers={};
  % for cnt=1:size(closure,1)


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
  if ~exist('QbExpressions','var')
    % No explicit parameter provided... Use Crack Heating Model
    prevpos='0.0[m]';
    for cnt=1:size(closure,1)

      CrackBoundaryQbs{cnt}=['meeker_statmodel_040815_eval(freq, ' tag '_centerstrainmag_' vibration_physicstags{length(vibration_physicstags)} ',' to_string(semimajoraxislen,'m') ',' to_string(closure(cnt,2),'MPa') ', ' prevpos ',' to_string(closure(cnt,1),'m') ', wh, 50.0)' ];

      prevpos=to_string(closure(cnt,1),'m');
    end

  elseif isa(QbExpressions,'cell')
    % QbExpressions passed as cell array... use it directly
    CrackBoundaryQbs=QbExpressions;
  elseif isa(QbExpressions,'char')
    % Apply sprintf in loop to provided expression string
    CrackBoundaryQbs={};
    for cnt=1:size(closure,1)
      CrackBoundaryQbs{cnt}=sprintf(QbExpressions,cnt);
    end
  else
    assert(isa(QbExpressions,'double'));

    % numeric parameter
    %

    if prod(size(QbExpressions)) > 1
      % multiple values
      CrackBoundaryQbs={};
      for cnt=1:size(closure,1)
        CrackBoundaryQbs{cnt}=to_string(QbExpressions(cnt),'W/m^2');
      end
    else
      % single value
      CrackBoundaryQbs={};
      for cnt=1:size(closure,1)
        CrackBoundaryQbs{cnt}=to_string(QbExpressions,'W/m^2');
      end

    end
  end


  AddBoundaryCondition(M,geom,crack, sprintf('%s_heatsrc',crack.tag), ...
		       { 'heatflow' }, ... % physicses
                       { 'crackheating' }, ...  % BC classes
		       @(M,physics,bcobj) ...
		       BuildBoundaryHeatSourceBCs(M,geom,physics,crack,bcobj, ...
						  @(M,geom,crack) ...
						  GetCrackBoundaries(M,geom,crack), ...
						  'excitationwindow(t)',CrackBoundaryQbs, ...
						  weakformpdephysicstag));
end