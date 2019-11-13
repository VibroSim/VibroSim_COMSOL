%> CREATEWORKPLANE Creates a Work Plane With Given Parameters
%>   [node] = CREATEWORKPLANE(model, geomtag, properties) Creates Work Plane With Given Properties
function [workplane] = CreateWorkPlane(varargin)

    % Parse Input Values
    p = inputParser;
    p.addRequired('model', @(x) isa(x, 'com.comsol.model.impl.ModelImpl'))
    p.addRequired('geomtag', @isstr);
    p.addRequired('properties', @isstruct);
    p.parse(varargin{:});

    % Parsed Inputs
    model = p.Results.model;
    geomtag = p.Results.geomtag;
    workplane = p.Results.properties;

    % Validate Tags
    if not(any(ismember(cell(model.geom.tags),geomtag)))
        error('CreateWorkPlane:COMSOLEntityTagException', strcat('Geometry Tag "', geomtag, '" Cannot Be Found'))
    end

    geom = model.geom(geomtag);
    
    if isfield(workplane, 'tag')
        workplane.tag = ValidateUniqueTag(getfield(workplane, 'tag'), geom.feature.tags);
    else
        workplane.tag = ValidateUniqueTag('WorkPlane', geom.feature.tags);
    end

    % Create the Work Plane 
    node = geom.feature.create(workplane.tag, 'WorkPlane');

    % Turn on Create Selections
    workplane.props.createselection = 'on';

    % Loop and Set Properties
    for prop = fields(workplane.props)'
        node.set(cell2mat(prop), getfield(workplane.props, cell2mat(prop)));
    end 

    % Build Block
    geom.run();

    % Prepare Output
    workplane.node = node;
    workplane.vertices = struct();

    % Get Explicit Selecitons
    workplane.vertices.edge = @(model)mphgetselection(model.selection(strcat(geomtag, '_', workplane.tag, '_edg')));
    workplane.vertices.point = @(model)mphgetselection(model.selection(strcat(geomtag, '_', workplane.tag, '_pnt')));
    workplane.vertices.boundary = @(model)mphgetselection(model.selection(strcat(geomtag, '_', workplane.tag, '_bnd')));
    
end
