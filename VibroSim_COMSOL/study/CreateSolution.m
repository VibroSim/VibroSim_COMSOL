%> @param Type can be 'Stationary', 'Eigenvalue', or 'Time'
%> varargin is stepobj1,type1, stepobj2,type2, ...
function solution=CreateSolution(M,study,tag,varargin)

% Create solution
solution=ModelWrapper(M,tag,M.node.sol);
solution.node=M.node.sol.create(solution.tag);
solution.node.label(solution.tag);

% attach solution to study
solution.node.study(study.tag);


addprop(solution,'attachments');
solution.attachments={};

addprop(solution,'variables');
solution.variables={};

addprop(solution,'solutionsolvers');
solution.solutionsolvers={};

for stepcnt=1:(length(varargin)/2)
  stepobj=varargin{1+(stepcnt-1)*2};
  solvertype=varargin{1+(stepcnt-1)*2+1};

  % Create attachment node that connects it to specified study and step
  solution.attachments{stepcnt}=ModelWrapper(M,sprintf('%s_attach%.3d',tag,stepcnt),solution.node.feature);
  solution.attachments{stepcnt}.node=solution.node.feature.create(solution.attachments{stepcnt}.tag,'StudyStep');
  solution.attachments{stepcnt}.node.label(solution.attachments{stepcnt}.tag);
  solution.attachments{stepcnt}.node.set('study',study.tag);
  solution.attachments{stepcnt}.node.set('studystep',stepobj.tag);

  % Create variables object within solution
  solution.variables{stepcnt}=ModelWrapper(M,sprintf('%s_vars%.3d',tag,stepcnt),solution.node);
  solution.variables{stepcnt}.node=solution.node.create(solution.variables{stepcnt}.tag,'Variables');
  solution.variables{stepcnt}.node.label(solution.variables{stepcnt}.tag);
  solution.variables{stepcnt}.node.set('control',stepobj.tag);

  % Create solutionsolver of the specified type

  solution.solutionsolvers{stepcnt}=ModelWrapper(M,sprintf('%s_solusolver%.3d',tag,stepcnt),solution.node.feature);
  solution.solutionsolvers{stepcnt}.node=solution.node.feature.create(solution.solutionsolvers{stepcnt}.tag,solvertype);
  solution.solutionsolvers{stepcnt}.node.label(solution.solutionsolvers{stepcnt}.tag);
  solution.solutionsolvers{stepcnt}.node.set('control',stepobj.tag);

end


%% Create StoreSolution node as a placeholder until we have a solution
% ... turns out not to be needed after all and just creates an 
% excess solution node
%CreateWrappedProperty(M,solution,'store',[ solution.tag '_store' ],solution.node,'StoreSolution');
%solution.store.node.label(solution.store.tag);

% enable solution so that it runs when you click the study 'compute' button
solution.node.attach(study.tag);
