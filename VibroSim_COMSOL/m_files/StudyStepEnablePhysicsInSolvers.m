function StudyStepEnablePhysicsInSolvers(M,step,physics,enabled)

% Find physics in step.physicses

foundit=false;
for cnt=1:length(step.physicses)
  if strcmp(step.physicses{cnt}{1}.tag,physics.tag)
    step.physicses{cnt}{2}=enabled;
    
    % perform activation/deactivation
    step.node.activate(step.physicses{cnt}{1}.tag,step.physicses{cnt}{2});
    foundit=true;
  end
end

if ~foundit
  error(sprintf('StudyStepEnablePhysicsInSolvers(): Physics %s not found in step %s',physics.tag,step.tag));
end
