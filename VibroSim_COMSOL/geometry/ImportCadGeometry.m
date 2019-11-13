%> ImportCadGeometry Imports a CAD file into comsol workspace.
%>   [importcadtag,importcadnode] = ImportCadGeometry(model, geomtag, importcadtag, cadfilename) imports a cad model from disk.
%> As of now, parasolid file format '.x_t' seems to be the most compatible file format for CAD import.
%> Importing a STL file format may result in bad elements and the geometry not being rendered correctly.
%>
%> Parameters:
%> -----------
%> model - (obj) comsol model object
%> geomtag - (str) tag name for geometry node
%> importcadtag - (str) tag name for the import cad node
%> cadfilename - (str) filename of cad file to import
function [importcadtag,importcadnode] = ImportCadGeometry(varargin)

    % Parse Input Values
    p = inputParser;
    p.addRequired('model', @(x) isa(x, 'com.comsol.model.impl.ModelImpl'));
    p.addRequired('geomtag', @isstr);
    p.addRequired('importcadtag', @isstr);
    p.addRequired('cadfilename', @isstr);
    p.parse(varargin{:});

    % Parsed Inputs
    model = p.Results.model;
    geomtag = p.Results.geomtag;
    importcadtag = ValidateUniqueTag(p.Results.importcadtag,model.geom(geomtag).feature.tags);
    cadfilename = p.Results.cadfilename;


    % Validate Tags
    if not(any(ismember(cell(model.geom.tags),geomtag)))
        error('ImportCadGeometry:COMSOLEntityTagException', strcat('Geometry Tag "', geomtag, '" Cannot Be Found'))
    end

    % Create import cad node
    importcadnode = model.geom(geomtag).feature.create(importcadtag,'Import');
    % Set file name for import
    importcadnode.set('filename',cadfilename);


end
