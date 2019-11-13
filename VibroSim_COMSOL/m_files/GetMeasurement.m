%> GETMEASUREMENT get the dimension  of the selcted entity
%>   [measure] = GETMEASUREMENT(model, geomtag,selectionnumber) measures the selectiondimension
function [measure] = GetMeasurement(varargin)

    % Parse Input Values
    p = inputParser;
    p.addRequired('M', @(x) isa(x, 'ModelWrapper'))
    p.addRequired('geom', @(x) isa(x,'ModelWrapper'));
    p.addRequired('selectionnumber', @isnumeric);
    p.addRequired('selectiondimension', @isnumeric);
    p.parse(varargin{:});

    % Parsed Inputs
    M = p.Results.M;
    geom = p.Results.geom;
    selectionnumber = p.Results.selectionnumber;
    selectiondimension = p.Results.selectiondimension;

    %geom.node.measureFinal.selection.named(selectionnumber);
    geom.node.measureFinal.selection.geom(geom.tag,selectiondimension);
    geom.node.measureFinal.selection.set(selectionnumber);
    measure=geom.node.measureFinal.getVolume();

end
