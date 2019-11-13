%> EXPORTRECTANGULARBARFRONTFACEDATA Exports Mode Shape Data for the Front Face of the Rectangular Bar Specimen
%>   [] = EXPORTRECTANGULARBARFRONTFACEDATA(model, exportfilename) Exports Data to File of Given Name
function ExportRectangularBarVolumeData(varargin)


    % Parse Input Values
    p = inputParser;
    p.addRequired('model', @(x) isa(x, 'com.comsol.model.impl.ModelImpl'))
    p.addRequired('selection',@ismatrix);
    p.addRequired('exporttag',);
    p.addRequired('exporttype',@isstr);
    p.addRequired('exportfilename', @isstr);
    p.parse(varargin{:});

    % Parsed Inputs
    model = p.Results.model;
    exportfilename = p.Results.exportfilename;

    % Make Sure We Should Be Running This
    shouldexport = 'YES';
    try
      shouldexport = GetDCParamStringValue(M,'exportresults'); shouldexport = shouldexport.value;
    catch
        % Do Nothing
    end
    if strcmp(upper(shouldexport), 'NO')
        return
    end

    % Notify User
    LogMsg('\nExporting Front Face Data...', 1);

    % Create Cut Plane
    cutplane = struct();
    cutplane.tag = 'frontface_cutplane';
    cutplane.type = 'quickplane';
    cutplane.quickeqn = 'xy';
    cutplane.quickplaneoffset = 0.0;
    cutplane = CreateCutPlane(model, cutplane);

    % Export Data from Cut Plane
    exporttag = 'frontface_export';
    exporttype='Data';
    exportproperties = struct();
    exportproperties.data = cutplane.tag;
    exportproperties.filename = exportfilename;
    export.expr = {'u', 'v', 'w', 'solid.sx', 'solid.sy', 'solid.sz', 'solid.sxy', 'solid.syz', 'solid.sxz', 'solid.freq'};
    export.struct='sectionwise';
    export = ExportData(model, exporttag,exporttype,exportproperties);

end
