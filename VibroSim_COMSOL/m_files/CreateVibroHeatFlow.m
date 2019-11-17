%> @retval heatflow
function heatflow = CreateVibroHeatFlow(M,geom,tag)
    %,vibration_physics,vibrationsolutionindex,vibroheatconvert)

  ObtainDCParameter(M,'simulationtimestart');
  ObtainDCParameter(M,'simulationtimestep');
  ObtainDCParameter(M,'simulationtimeend');

  heatflow=CreatePhysics(M,geom,tag,'HeatTransfer');

  addprop(heatflow,'timedomain');
  heatflow.timedomain=true;

  % Fix equation form to 'transient'
  heatflow.node.prop('EquationForm').setIndex('form', 'Transient', 0);

  BuildBoundaryConditions(M,geom,heatflow,'heatflow'); % apply boundary condtions


  % Define time-domain study for heat transfer
  addprop(heatflow,'study');
  heatflow.study=CreateStudy(M,geom,[ tag '_study' ]);

  %if prod(size(vibration_physics)) > 0 % if vibration_physics is not []
  %    heatflowinputphysics=vibration_physics;
  %    heatflowinputstudy=vibration_physics.study;
  %    heatflowinputsolnum=vibrationsolutionindex;
  %end
  %
  %% If there is a vibroheatconvert parameter, create an extra study step to do the heat
  %% conversion
  %if exist('vibroheatconvert','var') & prod(size(vibration_physics)) > 0
  %  addprop(heatflow,'vibroheatconvertstep');
  %  heatflow.vibroheatconvertstep=StudyAddStep(M,geom,heatflow.study,[ tag '_vibroheatconvert_step' ],'Stationary',vibroheatconvert,vibration_physics); % both vibroheatconvert and vibration_physics are turned on...
  %  % ... but vibration physics isnot to be solved
  %  StudyStepEnablePhysicsInSolvers(M,heatflow.vibroheatconvertstep,vibration_physics,false); % ... but the vibration physics is not to be solved
  %
  %  % Set up to pull solutions from another study (frequency domain study)
  %  heatflow.vibroheatconvertstep.node.set('usesol','on');
  %  % pull variables not solved for from another solution
  %  heatflow.vibroheatconvertstep.node.set('notsolmethod','sol');
  %  % Select study to pull variables from
  %  heatflow.vibroheatconvertstep.node.set('notstudy',vibration_physics.study.tag);
  %  %heatflow.step.node.set('notsol',vibration_physics.solution.tag);
  %  heatflow.vibroheatconvertstep.node.set('notsolnum',vibrationsolutionindex);
  %
  %  heatflowinputphysics=vibroheatconvert;
  %  heatflowinputstudy=heatflow.study;  % !!! Should this be vibroheatconvert.study????
  %  heatflowinputsolnum=1;
  %
  %  % Create solution for heatflow vibroheatconvert step
  %  %addprop(heatflow,'vibroheatconvert_solution');
  %  %heatflow.vibroheatconvert_solution=CreateSolution(M,heatflow.study,[ tag '_vibroheatconvert_solution' ],heatflow.vibroheatconvertstep,'Stationary');
  %
  %
  % end

  addprop(heatflow,'step');
  %% Set up the Physics to solve for and Physics enable only if vibration_physics is not empty
  %if prod(size(vibration_physics)) > 0 % if vibration_physics is not []
  %  heatflow.step=StudyAddStep(M,geom,heatflow.study,[ tag '_step' ],'Transient',heatflow,heatflowinputphysics); % both heatflow and specified (vibration or vibroheatconvert) physics are turned on
  %  StudyStepEnablePhysicsInSolvers(M,heatflow.step,heatflowinputphysics,false); % ... but the input physics is not to be solved
  %
  %  % Set up to pull solutions from another study (frequency domain study)
  %  heatflow.step.node.set('usesol','on');
  %  % pull variables not solved for from another solution
  %  heatflow.step.node.set('notsolmethod','sol');
  %  % Select study to pull variables from
  %
  %  heatflow.step.node.set('notstudy',heatflowinputstudy.tag);
  %  %heatflow.step.node.set('notsol',vibration_physics.solution.tag);
  %  heatflow.step.node.set('notsolnum',heatflowinputsolnum);
  %else
  heatflow.step=StudyAddStep(M,geom,heatflow.study,[ tag '_step' ],'Transient',heatflow); % both heatflow and specified vibration physics are turned on
  %end

  heatflow.step.node.set('tlist','range(simulationtimestart,simulationtimestep,simulationtimeend)');


  % Create solution for heatflow step
  addprop(heatflow,'solution');
  %if exist('vibroheatconvert','var')
  %  % If we have the vibroheatconvert step, our solution needs to cover it too. 
  %  heatflow.solution=CreateSolution(M,heatflow.study,[ tag '_solution' ],heatflow.vibroheatconvertstep,'Stationary',heatflow.step,'Time');
  %else

  % Otherwise just the time-domain heatflow solution
  heatflow.solution=CreateSolution(M,heatflow.study,[ tag '_solution' ],heatflow.step,'Time');
  %end

  % Select BC's once all Physicses have been created
  addprop(heatflow,'rl_selectbcs');
  heatflow.rl_selectbcs=RunLater(M,[ tag 'rl_selectbcs' ],'select_boundaryconditions', ...
                     @(M,rlobj) ...
                     SelectBoundaryConditionsForStudy(M,heatflow.study,{'crackheating','continuities'})); % Activate boundary conditions of specified classes

end
