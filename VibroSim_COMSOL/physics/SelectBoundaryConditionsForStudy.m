%> function SelectBoundaryConditionsForStudy(M,study,classnameorcellarray)
%> Select the boundary conditions for a particular study
%> WARNING: May not be executed until ALL physicses have been created.
%> Usually passed to RunLater() as RunLater(M,'rl_thisstudy_selectbcs','select_boundaryconditions',@(M,rlobj) SelectBoundaryConditionsForStudy(M,study,classnameorcellarray))
%> where 'rl_thisstudy_selectbcs' is a unique tag name
%> Note that this also resets which physicses are turned on in the solver according to the settings in each study step.
function SelectBoundaryConditionsForStudy(M,study,classnameorcellarray)

for stepcnt=1:length(study.steps)
  SelectBoundaryConditionsForStudyStep(M,study,study.steps{stepcnt},classnameorcellarray);

end
