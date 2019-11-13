%> Select the boundary conditions for a particular study step
%> WARNING: May not be executed until ALL physicses have been created.
%> Usually passed to RunLater() as RunLater(M,'rl_thisstudystep_selectbcs','select_boundaryconditions',@(M,rlobj) SelectBoundaryConditionsForStudyStep(M,study,step,classnameorcellarray))
%> where 'rl_thisstudystep_selectbcs' is a unique tag name
%> Note that this also resets which physicses are turned on in the solver according to the settings in each study step.

function SelectBoundaryConditionsForStudyStep(M,study,step,classnameorcellarray)

% Convert classnameorcellarray parameter into cell array classnames
if isa(classnameorcellarray,'string')
  classnames={};
  classnames(1)=classnameorcellarray;
else
  classnames=classnameorcellarray;
end

% Cell array of 'physicsobjtag/boundaryconditiontag' to disable
todisable={};

% for all the physicses for this study step
for physicsnum=1:length(step.physicses)
  physicstag=step.physicses{physicsnum}{1}.tag;

  % activate physics according to active flag
  
  % .physicses{:}{1} is a list of all physicses which have status
  % 'Solve for' or 'Disable in Solvers' when 
  % right-clicking the in the advanced physics selection tree  
  % The choice of 'Solve for' or 'disable in solvers'
  % is determined by the booleans .physicses{:}{2}

  % Choose whether we should solve for this physics.
  % (enable in solver... or not!)
  step.node.activate(physicstag,step.physicses{physicsnum}{2});

  % all initially created boundary condition objects are class BuildLater
  % and have buildlaterclass equal to 'bctemplate_' with 
  % physics class appended, and with a tagname with a [ '_' physicsclass '_bct' ] suffix.
  %
  % In BuildBoundaryCondition() these are instantiated 
  % with the original tag prefix and a [ '_' physicstag ] suffix
  % and a buildlaterclass of [ 'bcinstance_' physicstag ]
  % 
  % Note that some of these objects are in fact empty -- and the boundary
  % conditions are in their children, instead. So we have to be careful 
  % to deal with that properly

  BCObjects=FindBuildLater(M,[ 'bcinstance_' physicstag ],true);
  
  for bccnt=1:length(BCObjects)
    bcobj=BCObjects{bccnt};
    bcclassnames=bcobj.classnames;

    % if ANY element in bcclassnames matches ANY element in classnames
    % then we DO NOT filter this boundary condition. 

    % OTHERWISE we filter this boundary condition
    commonclasses=intersect(classnames,bcclassnames);
    
    if length(commonclasses)==0
      % No matching class names... add to filter list
      todisable=[ todisable  DisableBoundaryConditionInStudyStep(M,study,step,physicstag,bcobj) ];
      
    end

  end
end

% Disable all physics modules not listed under step.physicses
%  (no slashes)

allphysicstags=to_cellstr_array(M.node.physics.tags);

for cnt=1:length(allphysicstags)
  foundit=false;
  for cnt2=1:length(step.physicses)
    if strcmp(allphysicstags{cnt},step.physicses{cnt2}{1}.tag);
      foundit=true;
      break;
    end
  end
  if ~foundit 

    % disable in solvers
    step.node.activate(allphysicstags{cnt},false);

    % disable in model
    todisable{length(todisable)+1}=allphysicstags{cnt};
  end
end


% Actually perform the disabling in the model
%for cnt=1:length(todisable)
%  fprintf(1,'todisable{%d}=%s\n',cnt,todisable{cnt});
%end
%todisable
step.node.set('disabledphysics',todisable);
