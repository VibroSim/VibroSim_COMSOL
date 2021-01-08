function calc_straincoefficient(basename, id)

  isolators_and_couplant=false;   % Should we generate isolators and couplant
  % (these are optional for the modal analysis)
  
  using_datacollect=true;  % default using_datacollect to false
  
  [~,basefilename]=fileparts(basename);

  if java.io.File(basename).isAbsolute()
     absolutebasename = basename
  else
      absolutebasename = char(java.io.File(basename).getCanonicalPath());
  end
  
  % You may wish to uncomment these next two lines if this is part of a function
  % -- that way if the function fails you can access the wrapped and unwrapped model 
  % variables just because they are globals. 
  global M
  global model

  % InitializeVibroSimScript() connects to COMSOL and initializes and 
  % returns the wrapped model variable (M) and the unwrapped node (model). 
  [M,model]=InitializeVibroSimScript();
	
	
	
  % Call a function that sets various parameters to be used by the model. 
  straincoefficient_params(M,isolators_and_couplant,using_datacollect);
  
  % Extract parameters that will be needed below



  spcmaterial_struct = GetDCParamStringValue(M,'spcmaterial');
  
  
  % Define a procedure for building the geometry. Steps can be sequenced by using
  % the pipe (vertical bar | ) character. 
  if isolators_and_couplant

    % offset top mounts by specimen thickness in z
    bottommountoffsetz=ObtainDCParameter(M,'spcthickness','m');
    
    % offset all mounts by half specimen width in y
    mountoffsety=[ '(' ObtainDCParameter(M,'spcwidth','m') ')/2.0' ];
    
    % offset top mounts by specimen thickness in z
    bottommountoffsetz=ObtainDCParameter(M,'spcthickness','m');
    
    
    %                                    x                              y               z      angle
    isolator_coords={ObtainDCParameter(M,'tlmountoffsetx','m'),     mountoffsety,     '0.0',   '0.0',  % top-left
		     ObtainDCParameter(M,'trmountoffsetx','m'),     mountoffsety,     '0.0',   '0.0',  % top-right
                     ObtainDCParameter(M,'blmountoffsetx','m'),     mountoffsety,     bottommountoffsetz, '0.0',  % bottom-left
		     ObtainDCParameter(M,'brmountoffsetx','m'),     mountoffsety,     bottommountoffsetz, '0.0'}; % bottom-right
    
    xduceroffsetx=ObtainDCParameter(M,'xduceroffsetx','m');
    
    %                 x          y         z      angle
    couplant_coord={ xduceroffsetx,   mountoffsety,     bottomoffsetz,      'NaN'   };
    
	  
    bldgeom = @(M,geom) CreateRectangularBarSpecimen(M,geom,'specimen',ObtainDCParameter(M,'spclength','m'),ObtainDCParameter(M,'spcwidth','m'),ObtainDCParameter(M,'spcthickness','m'),spcmaterial_struct.value) | ...
	      @(specimen) AttachThinCouplantIsolators(M,geom,specimen, ...
						      couplant_coord, ...
						      isolators_coords) | ...
	      ... % Top-left and top-right isolators (.isolators{1} and .isolators{2}: net force of -staticload_mount in the z direction
	      @(specimen) AddBoundaryCondition(M,specimen,specimen.isolators{1},...
					       [specimen.isolators{1}.tag '_tltrforce'], ...
					       'solidmech_static',...  % physics
					       'staticloading', ...    % BC class
					       @(M,physics,bcobj) ...
						BuildFaceTotalForceBC(M,geom,physics,specimen.isolators{1},bcobj,...
								      @(M,geom,tlisolator) ...
								       union(specimen.isolators{1}.getfreefaceselection(M,geom,specimen.isolators{1}), ...
									     specimen.isolators{2}.getfreefaceselection(M,geom,specimen.isolators{2})), ...
								      {'0','0','-staticload_mount'})) | ...
              ... % Bottom-left isolator (.isolators{3}) is fixed
              @(specimen) AddBoundaryCondition(M,specimen,specimen.isolators{3}, ...
					       [specimen.isolators{3}.tag '_blfixed'],...
					       'solidmech_static', ...  % physics
					       'staticloading', ...     % BC class
					       @(M,physics,bcobj) ...
						BuildFaceFixedBC(M,geom,physics, ...
								 specimen.isolators{3}, ...
								 bcobj, ...
								 specimen.isolators{3}.getfreefaceselection)) |  ...
	      ... % Bottom-right isolator (.isolators{4}) is rolling -- displacement in the Z direction is zero
	      @(specimen) AddBoundaryCondition(M,specimen,specimen.isolators{4},[specimen.isolators{4}.tag '_brrolling'], ...
					       'solidmech_static', ...
					       'staticloading', ...
					       @(M,physics,bcobj) ...
						BuildFaceDirectionalDisplacementBC(M,geom,physics,...
										   specimen.isolators{4},...
										   bcobj, ...
										   specimen.isolators{4}.getfreefaceselection, ...
										   GetOutwardNormal(M,geom,specimen.isolators{4}.pos,specimen.isolators{4}.centerpos), ...
										   0.0)) | ...
	      ... % Force condition on couplant
	      @(specimen) AddBoundaryCondition(M,specimen,specimen.couplant,[specimen.couplant.tag '_xducerforce'], ...
					       'solidmech_static', ...
					       'staticloading', ...
					       @(M,physics,bcobj) ...
						BuildFaceTotalForceBC(M,geom,physics,specimen.couplant,bcobj, ...
								      specimen.couplant.getfreefaceselection, ...
								      ... % xducerforce is multiplied by outward normal 
		  			                              ... % on the couplant, which is equivalent to the
					                              ... % inward normal on the specimen
								      MultiplyScalarStrByNumericVec('xducerforce', ...
												    GetOutwardNormal(M,geom,specimen.couplant.pos,specimen.couplant.centerpos))));
    
    
  else 
    bldgeom = @(M,geom) CreateRectangularBarSpecimen(M,geom,'specimen',ObtainDCParameter(M,'spclength','m'),ObtainDCParameter(M,'spcwidth','m'),ObtainDCParameter(M,'spcthickness','m'),spcmaterial_struct.value);
  end


  crackshape_struct = GetDCParamStringValue(M,'simulationcrackshape');
  if ~isempty(strfind(crackshape_struct.value,'penny'))
      createcrack_type = 'penny';
  elseif ~isempty(strfind(crackshape_struct.value,'through'))
      createcrack_type = 'through';
  else
      fprintf(2,'VibroSim_COMSOL calc_straincoefficient.m: WARNING: DC Parameter simulationcrackshape (%s) did not include either ''penny'' or ''through'' substrings\n',crackshape_struct.value); 
      createcrack_type = 'unknown';
  end

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
					    [ .001, .002, .003 ], ...
					    'solidmech_modal',...
					    [],...  % heatingfile
					    createcrack_type);
  
  % Define a procedure for creating the various physics definitions. Steps can be 
  % sequenced by using the pipe (vertical bar | ) character.
  addprop(M,'solidmech_modal'); % since we are manually assigning the property we must create it first. 
  bldphysics = @(M,geom,specimen,flaw) M.setprop('solidmech_modal',CreateVibroModal(M,geom,'solidmech_modal'));
  
  % Define a procedure to create needed COMSOL result nodes. Generally can pass
  % either the wrapped model (M) or unwrapped (model). Pipelining will only work
  % with the wrapped model 'M'.
  genresults = @(M) DynamicStrainResults(M,'solidmech_modal',fullfile([absolutebasename,'.png']));
  
  
	
  % Define a path and filename for saving the generated COMSOL model.
  % BuildVibroModel() will create the model's directory if necessary
  savefilename = fullfile(tempdir,sprintf('vibrosim_%s',char(java.lang.System.getProperty('user.name'))),[basefilename, '.mph']);
  
  % Given the model wrapper, the procedures for building the geometry, the crack, the physics,
  % and for storing the results, and a file name for saving, have COMSOL build the model.x
  BuildVibroModel(M,...
		  bldgeom, ...
		  bldcrack, ...
		  bldphysics, ...
		  genresults, ...
		  savefilename);
  
  % Uncomment these next two lines to run the model and save the output after building the model
  RunAllStudies(model);
  mphsave(M.node,savefilename);
  
  
  
  % If you specify mode as 'build' you will manually need to run studies and
  % interpret results. Here are the correct MATLAB commands to do that:
  % 
  % RunAllStudies(model);
  CalculateDynamicStrainCoeff(model,'Geom','crack','solidmech_modal','specimen');
  

  % if you call RunVibroModel and it errors out, you can
  % still get access to M and model and everything under them with:
  % M=FindWrappedObject([],'Model');
  % model=M.node;
  if using_datacollect
    dc_requestvalhref('simulation_modeshape',fullfile([basename,'.png']))
  end
  
end
