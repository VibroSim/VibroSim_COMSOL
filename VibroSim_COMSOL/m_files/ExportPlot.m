%> EXPORTPLOT Exports Plot
%>   [export] = EXPORTPLOT(model, export) Exports data with the given properties
%>  exportproperties is a structure with the following fields
function [export] = ExportPlot(varargin)

    % Parse Input Values
    p = inputParser;
    p.addRequired('model', @(x) isa(x, 'com.comsol.model.impl.ModelImpl'))
    p.addRequired('exporttag', @isstr);
    p.addRequired('exportproperties', @isstruct);
    p.parse(varargin{:});

    % Parsed Inputs
    model = p.Results.model;
    exporttag = p.Results.exporttag;
    exportproperties = p.Results.exportproperties;

    % Validate Tag Name
    exporttag = ValidateUniqueTag(exporttag, model.result.export.tags);
    model.result.export.create(exporttag, 'Plot');

    %

    % Set Options
    %export.node.set('data', export.dataset);
    %export.node.set('expr', export.datafields);
    %export.node.set('struct', 'sectionwise');
    %export.node.set('filename', export.filename);

    % Run
    %LogMsg(sprintf('Saving %s...', export.filename), 1);
    %export.node.run;    

end
