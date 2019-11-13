%> WARNING: Reruns SelectBoundaryConditionsForStudy() on each study!

%> To run studies with custom solution solvers, you must
%> manually activate each solution, rather than just run the study.
%>
%> (If you just run the study, it will auto-create a new solver,
%> which isn't usually what you want)
%>
%> This runs each study by seeking out its solver
%> This ignores the 'getnormals' study

function CreateBlankSolutions(M)

% find all studies
studies=to_cellstr_array(M.node.study.tags);

% find corresponding study objects
studyobjs={};
for studycnt=1:length(studies)
  studyobjs{studycnt}=FindWrappedObject(M,studies{studycnt});
end



% go through each study, in order
for studycnt=1:length(studies)
  if strcmp(studies{studycnt},'getnormals')
    continue
  end

  studyobj=studyobjs{studycnt};

  % for all the steps...  
  studysteptags=to_cellstr_array(studyobj.node.feature.tags);


  % go through each step, in order
  for stepcnt=1:length(studysteptags)

    studysteptag=studysteptags{stepcnt};
    studystep=FindWrappedObject(M,studysteptag);

    % there is a COMSOL 5.0 bug where if you run step.node.activate()
    % it messes with disabledphysics and can unintentionally reenable
    % physicses

    % save disabledphysics
    stepdisabledphysics=studystep.node.getString('disabledphysics');
    

    % for all the physicses for this study step
    for physicsnum=1:length(studystep.physicses)
      physicstag=studystep.physicses{physicsnum}{1}.tag;
      physics=FindWrappedObject(M,physicstag);
      
      % Temporarily prevent this solver from running
      studystep.node.activate(physicstag,false);

    end
    % restore disabledphysics
    studystep.node.set('disabledphysics',stepdisabledphysics);

  end    
end

% Now that all solvers have all physicses 
% turned off, run all studies
RunAllStudies(M.node);

% Now reset all physicses to correct solver settings

% Run all 'select_boundaryconditions' RunLater objects -- should rerun SelectBoundaryConditionsForStudy() on all physicses

ExecuteRunLater(M,'select_boundaryconditions');
