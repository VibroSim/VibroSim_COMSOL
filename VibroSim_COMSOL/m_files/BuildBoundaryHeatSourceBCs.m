%> builds a set of boundary heat source BCs, one on each boundary according to the output of getfaceselectionfunc.
%> The intensity of heat sources is set to heatflowQbs, which should be a cell array with length matching the number
%> of returns from getfaceselectionfunc()
%>

%> OBSOLETE weakformpdephysicstag, if supplied, is the tag of a weak-form boundary PDE physics node
%> to be used to minimize the calls to the functions in heatflowQbs. This is useful 
%> when those functions are calls to MATLAB that are slow. 
%> the weak-form boundary PDE physics node is evaluated in a separate step and converts
%> the heatflowQB values into COMSOL results that can be evaluated directly with no 
%> more calls to MATLAB. This function will create the needed weak form PDE equations
%> over the relevant selections


function [bcobj] = BuildBoundaryHeatSourceBCs(M,geom,physics,object,bcobj,getfaceselectionfunc,heatflowQb)

  % heatflowQbs,,weakformpdephysicstag)

% !!!*** We assume the variable used in the weak form equation is called 'wfb'.
% ... CAN WE EXTRACT THIS FROM THE PHYSICS OBJECT SOMEHOW? 

% Create a boundary condition representing a heat source  on a face.

    bcobj.parent=physics.node.feature; % store how to remove this object

    % get the list of boundaries
    boundaries=getfaceselectionfunc(M,geom,object);

    bcobj.children={};

    addprop(bcobj,'wf_pde');
    bcobj.wf_pde={};
    % loop over the list and set individual heat sources at each boundary
    for cnt=1:length(boundaries)
      % Create boundary condition
      bcobj.children{cnt}=ModelWrapper(M,sprintf('%s_%.3d',bcobj.tag,cnt),physics.node.feature);
      bcobj.children{cnt}.node=physics.node.feature.create(bcobj.children{cnt}.tag,'BoundaryHeatSource',2);
      bcobj.children{cnt}.node.label(bcobj.children{cnt}.tag);
      bcobj.children{cnt}.node.selection.set([ boundaries(cnt) ] );
      %weakformpdephysicstag
      %prod(size(weakformpdephysicstag))
      %~prod(size(weakformpdephysicstag))
      %if ~exist('weakformpdephysicstag','var') |  ~prod(size(weakformpdephysicstag))
      %bcobj.children{cnt}.node.set('Qb',[ '(' timedependence ')*(' heatflowQb ')' ]);
bcobj.children{cnt}.node.set('Qb',[ '(' heatflowQb ')' ]);
      %else
      %  weakformpdephysicsnode=M.node.physics(weakformpdephysicstag);
      %  % Enable this boundary for weakformpdephysicsnode
      %  oldselection=mphgetselection(weakformpdephysicsnode.selection);
      %  newselection=union(oldselection.entities,[ boundaries(cnt) ]);
      %  weakformpdephysicsnode.selection.set(newselection);
      %
      %  % Create WeakFormPDE node for this boundary
      %  bcobj.wf_pde{cnt}=CreateWrappedModel(M,sprintf('%s_wfp%.3d',bcobj.tag,cnt),weakformpdephysicsnode.feature,'WeakFormPDE',2); 
      %  bcobj.wf_pde{cnt}.node.selection.set([ boundaries(cnt) ]);		      % 
      %  bcobj.wf_pde{cnt}.node.setIndex('weak',[ 'test(wfb)*(wfb-(' heatflowQbs{cnt} '))' ],0);
      %  bcobj.children{cnt}.node.set('Qb',[ '(' timedependence ')*(wfb)' ]);
      %
      %
      %end
      % store selection in case it is needed later...
      addprop(bcobj.children{cnt},'boundaryentities');
      bcobj.children{cnt}.boundaryentities=[boundaries(cnt)];
    end						

end
