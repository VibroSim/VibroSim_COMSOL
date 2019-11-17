%> @brief InitializeVibroSimScript Initializes the Environment to Run VibroSim Models
%>
%>   InitializeVibroSimScript() Initializes Everything
%>
%> @param mphfile (optional) allows you to load an existing mph file,
%>        which should just have specimen geometry and possibly materials
%>        and meshing -- no physics or studies. This way you can create
%>        geometry manually in advance rather than having to construct
%>        everything from Matlab.
%>
%> @retval [M, model]
function [M,model]=InitializeVibroSimScript(mphfile)

% NOTE: you MUST run 'comsol server' before calling this script

    % Clear Screen
    clc;

    global paramdb;
    clear global paramdb;


    % Make sure the working directory is the directory this script is contained in
    oldpwd = pwd;
    scriptpwd = fileparts(mfilename('fullpath'));

    % Add all of the paths needed 
    addpath(fullfile(scriptpwd, 'm_files'));
    %addpath([scriptpwd, '/conf']);
    %addpath([scriptpwd, '/conf']);
    %addpath([scriptpwd, '/definitions']);
    %addpath([scriptpwd, '/material']);
    %addpath([scriptpwd, '/mesh']);
    %addpath([scriptpwd, '/geometry']);
    %addpath([scriptpwd, '/physics']);
    %addpath([scriptpwd, '/results']);
    %addpath([scriptpwd, '/study']);
    %addpath([scriptpwd, '/util']);
    %addpath([scriptpwd, '/support']);
    addpath('/usr/local/dataguzzler-lib/matlab');
    addpath('/usr/local/matlab/dc_unitsparam');

    % configure dc_unitsparam units, if possible
    try
      dcuc_init()
    catch err
      fprintf(1,'InitializeVibroSimScript: dc_unitsparam not available... datacollect parameters will not be accessible')
    end
    % Try to run mphstart to connect to comsol server
    if ~exist('mphstart') 
      [status,result]=system('ps awwxo args | grep com.comsol.util.application.ServerApplication | awk ''{ print $1 }'' | grep java | head -1');

      % result is like /home/usr_local_el6/comsol50/multiphysics/java/glnxa64/jre/bin/java
      % strip off the 2nd-to-last java and replace with mli. That needs to be added to  the path
      if length(result)==0
        [status,result]=system('ps awwxo args | grep com.comsol.util.application.ServerApplication | awk ''{ print $1 }'' | grep bin/comsol | head -1');
        % result is like /usr/local/comsol54/multiphysics/bin/comsol
        binstart=strfind(result,'bin/comsol');
        comsolpath=fullfile(result(1:(binstart-1)),'mli',filesep);
      else
        javas=strfind(result,'java');
        javastart=javas(1,size(javas,2)-1);
        comsolpath=fullfile(result(1:(javastart-1)),'mli',filesep);
      end
      % add matlab livelink directory 
      path(comsolpath,path);  % add to path

      if ~exist('mphstart')
	error(['mphstart could not be found, even in ' comsolpath])
      end

    end

    try 
      mphversion;  % if mphversion fails, we need to run mphstart
    catch
      try
        mphstart(2036)
      catch
        try
          mphstart(2037);
        catch
          error('InitializeComsolScript:COMSOLServerException', 'Unable to connect to COMSOL Server - Check and Try Again')
        end
      end
    end

    % Import Comsol Java Libraries   -- required to call ModelUtil functions
    import com.comsol.model.*
    import com.comsol.model.util.*

    ModelUtil.clear();

    % Clear our global tagged object database
    ClearWrappedObjects();

    % Go Back
    %cd(oldpwd);

    % Print Startup Information
    startupinfo = ['\n'];
    startupinfo = [startupinfo, sprintf('=======================================================\n')];
    startupinfo = [startupinfo, sprintf('===              COMSOL Model Builder               ===\n')];
    startupinfo = [startupinfo, sprintf('=======================================================\n')];
    startupinfo = [startupinfo, sprintf('MATLAB %s on %s\n', version, computer)];
    version -java;
    startupinfo = [startupinfo, sprintf('%s\n', ans)];
    %startupinfo = [startupinfo, sprintf('%s\n', mphversion)];
    startupinfo = [startupinfo, sprintf('Running in Scripted Mode\n')];
    startupinfo = [startupinfo, sprintf('=======================================================\n')];
    startupinfo = [ startupinfo sprintf('\n') ];
    startupinfo = [ startupinfo sprintf('The variables from your script should be defined\n') ];
    startupinfo = [ startupinfo sprintf('You can rerun the script by typing its name.\n') ];
    startupinfo = [ startupinfo sprintf('You can connect to the COMSOL server using "comsol mphclient" \n') ];
    startupinfo = [ startupinfo sprintf('to work interactively.\n') ];

    startupinfo = [ startupinfo sprintf('If running inside processtrak you can exit with: eval(retcommand);\n') ];

 
    LogMsg(startupinfo, 1);

    if exist('mphfile','var')
      % load the mph file
      model=mphload(mphfile);
      M=WrapComsolNode([],model);
      
      % Find component and geometry -- only works with a 
      % single component and geometry
      componenttags=to_cellstr_array(M.node.modelNode.tags);
      assert(length(componenttags)==1); % must have single component
      addprop(M,'component');
      M.component=WrapComsolNode(M,M.node.modelNode(componenttags{1}));

      % Find and wrap geometry
      geomtags=to_cellstr_array(M.node.geom.tags);
      assert(length(geomtags)==1); % must have single geometry
      geom=WrapComsolNode(M,M.node.geom(geomtags{1}));
      addprop(M,'geom');
      M.geom=geom;

      % Extract top-level mesh, if present
      meshtags=to_cellstr_array(M.node.mesh.tags);
      assert(length(meshtags)<=1); % must have zero or one top level meshes
      if length(meshtags)==1 
        % mesh is present
        mesh=WrapComsolNode(M,M.node.mesh(meshtags{1}));
        % addprop(M,'geom'); % .mesh property defined in ModelWrapper
        M.mesh=mesh;
      end

      if length(M.node.physics.tags) > 0
	LogMsg('WARNING: Loaded COMSOL model contains physics that\nmight conflict with created physics!',1);
      end 

      if length(M.node.study.tags) > 0
	LogMsg('WARNING: Loaded COMSOL model contains studies that\nmight conflict with created studies!',1);
      end 

    else 

      % Initialize the Model
      [M,model,component] = CreateModel('Model','Component');

    end



end
