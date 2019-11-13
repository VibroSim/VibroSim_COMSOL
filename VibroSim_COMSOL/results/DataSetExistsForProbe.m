function exists=DataSetExistsForProbe(model,probe_name)

  tags=to_cellstr_array(model.result.dataset.tags);
  datasettags={};

  % getString('probetag') works only for CutPoint datasets, not for solution or any other datasets
  % so search only among the CutPoint type datasets
  for cnt=1:length(tags)
    if model.result.dataset(tags{cnt}).getType().startsWith('CutPoint')
       datasettags{length(datasettags)+1} = tags{cnt};
    end
  end

  matches={};


  for cnt=1:length(datasettags)
    dsetname=datasettags{cnt};
    dsetsolutionname=model.result.dataset(dsetname).getString('solution');
    
    dsetprobename=model.result.dataset(dsetname).getString('probetag');
    if strcmp(dsetprobename,probe_name)
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
