function BuildThinCouplant(M,geom,couplant,specimen,shape,pos,normalvec,angle)


if ~exist('angle','var')
  angle=0;
end


leng=ObtainDCParameter(M,'couplantlength','m');
width=ObtainDCParameter(M,'couplantwidth','m');
thickness=ObtainDCParameter(M,'couplantthickness','m');
matl=GetDCParamStringValue(M,'couplantmaterial');

%CreateDCMaterialIfNeeded(M,geom,'couplant','couplant');
ObtainDCParameter(M,'couplantYoungsModulus','Pa');

ObtainDCParameter(M,'couplantdashpotcoeff','Pa*s/m');
%% couplantEta can either be a parameter or frequency dependent variable.
%try
%    ObtainDCParameter(M,'couplantEta');
%catch
%    % not a parameter, ensure a variable is defined with this name
%    assert(SearchVariable(M.node,'couplantEta'));
%end


BuildThinContactor(M,geom,couplant,specimen,shape,pos,normalvec,angle,leng,width);


% Note! spectrum from xducercalib is really in m/Hz. To get 
% meaningful displacement from this, need to integrate over 
% frequency bandwidth 




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
		     BuildFaceDirectionalElasticDisplacementBC(M,geom,physics,couplant,bcobj,...
							       couplant.getfreefaceselection, ...
							       normalvec,'xducerdisplacement', ...
							       normalvec,0.0, ...
							       'couplantYoungsModulus/couplantthickness','couplantdashpotcoeff'));

AddBoundaryCondition(M,geom,couplant,[ couplant.tag '_hperexc'],...
		     {'solidmech_harmonicper'}, ...
		     {'excitation'}, ...
		     @(M,physics,bcobj) ...
		     BuildFaceDirectionalElasticDisplacementBC(M,geom,physics,couplant,bcobj,...
							       couplant.getfreefaceselection, ...
							       normalvec,0.0, ...
							       normalvec,'xducerdisplacement', ...
							       'couplantYoungsModulus/couplantthickness','couplantdashpotcoeff'));


AddBoundaryCondition(M,geom,couplant,[ couplant.tag '_modalexc'],...
		     {'solidmech_modal'}, ...
		     {'fixedexcitation'}, ...
		     @(M,physics,bcobj) ...
		     BuildFaceDirectionalElasticDisplacementBC(M,geom,physics,couplant,bcobj,...
							       couplant.getfreefaceselection, ...
							       normalvec,0.0, ...
							       normalvec,0.0, ...
							       'couplantYoungsModulus/couplantthickness','couplantdashpotcoeff'));



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



