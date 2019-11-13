%> CREATECUTPLANE Creates a Cut Plane Using the Provided Parameters
%>   [cutplane] = CREATECUTPLANE(model, cutplane, tagname) Creates a Cut Plane

function [cutplane] = CreateCutPlane(varargin)

    % Parse Input Values
    p = inputParser;
    p.addRequired('model', @(x) isa(x, 'com.comsol.model.impl.ModelImpl'))
    p.addRequired('cutplane', @isstruct);
    p.parse(varargin{:});

    % Parsed Inputs
    model = p.Results.model;
    cutplane = p.Results.cutplane;

    % Validate Tag Name
    if isfield(cutplane, 'tag')
        cutplane.tag = ValidateUniqueTag(getfield(cutplane, 'tag'), model.result.dataset.tags);
    else
        cutplane.tag = ValidateUniqueTag('cp', model.result.dataset.tags);
    end

    % Create Cut Plane
    cutplane.node = model.result.dataset.create(cutplane.tag, 'CutPlane');

    % Look at cutplane type
    if strcmp(cutplane.type, 'quickplane')
    	coords='xyz';
    	cutplane.quickplaneaxis = coords(~ismember(coords,lower(cutplane.quickeqn)));
    	cutplane.quickplanename = ['quick', cutplane.quickplaneaxis];
    	cutplane.node.set('quickplane', cutplane.quickeqn);
    	cutplane.node.set(cutplane.quickplanename, cutplane.quickplaneoffset);
    elseif strcmp(cutplane.type, 'general')
    	cutplane.node.set('planetype', 'general');
    	cutplane.node.set('genmethod', 'threepoint');
    	for i=1:3
    		for j=1:3
    			cutplane.node.setIndex('genpoints', sprintf('%g', cutplane.coords(i,j)), i-1, j-1);
    		end
    	end
   	else
   		 error('CreateCutPlane:InvalidTypeException', strcat('Cut Plane Type "', cutplane.type, '" Not Valid'))
    end

    % Run
    cutplane.node.run;
    

end
