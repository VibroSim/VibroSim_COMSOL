%> EXTRACTBASERESONANCE Calculate Resonance Curve At a Point on The Specimen Surface to Refine Frequency Step
%>
%> This function creates a cut point dataset on the specimen surface, generates a 1D plot of frequency vs total displacement, exports the plot data, reads the data, finds the resonance and generates a new string of frequencies with a finer step around resonance
%>
%>   [freqvals, totaldisplacement, newexcitationstring] = EXTRACTBASERESONANCE(model,coordinates) Calculates The Displacement at (x,y,z) As a Function Of Frequency At a Point
%>
%> Parameters:
%> ----------
%> model - (obj) comsol data object
%> coordinates - (cell array) string representation of coordinates of a point, or parameter defined coordinates, eg: {'spclength/2','spcwidth/2','0'}
%> physicstag - (str) tag name of the physics node of which data is to be extracted, this is used to define physics based variables
%> datasettag - (str) tag name of the dataset associated with the study
%>
%> Returns:
%> -------
%> freqs - (array) array of frequencies at which
%> totaldispl - (array) array of displacement values extracted
%> newexcitationstring - (str) new excitation string refined about the center frequency
function [freqs,totaldispl,w,newexcitationstring,cutpointtag,cutpointnode] = ExtractBaseResonance(varargin)

    % Parse Input Values
    p = inputParser;
    p.addRequired('model', @(x) isa(x, 'com.comsol.model.impl.ModelImpl'));
    p.addRequired('coordinates', @iscell);
    p.addRequired('physicstag', @isstr);
    p.addRequired('datasettag', @isstr);
    p.addParamValue('saveplot',0,@islogical);
    p.addParamValue('saveplotfilename','/tmp/resonance.png',@isstr);
    p.parse(varargin{:});

    % Parsed Inputs
    model = p.Results.model;
    coordinates = p.Results.coordinates;
    physicstag=p.Results.physicstag;
    datasettag=p.Results.datasettag;
    saveplot=p.Results.saveplot;
    saveplotfilename=p.Results.saveplotfilename;

    % Set Cutpoint Properties
    coordinates={'spclength/2','spcwidth/2','0'};
    cutpointproperties=struct();
    cutpointtag=ValidateUniqueTag('cutpt3d',model.result.dataset.tags);
    cutpointproperties.pointx=coordinates(1);
    cutpointproperties.pointy=coordinates(2);
    cutpointproperties.pointz=coordinates(3);
    cutpointproperties.data=datasettag;
    % Create a Cut Point 3D
    [cutpointtag,cutpointnode] = CreateCutPoint3D(model,cutpointtag,cutpointproperties);

    % Generate 1D plot
    plotgrouptag = ValidateUniqueTag('pltgrp1',model.result.tags);
    plotproperties = struct();
    plotproperties.data = cutpointtag;
    plotproperties.expr = strcat(physicstag,'.disp');
    plotproperties.differential='off';
    plotproperties.evalmethod='lintotalpeak';
    [path,saveplotbasename,extension]=fileparts(saveplotfilename);
    plotproperties.title=saveplotbasename;
    [plotgrouptag,plottag,plotgroupnode,plotnode]=Create1DPlot(model,plotgrouptag,plotproperties);

    %%% Export the image
    %exportimgtag=ValidateUniqueTag('exportimage', model.result.export.tags);
    %exportimgtype='Image1D';
    %exportimgproperties=struct();
    %exportimgproperties.plotgroup=plotgrouptag;
    %exportimgproperties.pngfilename=saveplotfilename;
    %[exportimgtag,exportimgnode]=ExportData(model,exportimgtag,exportimgtype,exportimgproperties);

    %%% Export the data at a single point on the specimen
    %export1ddatatag = ValidateUniqueTag('exportpointdata', model.result.export.tags);
    %export1ddatatype = 'Plot';
    %export1ddataproperties = struct();
    %export1ddataproperties.filename  =fullfile(path,strcat(saveplotbasename,'.dat'));
    %export1ddataproperties.plotgroup = plotgrouptag;
    %export1ddatadataproperties.struct='spreadsheet';
    %export1ddataproperties.fullprec='on';
    %export1ddataproperties.header='off';
    %[export1ddatatag,export1ddatanode]=ExportData(model,export1ddatatag,export1ddatatype,export1ddataproperties);

    %%% Now read the exported data from /tmp/
    %importeddata=load(export1ddataproperties.filename);
    %freqs=importeddata(:,1);
    %totaldispl=importeddata(:,2);

    % Plot coarse resonance 
    [freqs,totaldispl,w] = PlotResonanceCurve(model,physicstag,'saveplot',saveplot,'saveplotfilename',saveplotfilename,'dataset',cutpointtag,'evalmethod','lintotalpeak','differential','off');

    % peak resonance
    [maxval,maxindex]=max(totaldispl);
    resonancefreq=freqs(maxindex);
    totalmin=min(freqs);
    totalmax=max(freqs);
    n1=30; % n1 is number of 1Hz steps before and after the resonance
    n10=5; % n10 is the number of 10 Hz steps before and after the resonance
    n50=5; % n50 is the number of 50 Hz steps before and after the resonance
    %n75=1; % n50 is the number of 50 Hz steps before and after the resonance
    range3min=resonancefreq-(n1)+1; 
    range2max=range3min-1;
    range2min=range2max-(n10*10); 
    range1max=range2min-10;
    range1min=range1max-(n50*50); 
    range3max=resonancefreq+(n1);
    range4min=range3max+10;
    range4max=range4min+(n10*10);
    range5min=range4max+50;
    range5max=range5min+(n50*50);

    newexcitationstring=sprintf('range(%d,50,%d),range(%d,10,%d),range(%d,1,%d),range(%d,10,%d),range(%d,50,%d)',range1min,range1max,range2min,range2max,range3min,range3max,range4min,range4max,range5min,range5max);

end
