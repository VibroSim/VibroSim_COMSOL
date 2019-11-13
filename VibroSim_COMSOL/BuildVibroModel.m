%> BUILDVIBROMODEL Creates and Runs a COMSOL model of the vibrothermography process
%> based on the given functions which instantiate the different portions of the
%> simulation.
%>
%> Parameters:
%>     @param geometryfunc:     Function, called as specimen=GeometryFunc(M,geom,'specimen')
%>                            Which should build the geometry and define materials.
%>                            It also needs to specify appropriate classes of boundary
%>                            conditions and to be used by the physics, below, as well
%>                            as meshing instructions.
%>     @param flawfunc:         Function (or omit by passing []) that is to be used
%>                            to add flaws to the geometry. Called as
%>                            flaw=flawfunc(M,geom,specimen)
%>     @param physicsstudyfunc: Function, called as physicsstudyfunc(M,geom,specimen,M.flaw)
%>                            which defines a set of physics nodes and then a set of
%>                            study nodes to perform the simulation.
%>     @param resultsfunc:      Function to call to set up Results tree. Called as
%>                            resultsfunc(model). This code is intended to be pasted
%>                            directly from Comsol Save As... m-file. You can use
%>                            structured code if appropriate, but we don't recommend
%>                            accessing the structured objects, as then you won't be
%>                            able to run this code (for example) on results
%>                            from running studies in a loaded .mph file.
%>     @param savefilename:     Optional filename to save the model, if given .
function BuildVibroModel(M,geometryfunc,flawfunc, physicsstudyfunc, resultsfunc, savefilename)

    model=M.node;

    % Build Geometry
    [geom,mesh] = CreateGeometryNode(M,'Geom','Mesh',3);
    SetGeometryFinalization(M,geom,'assembly',true);

    % call geometry function
    if ~isa(geometryfunc,'double')
      specimen=geometryfunc(M,geom);
      addprop(M,'specimen');
      M.specimen=specimen;
    end


    % run flawfunc, if provided
    addprop(M,'flaw');
    if ~strcmp(class(flawfunc),'double')
      M.flaw=flawfunc(M,geom,specimen);
    end

    % Create meshes prior to BuildWithNormals
    MeshSetBounds(M,mesh,ObtainDCParameter(M,'meshsizemin','m'),ObtainDCParameter(M,'meshsize','m'));
    MeshRemainingObjects(M,geom,mesh);


    % Create empty study to find normals
    addprop(M,'normalstudy');
    M.normalstudy=CreateStudy(M,geom,'getnormals');
    M.normalstudy.node.run;


    % Build all buildlater objects now that we have the normals
    BuildWithNormals(M,geom);

    % Now mesh the newly-created objects
    MeshRemainingObjects(M,geom,mesh);


    % Apply materials to objects
    ApplyMaterials(M,geom);

    LoadPairDatabase(M,geom);

    physicsstudyfunc(M,geom,specimen,M.flaw);
  

    % Select boundary conditions -- run here through ExecuteRunLater because these routines may not
    % be called until ALL physicses have been created
    ExecuteRunLater(M,'select_boundaryconditions');



    M.node.comments(['RunVibroModel: Model setup completed\n']);

    % fill in blank solutions so that we can pre-run resultsfunc

    % CreateBlankSolutions() no longer necessary now that we create StoreSolutions in CreateSolution()
    %CreateBlankSolutions(M);

    % run resultsfunc, if provided
    if ~strcmp(class(resultsfunc),'double')
      resultsfunc(M);
    end

    % Make save directory if necessary
    if exist('savefilename','var')
      savedirectory=fileparts(savefilename);
      if ~exist(savedirectory,'dir')
        mkdir(savedirectory)
      end

      % if savefilename provided, perform save
      mphsave(M.node,savefilename);

    end

