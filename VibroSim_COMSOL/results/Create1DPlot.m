%> CREATE1DPLOT Adds a Plot to a Plot Group
%>   [plotgrouptag,plottag,plotgroupnode,plotnode] = CREATE1DPLOT(model, grouptag, plottype, varargin) Creates Plot of Given Type
%> Required parameters:
%> -------------------
%>    'model' - (obj) comsol model object
%>    'plotgrouptag' - (str) name tag of plot group to be created
%>    'plotproperties' - (struct) plot group properties;
%>
%> plotproperties are the property field/value pairs to be set for the 1D plot being generated
%> Following are the allowed fields in this struct:
%>  data - name tag of the 1D dataset
%>  expr  - expression to plot
%>  differential - whether or not to set differential, allowable options are:'on', 'off'
%>  evalmethod - method to evalue the expression with:
%>                allowed options:  'linpoint' to plot Static Solution
%>                                  'harmonic' to plot Harmonic Perturbation
%>                                  'lintotal' to plot Total Instantaneous Solution
%>                                  'lintotalavg' to plot Average for Total Solution
%>                                  'lintotalrms' to plot RMS for Total Solution
%>                                  'lintotalpeak' to plot Peak Value for Total Solution
function [plotgrouptag,plottag,plotgroupnode,plotnode] = Create1DPlot(varargin)


    % Parse Input Values
    p = inputParser;
    p.addRequired('model', @(x) isa(x, 'com.comsol.model.impl.ModelImpl'))
    p.addRequired('plotgrouptag', @isstr);
    p.addRequired('plotproperties',@isstruct);
    p.parse(varargin{:});

    % Parsed Inputs
    model = p.Results.model;
    plotgrouptag = p.Results.plotgrouptag;
    plotproperties = p.Results.plotproperties;

    % Create a 1D plot group:
    plotgrouptag = ValidateUniqueTag(plotgrouptag, model.result.tags);
    plotgroupnode=model.result.create(plotgrouptag,'PlotGroup1D');
    % flag that says where the data tag is set. Either here or in the plot node
    datatagset=false;
    if isfield(plotproperties,'data')
        datatagset=true;
        % Set the dataset for plot group node
        plotgroupnode.set('data',plotproperties.data);
    end


    % Create a 1D plot 
    plottag = ValidateUniqueTag('ptgraph', plotgroupnode.feature.tags);
    plotnode=plotgroupnode.feature.create(plottag, 'PointGraph');

    % iterate over plotproperties structure and set the plot properties

    for prop = fields(plotproperties)'
        if strcmp(prop,'legend')
            % Enable Legend
            plotnode.set('legend','on');
            plotnode.set('legendmethod','manual');
            plotnode.setIndex('legends',getfield(plotproperties, cell2mat(prop)),0);
            continue;
        end
        
        if strcmp(prop,'title')
            % set manual title
            plotnode.set('titletype','manual');
            plotnode.set('title',getfield(plotproperties, cell2mat(prop)));
            continue;
        end

        if strcmp(prop,'data') && datatagset % datatag has already been set, inherit from parent node
            plotnode.set('data','parent');
            continue;
        end

        plotnode.set(cell2mat(prop), getfield(plotproperties, cell2mat(prop)));
    end 

    plotnode.run;

end
