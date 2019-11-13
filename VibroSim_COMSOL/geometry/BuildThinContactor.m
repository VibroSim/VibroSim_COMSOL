function [contactor] = BuildThinContactor(M,geom,contactor,specimen,shape,pos,normalvec,angle,leng,width)
  % pos is the center of the contact face
  % WARNING: angle may not work quite the same way as for regular contactors

  % Shape Options
  shapeoptions = {'Circle', 'Rectangle'};

  % Validate contactor shape
  if ~any(validatestring(shape,shapeoptions))
    error('BuildThinContactor:ParameterException', strcat('Shape "', shape, '" Not Implemented'))
  end

  % convert pos and normalvec to string cell arrays because that is required for 
  % the formula creation for rectangular case, below
  pos_ca=to_cellstr_array(pos,'m');
  normalvec_ca=to_cellstr_array(normalvec,'m');
  width_str=to_string(width);
  leng_str=to_string(leng);

  contactor.parent=geom.node.feature;  % make it possible to programmatically destroy this object.
  
  % store requested position (center of contact face)
  addprop(contactor,'pos');
  contactor.pos=pos_ca;
 
  % store geometric center
  addprop(contactor,'centerpos');
  contactor.centerpos=pos_ca;

  % normalized normalvec
  normalizedvec = normalize_cellstr_array(normalvec_ca);

  % Define work plane
  BuildWrappedModel(M,contactor,geom.node.feature,'WorkPlane');
  contactor.node.label(contactor.tag);
  contactor.node.set('unite',true);
  contactor.node.set('planetype','coordinates');
  contactor.node.set('createselection','on');

  % Origin of the local system
  WPgenpoint1 = to_cellstr_array(pos_ca,'m'); % Origin of the local system

  % orient as follows: 
  % try to make 1st axis in the x direction 
  % if abs(y cross normal) > .5)
  %   firstdir=(y cross normal)
  %   seconddir=(normal cross firstdir) = (normal cross (y cross normal)
  % else   
    % try to make 2nd axis in the y direction 
    % seconddir=(normal cross x)  
    % firstdir =(seconddir cross normal) = (normal cross x) cross normal 
  % Evaluate y cross normal

  ycrossnormal=crossproduct_cellstr_array({ '0.0','1.0','0.0'},normalizedvec);
  mag_ycrossnormal=magnitude_cellstr_array(ycrossnormal);
  normal_cross_ycrossnormal=crossproduct_cellstr_array(normalizedvec,ycrossnormal);

  normalcrossx=crossproduct_cellstr_array(normalizedvec,{ '1.0','0.0','0.0' });
  normalcrossx_cross_normal=crossproduct_cellstr_array(normalcrossx,normalizedvec);

  firstdir={};
  seconddir={};
  for cnt=1:3
    firstdir{cnt}  = [ 'if((' mag_ycrossnormal ') > 0.5,' ycrossnormal{cnt} ',' normalcrossx_cross_normal{cnt} ')' ];
    seconddir{cnt} = [ 'if((' mag_ycrossnormal ') > 0.5,' normal_cross_ycrossnormal{cnt} ',' normalcrossx{cnt} ')' ];
  end

  WPgenpoint2 = add_cellstr_array(WPgenpoint1,firstdir);   % X axis of the local system is in direction from WPgenpoint1 to here
  WPgenpoint3 = add_cellstr_array(WPgenpoint1,seconddir);   % Y axis of the local system is in this direction
  
  addprop(contactor,'genpoints');
  contactor.genpoints=[WPgenpoint1;WPgenpoint2;WPgenpoint3];
  contactor.node.set('genpoints',contactor.genpoints);


  % Finally, build geometry
  if strcmp(shape,'Circle')
    CreateWrappedProperty(M,contactor,'layout',[ contactor.tag '_layout' ],contactor.node.geom,'Circle');
    contactor.layout.node.label(contactor.layout.tag);
    contactor.layout.node.set('base','center');
    contactor.layout.node.set('pos',{ '0.0', '0.0' });
    contactor.layout.node.set('r', [ '(' width_str ')/2.0' ]);
  else
    % Rectangle
    CreateWrappedProperty(M,contactor,'layout',[ contactor.tag '_layout' ],contactor.node.geom,'Rectangle');
    contactor.layout.node.label(contactor.layout.tag);
    contactor.layout.node.set('base','center');
    contactor.layout.node.set('pos',{ '0.0', '0.0' });
    contactor.layout.node.set('rot',angle);
    contactor.layout.node.set('size',{ leng_str, width_str });
  end

  % Create union with specimen
  CreateWrappedProperty(M,contactor,'union',[ contactor.tag '_union' ],geom.node.feature,'Union');
  contactor.union.node.label(contactor.union.tag);
  contactor.union.node.set('createselection','on');
  contactor.union.node.selection('input').set({ specimen.specimenunion.tag, contactor.tag });
  % Mark this union as the specimenunion
  specimen.specimenunion=contactor.union;

  % Run node so we can create selections
  %geom.node.run();
    
  % Create contact face (sole boundary)
  addprop(contactor,'getcontactfaceselection');
  contactor.getcontactfaceselection=@(M,geom,contactor) GetBoundary(M,geom,contactor);

  addprop(contactor,'getfreefaceselection');
  % free face is the same as contact face
  contactor.getfreefaceselection=contactor.getcontactfaceselection;


