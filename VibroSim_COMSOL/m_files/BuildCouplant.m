function BuildCouplant(M,geom,couplant,shape,pos,normalvec,angle)


if ~exist('angle','var')
  angle=0;
end


leng=ObtainDCParameter(M,'couplantlength','m');
width=ObtainDCParameter(M,'couplantwidth','m');
thickness=ObtainDCParameter(M,'couplantthickness','m');
matl=GetDCParamStringValue(M,'couplantmaterial');

CreateDCMaterialIfNeeded(M,geom,'couplant','couplant');


BuildContactor(M,geom,couplant,shape,pos,normalvec,angle,leng,width,thickness);


% Note! spectrum from xducercalib is really in m/Hz. To get 
% meaningful displacement from this, need to integrate over 
% frequency bandwidth 



% These parameters are not needed directly but will be used by 
% BuildMeshDCObject() 

%meshtype=ObtainDCParameter(mode,'couplantmeshtype');
%meshtype=ObtainDCParameter(mode,'couplantfacemethod);
%meshsize=ObtainDCParameter(mode,'couplantmeshsize','m');
%sweepelements=ObtainDCParameter(mode,'couplantsweepelements','');


% Set Material -- by providing anonymous build function

couplant.applymaterial=BuildLater(M,[couplant.tag '_applymaterial'],...
			     'applymaterial', ...
			     @(M,obj) ...
			     ReferenceNamedMaterial(M,geom,couplant,matl.repr,couplant.getdomainselection));

% Specify mesh -- by providing anonymous build function
couplant.mesh=BuildLater(M,[couplant.tag '_mesh'],...
			 'meshbuilder', ...
			 @(M,mesh,obj)  ... 
			  BuildMeshDCObject(M,geom,mesh,couplant,obj, ...
				       'couplant', ...   % dcprefix 
				       couplant.getdomainselection, ...         % getdomainselection function
				       [ geom.tag '_', couplant.tag, '_edg'],...% edge selection (not used)
				       couplant.getcontactfaceselection, ...    % getcontactfaceselection func
				       couplant.getfreefaceselection));         % getfreefaceselection func


% Provide continuity boundary condition with object -- tagged as 'continuities'
AddBoundaryCondition(M,geom,couplant,[ couplant.tag '_continuity'], ...
		     {'solidmech_static','solidmech_harmonicper', 'solidmech_harmonic', 'solidmech_modal', 'solidmech_timedomain', 'heatflow'}, ...   % physicses
		     {'continuities'}, ...                            % boundary condition classes
		     @(M,physics,bcobj) ... % BC params to be provided on creation
		     BuildFaceContinuityBCs(M,geom,physics,couplant,bcobj, ...
					     couplant.getcontactfaceselection));

% Provide boundary conditions for free surface -- intended for 
% harmonic and harmonic perturbation studies -- tagged as 'excitation'
% Also create one that will work for modal analysis -- tagged as 'fixedexcitation'
% representing the exciter as a zero normal displacement boundary condtion

% We need to do this separately for the harmonicper and harmonic physicses
% because BuildFaceDirectionalDisplacementBC has separate places to specify the
% regular and harmonic perturbation amplitudes. 
AddBoundaryCondition(M,geom,couplant,[ couplant.tag '_harmonicexc'],...
		     {'solidmech_harmonic'}, ...
		     {'excitation'}, ...
		     @(M,physics,bcobj) ...
		     BuildFaceDirectionalDisplacementBC(M,geom,physics,couplant,bcobj,...
							 couplant.getfreefaceselection, ...
							 normalvec,'xducerdisplacement'));

AddBoundaryCondition(M,geom,couplant,[ couplant.tag '_hperexc'],...
		     {'solidmech_harmonicper'}, ...
		     {'excitation'}, ...
		     @(M,physics,bcobj) ...
		     BuildFaceDirectionalDisplacementBC(M,geom,physics,couplant,bcobj,...
							 couplant.getfreefaceselection, ...
							 normalvec,0.0, ...
							 normalvec,'xducerdisplacement'));


AddBoundaryCondition(M,geom,couplant,[ couplant.tag '_modalexc'],...
		     {'solidmech_modal'}, ...
		     {'fixedexcitation'}, ...
		     @(M,physics,bcobj) ...
		     BuildFaceDirectionalDisplacementBC(M,geom,physics,couplant,bcobj,...
							 couplant.getfreefaceselection, ...
							 normalvec,0.0));


impulseforcevec = negate_cellstr_array(to_cellstr_array(normalvec)); % Negate because welder impact is in the inward direction
for idx=1:3
  impulseforcevec{idx}=sprintf('(%s)*(1[N*s])*impulse_excitation(t)',impulseforcevec{idx});
end

AddBoundaryCondition(M,geom,couplant,[ couplant.tag '_impulseexc'],...
		     {'solidmech_timedomain'}, ...
		     {'impulseforceexcitation'}, ...
		     @(M,physics,bcobj) ...
		     BuildFaceTotalForceBC(M,geom,physics,couplant,bcobj,...
							 couplant.getfreefaceselection, ...
							 impulseforcevec));


