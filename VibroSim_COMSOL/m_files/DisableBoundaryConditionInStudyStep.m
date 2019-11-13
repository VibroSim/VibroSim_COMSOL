%> PRIVATE: Intended to be called only by SelectBoundaryConditionsForStudyStep()
function todisable = DisableBoundaryConditionInStudyStep(M,study,step,physicstag,bcobj)

  todisable={};

  if ~isa(bcobj.node,'double')
    % if this boundary condition directly has its own COMSOL object
    % ... apply to COMSOL object
    filtertag=[ physicstag '/' bcobj.tag ];

    todisable{length(todisable)+1}=filtertag;
  end

  if isprop(bcobj,'children') & isa(bcobj.children,'cell')
    % recursively disable all children
    for childcnt=1:length(bcobj.children)
      child=bcobj.children{childcnt};

      % Append additional disable strings to todisable
      todisable=[todisable DisableBoundaryConditionInStudyStep(M,study,step,physicstag,child)];
    end
  end
  
