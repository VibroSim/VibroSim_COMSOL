function exists=DerivedValueExistsForProbeExpr(model,probe_name,probeexpr_name)

  tags=to_cellstr_array(model.result.numerical.tags);
  numericaltags={};

  % getString('probetag') is known to work for EvalPoint derived values, not necessarily other derived values
  % so search only among the EvalPoint type values
  for cnt=1:length(tags)
    if model.result.numerical(tags{cnt}).getType().startsWith('EvalPoint')
      numericaltags{length(numericaltags)+1} = tags{cnt};
    end
  end

  matches={};


  for cnt=1:length(numericaltags)
    numericalname=numericaltags{cnt};
    %dsetsolutionname=model.result.dataset(dsetname).getString('solution');
    
    numericalprobepath=char(model.result.numerical(numericalname).getString('probetag'));
    % numericalprobepath is "probename/probeexpr_name"
    % ... find position of slash
    slashpos=find(numericalprobepath=='/');
    numericalprobename=numericalprobepath(1:(slashpos-1));
    numericalprobeexpr_name=numericalprobepath((slashpos+1):size(numericalprobepath,2));

    
    if strcmp(numericalprobename,probe_name) && strcmp(numericalprobeexpr_name,probeexpr_name)
      matches{length(matches)+1}=numericalname;
    end
  end
  
  if length(matches) >= 1
    exists=true;
  else
    exists=false;
  end
