%> CREATECUTPOINT3D Creates a Cut Plane Using the Provided Parameters
%>   [cutpointnode] = CREATECUTPOINT3D(model, cutpoint) Creates a Cut Plane
function [cutpointtag,cutpointnode] = CreateCutPoint3D(varargin)


    % Parse Input Values
    p = inputParser;
    p.addRequired('model', @(x) isa(x, 'com.comsol.model.impl.ModelImpl'));
    p.addRequired('cutpointtag', @isstr);
    p.addRequired('cutpointproperties', @isstruct);
    p.parse(varargin{:});

    % Parsed Inputs
    model = p.Results.model;
    cutpointtag=p.Results.cutpointtag;
    cutpointproperties = p.Results.cutpointproperties;

    % Validate Tag Name
    cutpointtag = ValidateUniqueTag(cutpointtag,model.result.dataset.tags);

    % Create Cut point
    cutpointnode = model.result.dataset.create(cutpointtag, 'CutPoint3D');


    % Create other properties for the cut point node
    % 
    %   data - tag of the dataset
    %   pointx - x coordinate of cut point
    %   pointy - y coordinate of cut point
    %   pointz - z coordinate of cut point
    for prop = fields(cutpointproperties)'
        cutpointnode.set(cell2mat(prop), getfield(cutpointproperties, cell2mat(prop)));
    end 


    % Run
    cutpointnode.run;
    
end
