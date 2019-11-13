function [flag] = SearchVariable(model,varname)
% This function searches all the variable nodes and identifies whether a variable exists with the name <varname>

    % initially set flag to false.
    flag = false;

    % First, get all the variable nodes
    varnodes = cell(model.variable.tags);

    % now within each node, search for the expression <varname>
    for varcnt = 1:length(varnodes)
        % mphgetexpressions gives a cell array, the first column of which contains all variable names
        allexprscell = mphgetexpressions(model.variable(cell2mat(varnodes(varcnt))));
        allexprs = allexprscell(:,1); 
        % within the cell array, try to find <varname>
        if any(ismember(allexprs,varname))
            flag = true; % variable exists, stop search!
            break;
        end
    end
end

