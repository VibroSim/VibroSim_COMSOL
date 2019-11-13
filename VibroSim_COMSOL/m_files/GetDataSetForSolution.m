function dsetname = GetDataSetForSolution(model,solution_name)

  tags=to_cellstr_array(model.result.dataset.tags);
  datasettags={};

  % getString(solution) works only for solution type datasets, not for cutpoint or any other datasets
  % so search only among the solution type datasets
  for cnt=1:length(tags)
    if strcmp(model.result.dataset(tags{cnt}).getType,'Solution') 
       datasettags{length(datasettags)+1} = tags{cnt};
    end
  end

  matches={};

  for cnt=1:length(datasettags)
    dsetname=datasettags{cnt};
    dsetsolutionname=model.result.dataset(dsetname).getString('solution');
    if strcmp(dsetsolutionname,solution_name)
       matches{length(matches)+1}=dsetname;
    end
  end

  %if length(matches) > 1
  %  matches
  %  error(sprintf('GetDataSetForSolution(model,''%s''): More than one data set matches solution!',solution_name));
  %elseif length(matches)==0
  %  error(sprintf('GetDataSetForSolution(model,''%s''): No data set matches solution!',solution_name));
  %else 
  % ... Now we always return the first dataset.
  dsetname=matches{1};
  %end
