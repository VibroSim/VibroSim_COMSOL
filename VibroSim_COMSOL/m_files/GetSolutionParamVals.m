%> [solutionparamvals] = GetSolutionParamVals(model,solution_name)
%> get the values of time or frequeny parameters at which simulation is run
%> parameters
%> ---------
%> model - model object
%> solution_name - tag name of the desired solution
function[solutionparamvals] = GetSolutionParamVals(model,solution_name)

    solutioninfo = mphsolutioninfo(model);
    solutionstruct = getfield(solutioninfo,solution_name);
    solutionparamvals = cell2mat(solutionstruct.values);
end
