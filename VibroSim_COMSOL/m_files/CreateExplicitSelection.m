function explicitselection = CreateExplicitSelection(varargin)
% CREATEEXPLICITSELECTION Creates an Explicit Selection
%   [tag] = CREATEEXPLICITSELECTION(model, tag, type, entities) Creates Explicit Selection of Given Type with Given Entities

    % Possible Input Values
    typeoptions = {'domain', 'boundary', 'edge', 'point'};

    % Parse Input Values
    p = inputParser;
    p.addRequired('model', @(x) isa(x, 'ModelWrapper'))
    p.addRequired('tag', @isstr);
    p.addRequired('type', @(x) any(validatestring(x,typeoptions)));
    p.addRequired('entities');
    p.parse(varargin{:});

    % Parsed Inputs
    model = p.Results.model;
    tag = p.Results.tag;
    seltype = p.Results.type;
    entities = p.Results.entities;


    explicitselection=ModelWrapper(M,tag,model.node.selection);

    % Create Selection
    explicitselection.node=model.node.selection.create(tag, 'Explicit');
    
    % Set Type
    if strcmp(seltype, 'domain')
        explicitselection.node.geom(3);
    elseif strcmp(seltype, 'boundary')
        explicitselection.node.geom(2);
    elseif strcmp(seltype, 'edge')
        explicitselection.node.geom(1);
    elseif strcmp(seltype, 'point')
        explicitselection.node.geom(0);
    else
        error('CreateExplicitSelection:InvalidTypeException', 'Unable to Recognize "type" parameter');
    end

    % Set Entities
    explicitselection.node.set(entities);
    
    % Set Name for Easy Identification
    explicitselection.node.name(tag);

end
