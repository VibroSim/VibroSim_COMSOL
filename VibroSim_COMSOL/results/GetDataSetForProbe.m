function dsetname = GetDataSetForProbe(model,probe_name)

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
    dsetprobename=model.result.dataset(dsetname).getString('probetag');
    if strcmp(dsetprobename,probe_name)
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
