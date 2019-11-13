function exists=DataSetExistsForSolution(model,solution_name)

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
      % Check a little more aggressively... sometimes the data set exists even
      % though it hasn't been calculated...

      %% See if we can read the solinfo without an error
      %errflag=false;
      %try
      %  mphsolinfo(model,'Soltag',solution_name);
      %catch
      %  errflag=true;
      %end
      %if ~errflag
	% The .values attribute of the solutioninfo struct seems to usually
	% get some content when a real solution is run...
      matches{length(matches)+1}=dsetname;
      %end
    end
  end

  if length(matches) >= 1
    exists=true;
  else
    exists=false;
  end
