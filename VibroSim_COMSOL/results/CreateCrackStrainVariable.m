function varname=CreateCrackStrainVariable(M,tag,cracktag,physicstag)
  crack=FindWrappedObject(M,cracktag);

  % First row of genpoints is origin (center) of crack
  center=crack.genpoints(1,1:3);

  % Semi-major axis is 2nd row of genpoints - 1st row of genpoints 
  cracksemimajor=sub_cellstr_array(crack.genpoints(2,1:3),center);
  % Semi-minor axis is 3rd row of genpoints - 1st row of genpoints 
  cracksemiminor=sub_cellstr_array(crack.genpoints(3,1:3),center);
  
  cracknormal=crossproduct_cellstr_array(cracksemimajor,cracksemiminor);
  

  ['Model.Component.at0(' center{1} ',' center{2} ',' center{3} ',' strainmag ')']
  varname=CreateVariable(M,tag,value);
