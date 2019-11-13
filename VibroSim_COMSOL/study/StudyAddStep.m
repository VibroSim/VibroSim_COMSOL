%> function step = StudyAddStep(M,geom,study,tag,type,physics1, physics2, ...)
%> Add a step of the specified type to the given study. Also enable
%> the specified physics objects within that study.
%> type could be 'Frequency' or other COMSOL-supported study type
function step = StudyAddStep(M,geom,study,tag,type,varargin)


  % Create step
  step=ModelWrapper(M,tag,study.node.feature);
  step.node=study.node.create(step.tag,type);
  step.node.label(step.tag);

  % Add new step to step list
  study.steps{length(study.steps)+1}=step; 

  % % This code is for non-advanced disable
  % % Activate each physics object provided
  % for cnt=1:length(varargin)
  %   step.node.activate(varargin{cnt}.tag,true);
  % end

  % % de-activate each physics object notprovided
  % physicstags=M.node.physics.tags;
  % for cnt=1:length(physicstags)
  %   foundit=false;
  %   for cnt2=1:length(varargin)
  %     if strcmp(physicstags(cnt),varargin{cnt2}.tag)
  %       foundit=true;
  %       break;
  %     end
  %   end
  %   if ~foundit 
  %     step.node.activate(physicstags(cnt),false);
  %   end
  % end


  step.node.set('useadvanceddisable','on');

  % Store list of physics tags to use for this step

  addprop(step,'physicses');
  % .physicses property is a cell array listing all enabled
  % of { physicsobj, active }
  % where active is a boolean as to whether the enabled
  % physics are active in the solvers (all default to true). 

  % .physicses is a list of all physicses which have status
  % 'Solve for' or 'Disable in Solvers' when 
  % right-clicking the in the advanced physics selection tree  
  % the 'true' stored here is the default status of 'Solve for'
  step.physicses={};
  for cnt=1:length(varargin)
    step.physicses{cnt}={ varargin{cnt}, true };
  end

  % step.node.set('disabledphysics',todisable);
  
