%> Determine the magnitude of the strain across the specified crack
%> in the center of its face (NOTE: Does not work if the crack center is
%> outside the material)
%>
%> *** VERY IMPORTANT!!! *** This will only give a meaningful strain if the
%> specified physics has continuity boundary conditions across the crack face.
%> That means, when creating the physics, you must NOT have set the
%> crackdiscontinuity option
%>
%> Parameters:
%> @param model:               COMSOL model node
%> @param geomtag:             COMSOL tag for the main geometry node (usually
%>                             'Geom'
%> @param cracktag:            Tag for the crack to investigate (usually
%>                             'crack'
%> @param physicstag:          Tag for the physics solved for. Usually
%>                             solidmech_harmonic or solidmech_harmonicper.
%>                             assumes the solution to run is [ physicstag '_solution' ].
%> @param objecttag:           Tag for the physics of the object we are finding
%>                             the vibration of
function [cracknormalstrain_scalefactor,crackshearstrain_scalefactor,cracknormalstrain_scalefactor2,crackshearstrain_scalefactor2,closestfreq] = CalculateDynamicStrainCoeff(model,geomtag,cracktag,physicstag,objecttag,skipassignment)

if ~exist('skipassignment','var')
  % skipassignment defaults to false
  skipassignment=false;
end

% Find target frequency
targetfreq=mphevaluate(model,'simulationeigsaround','Hz');

% Find closest frequenc index
[closestfreq,closestfreqidx] = FindClosestFreq(model,geomtag,physicstag,targetfreq);

% Run Plots
model.result('vibro_dynamicstrain_plot').setIndex('looplevel', to_string(closestfreqidx), 0);
model.result('vibro_dynamicstrain_plot').run
model.result.export('vibro_dynamicstrain_plot_image').run;

% Determine which vibrometers are in use
calcvib=mphevaluate(model,'calcvib');
calcvib2=mphevaluate(model,'calcvib2');

% Calc Strain
%[strainmag]=CrackStrain(model,geomtag,cracktag,physicstag,closestfreqidx);
[normalstrain,shearstrain]=CrackStrain(model,geomtag,cracktag,physicstag,closestfreqidx);

% Check the surface of the specified object for displacement magnitude
surfdisplacement=GetBoundaryDisplacement(model,geomtag,physicstag,objecttag,closestfreqidx);

% Perform Calculations on Each Vibrometer
if calcvib
  displacement=LaserDisplacement(model,geomtag,physicstag,closestfreqidx,1);
  skipassignment1=false;
  if max(surfdisplacement) > 6*abs(displacement)
    LogMsg(sprintf('Vib1 laser too close to a nodal point (laser displacement=%f um,\nantinode displacement=%f um)\n*** NOT ASSIGNING VALID COEFFICIENT ***\n',displacement,max(surfdisplacement)),1);
    skipassignment1=true;
  end

  %crackstrain_scalefactor=abs(strainmag/displacement);
  cracknormalstrain_scalefactor=normalstrain/displacement;
  crackshearstrain_scalefactor=shearstrain/displacement;

  outputinfo = ['============================================================\n'];
  outputinfo = [outputinfo,'                         VIBROMETER 1                       \n'];
  outputinfo = [outputinfo, sprintf('Eigen Frequency Solution #:  %d\n', closestfreqidx)];
  outputinfo = [outputinfo, sprintf('Resonant Frequency:  %f Hz\n', closestfreq)];
  outputinfo = [outputinfo, sprintf('Displacement at laser: %f meters\n', displacement)];
  %outputinfo = [outputinfo, sprintf('Strain at Crack: %f strain\n', strainmag)];
  outputinfo = [outputinfo, sprintf('Normal strain at Crack: %f strain\n', normalstrain)];
  outputinfo = [outputinfo, sprintf('Shear strain at Crack: %f strain\n', shearstrain)];
  %outputinfo = [outputinfo, sprintf('Scale Factor: %f\n', crackstrain_scalefactor)];
  outputinfo = [outputinfo, sprintf('Normal strain scale factor: %f\n', cracknormalstrain_scalefactor)];
  outputinfo = [outputinfo, sprintf('Shear strain scale factor: %f\n', crackshearstrain_scalefactor)];
  %outputinfo = [outputinfo, sprintf('DG Command: ''MATH:DEF DynamicStrain=MUL(VibInt,%s)''\n',crackstrain_scalefactor)];
  outputinfo = [outputinfo, sprintf('DG Command: ''MATH:DEF DynamicNormalStrain=MUL(VibInt,%s)''\n',cracknormalstrain_scalefactor)];
  outputinfo = [outputinfo, sprintf('DG Command: ''MATH:DEF DynamicShearStrain=MUL(VibInt,%s)''\n',crackshearstrain_scalefactor)];
  outputinfo = [outputinfo,'============================================================\n'];
  LogMsg(outputinfo, 1);


  try
    if ~skipassignment && ~skipassignment1
      %dc_requestvalstr('strain_ov_displacement',sprintf('%.12g 1/m',crackstrain_scalefactor));
      dc_requestvalstr('normalstrain_ov_displacement',sprintf('%.12g 1/m',cracknormalstrain_scalefactor));
      dc_requestvalstr('shearstrain_ov_displacement',sprintf('%.12g 1/m',crackshearstrain_scalefactor));
    else
      %dc_requestvalstr('strain_ov_displacement',sprintf('0 1/m',crackstrain_scalefactor));
      dc_requestvalstr('normalstrain_ov_displacement',sprintf('0 1/m'));
      dc_requestvalstr('shearstrain_ov_displacement',sprintf('0 1/m'));
    end
  catch
    LogMsg('Error assigning normalstrain_ov_displacement or shearstrain_ov_displacement DC parameter...\nIs Datacollect running?\n',1); 
  end



end
if calcvib2
  displacement2=LaserDisplacement(model,geomtag,physicstag,closestfreqidx,2);
  skipassignment2=false;
  if max(surfdisplacement) > 6*abs(displacement2)
    LogMsg(sprintf('Vib2 laser too close to a nodal point (laser displacement=%f um,\nantinode displacement=%f um)\n*** NOT ASSIGNING VALID COEFFICIENT ***\n',displacement2,max(surfdisplacement)),1);
    skipassignment2=true;
  end


  %crackstrain_scalefactor2=abs(strainmag/displacement2);
  cracknormalstrain_scalefactor2=normalstrain/displacement2;
  crackshearstrain_scalefactor2=shearstrain/displacement2;

  outputinfo = ['============================================================\n'];
  outputinfo = [outputinfo,'                         VIBROMETER 2                       \n'];
  outputinfo = [outputinfo, sprintf('Eigen Frequency Solution #:  %d\n', closestfreqidx)];
  outputinfo = [outputinfo, sprintf('Resonant Frequency:  %f Hz\n', closestfreq)];
  outputinfo = [outputinfo, sprintf('Displacement at laser: %f meters\n', displacement2)];
  outputinfo = [outputinfo, sprintf('Normal strain at Crack: %f strain\n', normalstrain)];
  outputinfo = [outputinfo, sprintf('Shear strain at Crack: %f strain\n', shearstrain)];
  %outputinfo = [outputinfo, sprintf('Scale Factor: %f\n', crackstrain_scalefactor2)];
  outputinfo = [outputinfo, sprintf('Normal strain scale factor: %f\n', cracknormalstrain_scalefactor2)];
  outputinfo = [outputinfo, sprintf('Shear strain scale factor: %f\n', crackshearstrain_scalefactor2)];
  %outputinfo = [outputinfo, sprintf('DG Command: ''MATH:DEF DynamicStrain=MUL(Vib2Int,%s)''\n',crackstrain_scalefactor2)];
  outputinfo = [outputinfo, sprintf('DG Command: ''MATH:DEF DynamicNormalStrain2=MUL(Vib2Int,%s)''\n',cracknormalstrain_scalefactor2)];
  outputinfo = [outputinfo, sprintf('DG Command: ''MATH:DEF DynamicShearStrain2=MUL(Vib2Int,%s)''\n',crackshearstrain_scalefactor2)];
  outputinfo = [outputinfo,'============================================================\n'];
  LogMsg(outputinfo, 1);


  try
    if ~skipassignment && ~skipassignment2
      %dc_requestvalstr('strain_ov_displacement2',sprintf('%.12g 1/m',crackstrain_scalefactor2));
      dc_requestvalstr('normalstrain_ov_displacement2',sprintf('%.12g 1/m',cracknormalstrain_scalefactor2));
      dc_requestvalstr('shearstrain_ov_displacement2',sprintf('%.12g 1/m',crackshearstrain_scalefactor2));
    else
      %dc_requestvalstr('strain_ov_displacement2',sprintf('0 1/m',crackstrain_scalefactor2));
      dc_requestvalstr('normalstrain_ov_displacement2',sprintf('0 1/m'));
      dc_requestvalstr('shearstrain_ov_displacement2',sprintf('0 1/m'));
    end
  catch
    LogMsg('Error assigning normalstrain_ov_displacement2 or shearstrain_ov_displacement2 DC parameter...\nIs Datacollect running?\n',1); 
  end

end


