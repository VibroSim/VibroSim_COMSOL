%> function material=CreateDCMaterialIfNeeded(M,geom,materialname,materialprefix)
%> Auto-names tag according to value of materialname
%> Only creates material if it doesn't already exist. Otherwise
%> silently returns existing material
%> materialprefix is used to identify the material DC parameters
%> from the DC database (AddParamToParamDB, etc.):
%> e.g. [ materialprefix 'YoungsModulus' ]
%> if the materialprefix is not given, the material name is used in its
%> place (with spaces and dashes converted to underscores)
function material=CreateDCMaterialIfNeeded(M,geom,materialname,materialprefix)

materialnamenospace=strrep(materialname,' ','_'); % convert spaces to underscore
materialnamenospace=strrep(materialnamenospace,'-','_'); % convert dashes to underscore

if ~exist('materialprefix','var')
  materialprefix=materialnamenospace;
end

if WrappedObjectExists(M,materialnamenospace)
  material = FindWrappedObject(M,materialnamenospace);
else
  material = ModelWrapper(M,materialnamenospace,M.node.material);
  material.node = M.node.material.create(material.tag);

  material.name=materialnamenospace;
  material.node.label(sprintf('%s (%s)',material.name,material.tag));

  try 
    youngsmodulus=ObtainDCParameter(M,[materialprefix 'YoungsModulus'], 'Pa');
    SetMaterialProperty(M,material,'youngsmodulus',youngsmodulus);
  end

  try
    density=ObtainDCParameter(M,[materialprefix 'Density'], 'kg/m^3');
    SetMaterialProperty(M,material,'density',density);
  end

  try
    poissonsratio=ObtainDCParameter(M,[materialprefix 'PoissonsRatio'],'');
    SetMaterialProperty(M,material,'poissonsratio',poissonsratio);
  end

  try 
    yieldstrength=ObtainDCParameter(M,[materialprefix 'YieldStrength'], 'Pa');
    SetMaterialProperty(M,material,'yieldstrength',yieldstrength);
  end

  try
    thermalconductivity=ObtainDCParameter(M,[materialprefix 'ThermalConductivity'], 'W/m/K');
    SetMaterialProperty(M,material,'thermalconductivity',thermalconductivity);
  end

  try
    heatcapacity=ObtainDCParameter(M,[materialprefix 'SpecificHeatCapacity'], 'J/kg/K');
    SetMaterialProperty(M,material,'heatcapacity',heatcapacity);
  end

%try 
%  cijmat=GetDCParamNumericValue(M,[dcprefix 'spcCijMat'], 'Pa');
%  SetMaterialProperty(M,material,'cijmat',cijmat.repr);
%end

  %try
  %  % eta_s is the isotropic structural loss factor (unitless)
  %  eta_s=ObtainDCParameter(M,[materialprefix 'Eta']);
  %  SetMaterialProperty(M,material,'lossfactor',eta_s);
  %end
end
