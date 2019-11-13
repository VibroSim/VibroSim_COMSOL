function BuildThinIsolator(M,geom,isolator,specimen,shape,pos,normalvec,angle)

if ~exist('angle','var')
  angle=0;
end


leng=ObtainDCParameter(M,'isolatorlength','m');
width=ObtainDCParameter(M,'isolatorwidth','m');
thickness=ObtainDCParameter(M,'isolatorthickness','m');
matl=GetDCParamStringValue(M,'isolatormaterial');
%CreateDCMaterialIfNeeded(M,geom,'isolator','isolator');
ObtainDCParameter(M,'isolatorYoungsModulus','Pa');

ObtainDCParameter(M,'isolatordashpotcoeff','Pa*s/m');
%% isolatorEta can either be a parameter or frequency dependent variable.
%try
%    ObtainDCParameter(M,'isolatorEta');
%catch
%    % not a parameter, ensure a variable is defined with this name
%    assert(SearchVariable(M.node,'isolatorEta'));
%end



BuildThinContactor(M,geom,isolator,specimen,shape,pos,normalvec,angle,leng,width);




% Provide spring boundary condition for surface representing 
% spring to fixed displacement -- intended for 
% harmonic study -- tagged as 'fixedisolators'

% k_A = spring constant per unit area 
% 
% F = k x
% F/A = k_A x
% sigma = k_A x
% epsilon = x / thickness
% x = epsilon * thickness
% sigma = k_A epsilon * thickness
% E = k_A * thickness
% k_A = E/thickness

% This spring is isotropic
k_A = { 'isolatorYoungsModulus/isolatorthickness', '0.0', '0.0', '0.0', 'isolatorYoungsModulus/isolatorthickness', '0.0', '0.0', '0.0', 'isolatorYoungsModulus/isolatorthickness'};
%eta_k = { 'isolatorEta', '0.0', '0.0', '0.0', 'isolatorEta', '0.0', '0.0', '0.0', 'isolatorEta'};
DampPerArea = {'isolatordashpotcoeff', '0', '0', '0', 'isolatordashpotcoeff', '0', '0', '0', 'isolatordashpotcoeff' };



% WARNING: Spring foundation 'equation view' in harmonic mode 
% says it DOES NOT include effect of eta_k!!!
% In fact, it seems to include the effect of eta_k anyway (output is dependent
% on eta_k

AddBoundaryCondition(M,geom,isolator,[ isolator.tag '_springfndfixed'], ...
		     {'solidmech_harmonicper','solidmech_harmonic','solidmech_modal','solidmech_timedomain'}, ... % physics
		     {'fixedisolators'}, ... % BC classes
		     @(M,physics,bcobj) ...
		     BuildFaceSpringFoundationBC(M,geom,physics,isolator,bcobj,isolator.getcontactfaceselection,k_A,DampPerArea));

