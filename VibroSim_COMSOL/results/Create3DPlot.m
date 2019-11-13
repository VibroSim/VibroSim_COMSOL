%> CREATE3DPLOT Adds a Plot to a Plot Group
%>   [tag] = CREATE3DPLOT(model, grouptag, plottype, varargin) Creates Plot of Given Type
function [tag] = Create3DPlot(varargin)


    % Possible Input Values
    plottypes = {'Surface', 'Isosurface', 'ArrowVolume'};

    % Parse Input Values
    p = inputParser;
    p.addRequired('model', @(x) isa(x, 'com.comsol.model.impl.ModelImpl'))
    p.addRequired('grouptag', @isstr);
    p.addRequired('plottype', @(x) any(validatestring(x,plottypes)));
    % Parameters from Below
    p.addParamValue('expr', 'Undefined');
    p.addParamValue('colortable', 'Undefined');
    p.addParamValue('number', 'Undefined');
    p.addParamValue('color', 'Undefined');
    p.addParamValue('arrowlength', 'Undefined');
    p.parse(varargin{:});

    % Parsed Inputs
    model = p.Results.model;
    grouptag = p.Results.grouptag;
    plottype = p.Results.plottype;

    % Validate Tags
    if not(any(ismember(cell(model.result.tags),grouptag)))
        error('Create3DPlot:COMSOLEntityTagException', strcat('Plot Group Tag "', grouptag, '" Cannot Be Found'))
    end

    switch plottype
        case 'Surface'
            expr = p.Results.expr;
            colortable = p.Results.colortable;
            tag = ValidateUniqueTag('surf', model.result(grouptag).feature.tags);
            node = model.result(grouptag).feature.create(tag, 'Surface');
            if ~isstr(expr) || ~strcmp('Undefined', expr)
                node.set('expr', expr);
                node.set('descr', expr);
            end
            if ~isstr(colortable) || ~strcmp('Undefined', colortable)
                node.set('colortable', colortable);
            end
        case 'Isosurface'
            number = p.Results.number;
            colortable = p.Results.colortable;
            tag = ValidateUniqueTag('iso', model.result(grouptag).feature.tags);
            node = model.result(grouptag).feature.create(tag, 'Isosurface');
            if ~isstr(colortable) || ~strcmp('Undefined', colortable)
                node.set('colortable', colortable);
            end
            if ~isstr(number) || ~strcmp('Undefined', number)
                node.set('number', number);
            end
        case 'ArrowVolume'
            color = p.Results.color;
            arrowlength = p.Results.arrowlength;
            tag = ValidateUniqueTag('arwv', model.result(grouptag).feature.tags);
            node = model.result(grouptag).feature.create(tag, 'ArrowVolume');
            if ~isstr(color) || ~strcmp('Undefined', color)
                node.set('color', color);
            end
            if ~isstr(arrowlength) || ~strcmp('Undefined', arrowlength)
                node.set('arrowlength', arrowlength);
            end
        otherwise
            error('Create3DPlot:PlotTypeException', strcat('Plot Type "', plottype, '" Not Implemented'))
    end

end
