function [contactor] = BuildContactor(M,geom,contactor,shape,pos,normalvec,angle,leng,width,thickness)
  % pos is the center of the contact face

  % Shape Options
  shapeoptions = {'Circle', 'Rectangle'};

  % Validate contactor shape
  if ~any(validatestring(shape,shapeoptions))
    error('CreateCouplant:ParameterException', strcat('Shape "', shape, '" Not Implemented'))
  end

  % convert pos and normalvec to string cell arrays because that is required for 
  % the formula creation for rectangular case, below
  pos_ca=to_cellstr_array(pos,'m');
  normalvec_ca=to_cellstr_array(normalvec,'m');
  thickness_str=to_string(thickness);
  width_str=to_string(width);

  contactor.parent=geom.node.feature;  % make it possible to programmatically destroy this object.
  
  % store requested position (center of contact face)
  addprop(contactor,'pos');
  contactor.pos=pos_ca;
 
  % calculate geometric center
  % Need to shift pos 1/2 thickness in the normalvec direction so that the 
  % original pos is the center of one face

  % i.e. centerpos = pos + (thickness/2)*normalvec/|normalvec|

  % Create string math expression. First normalvecmag for |normalvec|    
  normalvecmagsq='0';
  for cnt=1:length(normalvec_ca)
    normalvecmagsq=[normalvecmagsq '+ (' normalvec_ca{cnt} ')^2'];
  end
  normalvecmag=['sqrt(' normalvecmagsq ')'];

  % Now calculate centerpos
  centerpos={};
  for cnt=1:length(pos)
    centerpos{cnt}=[ '(' pos_ca{cnt} ') + ((' thickness_str ')/2)*(' normalvec_ca{cnt} ')/(' normalvecmag ')' ];
  end


  % store calculated geometric center
  addprop(contactor,'centerpos');
  contactor.centerpos=centerpos;

  % Finally, build geometry
  if strcmp(shape,'Circle')
    contactor.node=geom.node.feature.create(contactor.tag,'Cylinder');
    contactor.node.label(contactor.tag);
    contactor.node.set('axistype','cartesian');
    contactor.node.set('rot', angle);
    % For Cylinder, selected position through pos parameter is directly 
    % in the center of one end. We choose this to be the contact side. 
    contactor.node.set('pos',pos);
    contactor.node.set('ax3', to_cellstr_array(normalvec));  % may need to convert to string cell array
    contactor.node.set('r', ['(' width_str ')/2.0'] );
    contactor.node.set('h', thickness );
 
  else
    % Rectangle
    contactor.node=geom.node.feature.create(contactor.tag,'Block');
    contactor.node.label(contactor.tag);
    contactor.node.set('axistype','cartesian');
    contactor.node.set('base','center');
    %normalvec
    % to_cellstr_array(normalvec)
    contactor.node.set('axis', to_cellstr_array(normalvec));  % may need to convert to string cell array
    contactor.node.set('size', { leng, width, thickness });
    contactor.node.set('rot', angle);
    
    % For block, selected position through 'pos' parameter is in the geometric center
    contactor.node.set('pos',centerpos);
    
  end
  contactor.node.set('createselection','on');

  % Run node so we can create selections
  geom.node.run();
    
  % Create contact and free faces 
  addprop(contactor,'getcontactfaceselection');
  addprop(contactor,'getfreefaceselection');
  if strcmp(shape,'Circle')
    contactor.getcontactfaceselection=@(M,geom,contactor) GetCylinderFace(M,geom,contactor, -normalvec);
    contactor.getfreefaceselection=@(M,geom,contactor) GetCylinderFace(M,geom,contactor, normalvec);
  else
    contactor.getcontactfaceselection=@(M,geom,contactor) GetBlockFace(M,geom,contactor, -normalvec);
    contactor.getfreefaceselection=@(M,geom,contactor) GetBlockFace(M,geom,contactor, normalvec);
  end


  % create domain selection
  contactor.getdomainselection=@(M,geom,contactor) GetDomain(M,geom,contactor);
