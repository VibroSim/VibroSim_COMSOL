%> To run studies with custom solution solvers, you must
%> manually activate each solution, rather than just run the study.
%>
%> (If you just run the study, it will auto-create a new solver,
%> which isn't usually what you want)
%>
%> This runs each study by seeking out its solver
%> This ignores the 'getnormals' study
%>
%> studyfilter is a cell array of study names to ignore. 

function RunAllStudies(model,studyfilter)

if ~exist('studyfilter','var')
  studyfilter={};
end

% find all studies
studies=to_cellstr_array(model.study.tags);

% find all solutions
solutions=to_cellstr_array(model.sol.tags);

% go through each study, in order
for studycnt=1:length(studies)
  if strcmp(studies{studycnt},'getnormals')
    continue
  end

  study=model.study(studies{studycnt});

  filter_this_study=false;
  for filtercnt=1:length(studyfilter)
    if strcmp(studies{studycnt},studyfilter{filtercnt})
      filter_this_study=true;
    end
  end

  if filter_this_study 
    continue;
  end  

  studysteps=to_cellstr_array(study.feature.tags);
  
  % go through each step, in order
  for stepcnt=1:length(studysteps)
    studysteptag=studysteps{stepcnt};
    studystep=study.feature(studysteptag);
    solutionmatches=false;
    
    % Search for a solution referring to this step
    for solutioncnt=1:length(solutions)
      %solutions{solutioncnt}
      solution=model.sol(solutions{solutioncnt});
      
      % search for a solution feature of type ___ referring to this step
      solutionfeatures=to_cellstr_array(solution.feature.tags);
      for solutionfeaturecnt=1:length(solutionfeatures)
	solutionfeature=solution.feature(solutionfeatures{solutionfeaturecnt});
	if strcmp(solutionfeature.getType(),'StudyStep')
	  % studysteptag
	  %solutionfeature.getString('studystep')
	  if strcmp(solutionfeature.getString('studystep'),studysteptag)
	    % Found a solution for this step
	    solutionmatches=true;
	    break
          end
	end
      end

      if solutionmatches
        solution.runAll();
        break;  % don't try anything more for this step
      end
    
    end
   
    if ~solutionmatches
      % no solution found; just run the step
      studystep.runAll();
    end
  end
end
