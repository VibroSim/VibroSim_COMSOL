%> PlotResonanceCurve plots the frequency vs displacement
%>   [freqs,totaldispl,w] = PlotResonanceCurve(model,physicstag,varargin) extracts data from a single point and plots the resonance curve.
%>    Required parameters:
%>    -------------------
%>    model - (obj) comsol model object
%>    physicstag - (str) name tag of physics node whose data is extracted
%>    saveplot - (boolean) flag set whether or not to save image
%>    saveplotfilename - (str) name of the png file to save
%>
%>    Required keyword Arguments:
%>    ---------------------------
%>    dataset - (str) name tag of dataset to be extracted
%>
%>    Optional keyword arguments:
%>    --------------------------
%>    coord     - (string) coordinates
%>    evalmethod - (str) evaluation method
%>    differential - (str) whether or not to turn on differential
%>
%>    Returns:
%>    --------
%>    freqs - list of frequencies
%>    totaldispl - total displacement values
%>    w - displacement, z component
function [freqs,totaldispl,w] = PlotResonanceCurve(varargin)

    % Parse Input Values
    p = inputParser;
    p.addRequired('model', @(x) isa(x, 'com.comsol.model.impl.ModelImpl'));
    p.addRequired('physicstag', @isstr);
    p.addParamValue('saveplot',0,@islogical);
    p.addParamValue('saveplotfilename','/tmp/resonance.png',@isstr);
    p.addParamValue('coord', 'none', @isstr);
    p.addParamValue('dataset','none',  @isstr);
    p.addParamValue('evalmethod','none',  @isstr);
    p.addParamValue('differential','none',  @isstr);
    p.parse(varargin{:});

    % Parsed Inputs
    model = p.Results.model;
    physicstag = p.Results.physicstag;
    saveplot=p.Results.saveplot;
    saveplotfilename=p.Results.saveplotfilename;
    coord = p.Results.coord;
    dataset = p.Results.dataset;
    evalmethod = p.Results.evalmethod
    differential = p.Results.differential;

    expressionlist = {strcat(physicstag,'.freq'),strcat(physicstag,'.disp'),'w2'};

    optionalfields={'coord','dataset','evalmethod','differential'};
    % Create argument list for calling mphinterp
    arguments={};
    % collect all the non-default key word argument into a cell array
    for i = 1:length(optionalfields) 
        prop = cell2mat(optionalfields(i));
        fieldval=getfield(p.Results,prop);
        if ~strcmp('none',fieldval)
            arguments={arguments{:},prop,fieldval};
        end
    end 

    % extract data
    [freqs,totaldispl,w]=mphinterp(model,expressionlist,arguments{:});

    % Calculate the Q factor
    Qfactor=CalcQfactor(freqs,totaldispl)


    [path,figtitle,ext]=fileparts(saveplotfilename);
    if saveplot
        % make a plot of resonance spectrum
        figure;
        h=plot(freqs,totaldispl,'.-');
        xlabel('frequency(Hz)');
        ylabel('Total displacement(m)');
        grid on;
        figtitle=strrep(figtitle,'_','\_'); % make sure _ doesn't represent subscript
        title(figtitle);
        saveas(h,saveplotfilename,'png');
    end
end
