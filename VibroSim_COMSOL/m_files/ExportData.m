%> EXPORTDATA Exports Data
%>   [export] = EXPORTDATA(model, exporttag,exporttype,exportproperties) Exports data with the given properties
%> Required parameters:
%> -------------------
%>
%>    model - (obj) comsol model object
%>    exporttag - (str) name tag of export object;
%>    exportype - (str) type of export, allowed values are: 'Data', 'Plot','Table','Mesh','Image1D'
%>    exportproperties - (struct) export properties
%>
%>    Export Properties
%>    -------------------
%>    header - (string) whether or not to incude header, allowed values: 'on','off'
%>
%>    data - (str) name tag of data set to export
%>    plotgroup - (str) name tag of plotgroup to export
%>    table - (str) name tag of table to export
%>
%>    filename - (str) full path of file name to export data to
%>    expr  - (cell array), list of expressions to export
%>    struct - (str) 'sectionwise' or 'spreadsheet', only for plot or data export
%>    fullprec - (string) whether or not to incude full precision, allowed values: 'on','off'
%>    transpose - (str) transpose data (available only if struct is spreadsheet), allowed: 'on', 'off'
%>
%>    differential - whether or not to set differential, allowable options are:'on', 'off'
%>
%>    evalmethod - method to evalue the expression with:
%>                allowed options:  'linpoint' to plot Static Solution
%>                                  'harmonic' to plot Harmonic Perturbation
%>                                  'lintotal' to plot Total Instantaneous Solution
%>                                  'lintotalavg' to plot Average for Total Solution
%>                                  'lintotalrms' to plot RMS for Total Solution
%>                                  'lintotalpeak' to plot Peak Value for Total Solution
function [exporttag,exportnode] = ExportData(varargin)

    % Possible export options
    exportoptions = {'Data', 'Plot', 'Mesh', 'Table','Image1D'};

    % Parse Input Values
    p = inputParser;
    p.addRequired('model', @(x) isa(x, 'com.comsol.model.impl.ModelImpl'));
    p.addRequired('exporttag', @isstr);
    p.addRequired('exporttype', @(x) any(validatestring(x,exportoptions)));
    p.addRequired('exportproperties', @isstruct);
    p.parse(varargin{:});

    % Parsed Inputs
    model = p.Results.model;
    exporttag = p.Results.exporttag;
    exporttype = p.Results.exporttype;
    exportproperties = p.Results.exportproperties;

    % Create export node
    exporttag = ValidateUniqueTag(exporttag, model.result.export.tags);
    model.result.export.create(exporttag, exporttype);
    exportnode=model.result.export(exporttag);


    % Create other solver specific parameters
    for prop = fields(exportproperties)'
        % iterate over expression list
        if strcmp(prop,'expr')
            expressionlist=getfield(exportproperties, cell2mat(prop));
            for i=1:length(expressionlist)
                exportnode.setIndex(cell2mat(prop),expressionlist(i),i-1); 
            end
            continue;
        end
        exportnode.set(cell2mat(prop), getfield(exportproperties, cell2mat(prop)));
    end 

    % If the data is an image, turn on the axes and set other properties
    % NOTE: COMSOL image export is buggy and is not working. So, generate plots using mphinterp instead
    if strcmp(exporttype,'Image1D') 
        %model.result(exportproperties.plotgroup).run;
        exportnode.set('axes','on');
        exportnode.set('size', 'manual');
        exportnode.set('title', 'on');
        exportnode.set('legend', 'on');
        exportnode.set('logo', 'on');
        exportnode.set('options', 'on');
        exportnode.set('fontsize', '9');
        exportnode.set('customcolor', [1 1 1]);
        exportnode.set('background', 'current');
        exportnode.set('imagetype', 'png');
        exportnode.set('antialias', 'on');
        model.result(exportproperties.plotgroup).set('window', 'graphics');
        model.result(exportproperties.plotgroup).run;
        model.result(exportproperties.plotgroup).set('window', 'graphics');
        model.result(exportproperties.plotgroup).set('windowtitle', 'Graphics');
    end

    % export the data
    sprintf('exporting %s ',exporttype)
    exporttag
    model.result.export(exporttag).run   
    %exportnode.run   

    %LogMsg(sprintf('Saving %s...', exportproperties.filename), 1);


end
