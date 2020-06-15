%> CREATERECTANGULARBARSPECIMEN Creates a Rectangular Bar Specimen
%>   [specimen] = CREATERECTANGULARBARSPECIMEN(M, geom, tag, spclength, spcwidth, spcthickness) Creates Bar With given geometry
function [specimen] = CreateRectangularBarSpecimen(M,geom,tag,spclength,spcwidth,spcthickness,spcmaterial)

  specimen=ModelWrapper(M,tag,geom.node.feature);

  % Create block as our node
  specimen.node=geom.node.feature.create(specimen.tag,'Block');
  specimen.node.label(specimen.tag);
  specimen.node.set('createselection','on');

  % for consistency the parameters should probably be prefixed by tag, but they are not

  specimen.node.set('lx',spclength);
  specimen.node.set('ly',spcwidth);
  specimen.node.set('lz',spcthickness);
	 	    
  % Create top face and bottom face selections (used for meshing, below)
  % These are anonymous functions that can be called later to extract
  % the relevant boundary entities
  addprop(specimen,'gettopfaceselection');
  addprop(specimen,'getbottomfaceselection');
  specimen.gettopfaceselection=@(M,geom,specimen) GetBlockFace(M,geom,specimen, [0 0 1]);
  specimen.getbottomfaceselection=@(M,geom,specimen) GetBlockFace(M,geom,specimen, [0 0 -1]);

  % create domain selection
  specimen.getdomainselection=@(M,geom,specimen) GetDomain(M,geom,specimen);

  % Add property to represent specimen or union of specimen with anything else 
  % -- such as crack, thin contactors, etc. -- that needs to be added later
  addprop(specimen,'specimenunion');
  specimen.specimenunion=specimen;



  % define needed materials
  CreateDCMaterialIfNeeded(M,geom,spcmaterial,'spc');

  % Set Material -- by providing anonymous build function
  specimen.applymaterial=BuildLater(M,[specimen.tag '_applymaterial'],...
				    'applymaterial', ...
				    @(M,obj) ...
				    ReferenceNamedMaterial(M,geom,specimen,strrep(strrep(spcmaterial,' ','_'),'-','_'),specimen.getdomainselection));


  % % Specify mesh -- by providing anonymous build function
  specimen.mesh=BuildLater(M,[specimen.tag '_mesh'],...
			   'meshbuilder', ...
			   @(M,mesh,obj)  ...
			   BuildMeshDCObject(M,geom,mesh,specimen,obj, ...
					'spc', ...  % dcprefix
					specimen.getdomainselection, ...
					[ geom.tag '_', tag, '_edg'], ...
					specimen.gettopfaceselection, ...
					specimen.getbottomfaceselection));


  % Notify User We Are Building Geometry
  LogMsg(sprintf('Created %s Rectangular Bar Specimen', spcmaterial), 1);

  % Extract dimensions for showing to the user
  DimensionString=sprintf('%f x ',specimen.node.getDoubleArray('size'));
  DimensionString=DimensionString(1:(length(DimensionString)-2));
  LogMsg(sprintf('%s',DimensionString),1);


  % Set camera position for view
  % Our rectangular bar specimens are upside-down with COMSOL's default view
  % !!! View now should be set by piping geometry function into AddView() !!!
  %CreateWrappedProperty(M,specimen,'view',[ specimen.tag '_view' ],M.node.view,3);
  %specimen.view.node.label(specimen.view.tag);
  %specimen.view.node.camera().set('zoomanglefull',11.54);
  %specimen.view.node.camera().set('position',{ '-.32[m]','-.5[m]','-.39[m]' });
  %specimen.view.node.camera().set('target',{ '.07[m]','.0127[m]','.006[m]' });
  %specimen.view.node.camera().set('up',{ '.3087','.4116','-.857' });
  %specimen.view.node.camera().set('rotationpoint', {'.07[m]' '.0127[m]' '.006[m]'});




end
