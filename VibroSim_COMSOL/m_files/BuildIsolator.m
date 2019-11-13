function BuildIsolator(M,geom,isolator,shape,pos,normalvec,angle)

if ~exist('angle','var')
  angle=0;
end


leng=ObtainDCParameter(M,'isolatorlength','m');
width=ObtainDCParameter(M,'isolatorwidth','m');
thickness=ObtainDCParameter(M,'isolatorthickness','m');
matl=GetDCParamStringValue(M,'isolatormaterial');
CreateDCMaterialIfNeeded(M,geom,'isolator','isolator');

% These parameters are not needed directly but will be used by 
% BuildMeshDCObject() 

%meshtype=ObtainDCParameter(mode,'isolatormeshtype');
%meshtype=ObtainDCParameter(mode,'isolatorfacemethod);
%meshsize=ObtainDCParameter(mode,'isolatormeshsize','m');
%sweepelements=ObtainDCParameter(mode,'isolatorsweepelements','');

BuildContactor(M,geom,isolator,shape,pos,normalvec,angle,leng,width,thickness);


% Set Material -- by providing anonymous build function
isolator.applymaterial=BuildLater(M,[isolator.tag '_applymaterial'],...
				  'applymaterial', ...
				  @(M,obj) ...
				  ReferenceNamedMaterial(M,geom,isolator,matl.repr,isolator.getdomainselection));


% Specify mesh -- by providing anonymous build function
isolator.mesh=BuildLater(M,[isolator.tag '_mesh'],...
			   'meshbuilder', ...
			   @(M,mesh,obj)  ...
			   BuildMeshDCObject(M,geom,mesh,isolator,obj, ...
					'isolator', ...
					isolator.getdomainselection, ...
					[ geom.tag '_', isolator.tag, '_edg'], ...
					isolator.getcontactfaceselection, ...
					isolator.getfreefaceselection));


% Provide continuity boundary condition with object -- tagged as 'continuities'
AddBoundaryCondition(M,geom,isolator,[ isolator.tag '_continuity'], ...
		     {'solidmech_static','solidmech_harmonicper','solidmech_harmonic','solidmech_modal','solidmech_timedomain','heatflow'}, ... % physicses
		     {'continuities'}, ...  % BC classes
		     @(M,physics,bcobj) ... % Creation parameters
		     BuildFaceContinuityBCs(M,geom,physics,isolator,bcobj, ...
					    isolator.getcontactfaceselection));

% Provide fixed boundary condition for free surface -- intended for 
% harmonic study -- tagged as 'fixedisolators'
AddBoundaryCondition(M,geom,isolator,[ isolator.tag '_freesurffix'], ...
		     {'solidmech_harmonicper','solidmech_harmonic','solidmech_modal','solidmech_timedomain',}, ... % physics
		     {'fixedisolators'}, ... % BC classes
		     @(M,physics,bcobj) ...
		     BuildFaceFixedBC(M,geom,physics,isolator,bcobj,isolator.getfreefaceselection));

