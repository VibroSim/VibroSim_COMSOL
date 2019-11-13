%> [explog] = AddParamToExpLogSummary(explog,paramname)
%> Add a parameter to summary node of the experiment log
%> parameters
%> explog - experiment log structure
%> paramname - name of the parameter to add to the summary
function [explog] = AddParamToExpLogSummary(explog,paramname)

    % Prepare Access to Paramdb
    global paramdb;

    % Make Sure They Are Setting Ouput Argument
    if nargout ~= 1
        error('AddMeasurementToExpLog:ArgumentError', 'AddMeasurementToExpLog Output Must Be Assigned Back To The Experiment Log Struct');
    end

    % Create all the other fields specified by the summarystruct
    docNode = explog.docNode;

    %field = cell2mat(paramname);
    paramstruct = getfield(paramdb,paramname);
    element = docNode.createElement(['dc:' paramname]);
    element_text = docNode.createTextNode(num2str(paramstruct.value));
    if ~isempty(paramstruct.units)
        element.setAttribute('dcv:units',paramstruct.units);
    end
    element.appendChild(element_text);
    explog.summary.node.appendChild(element);

    % Write Experiment Log
    xmlwrite(explog.filename, explog.docNode);

    % Also add to summary struct
    setfield(explog.summary,sprintf('dc_%s',paramname),element_text);

end
