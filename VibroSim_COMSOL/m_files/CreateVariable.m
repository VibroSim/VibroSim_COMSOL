function [tag] = CreateVariable(M,tag,value)
%   [tag] = CREATEVARIABLE(M, tag, value) Creates Variable in Given Node With Given Value


    varobj=ModelWrapper(M,tag,M.node.variable);
    varobj.node=M.node.variable.create(tag);

    % Check for Node - Create If Not Exists
    % ifnot(any(ismember(cell(M.node.variable.tags),tag)))

    %    M.node.variable.create(tag);
    %end
    

    % Check for Existing Value
    if any(ismember(cell(varobj.node.varnames),tag))
        error('CreateVariable:VariableExistsException', strcat('Variable Name "', tag, '" Already Exists in Variable Node "', tag,'" - Will Not Overwrite'))
    end

    % Set the Value
    varobj.node.set(tag, value);

end
