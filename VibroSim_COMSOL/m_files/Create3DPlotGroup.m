%> CREATE3DPLOTGROUP Creates a 3D Plot Group
%>   [grouptag] = CREATE3DPLOTGROUP(model, grouptag) Creates Node of Given Type

function [grouptag] = Create3DPlotGroup(varargin)

    % Parse Input Values
    p = inputParser;
    p.addRequired('model', @(x) isa(x, 'com.comsol.model.impl.ModelImpl'))
    p.addOptional('grouptag', 'pg', @isstr);
    p.parse(varargin{:});

    % Parsed Inputs
    model = p.Results.model;
    grouptag = p.Results.grouptag;

    %Validate Tag
    grouptag = ValidateUniqueTag(grouptag, model.result.tags);

    % Create the Node   
    model.result.create(grouptag, 'PlotGroup3D');


end
