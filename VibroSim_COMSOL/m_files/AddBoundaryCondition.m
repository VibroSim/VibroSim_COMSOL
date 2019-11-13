%> AddBoundaryCondition creates, for each listed physics, a BuildLater
%> object that runs buildfcn as a boundary condition creation function
%> for that physics class (the physics name of the instantiated
%> physics object is appended to the tag when boundary conditions
%> are build for that physics).
%> It is registered for a single
%> physics class if physicsclassorcellarray is a string or under multiple
%> physics classses if physicsclassorcellarray is a cell array.
%> It is registered under a single BC class name if classnameorcellarray
%> is a string, or under multiple BC classes if classnameorcellarray is
%> a cell array
%>
%> A BC class ("boundary condition class") represents the combination
%> of physics and type of study for which the boundary condition applies.
%>
%> See util/ModelWrapper.m for definition of boundaryconditions structure
%>
%> buildfcn is called as buildfcn(M,physics,bcobj) which should fill out
%> the bcobj structure. All created COMSOL boundary condition objects
%> must be accessible either as bcobj.node, or through the node of
%> an element of bcobj.children (or the children's children, etc.).
function specimen=AddBoundaryCondition(M,specimen,object,tag,physicsclassorcellarray,classnameorcellarray,buildfcn)

% Create object.boundaryconditions structure if needed
if isa(object.boundaryconditions,'double')
  % object.boundaryconditions has not yet been set
  object.boundaryconditions=struct;
end

% Convert physicsclassorcellarray parameter into cell array physicsclasses
if isa(physicsclassorcellarray,'string') | isa(physicsclassorcellarray,'char')
  physicsclasses={};
  physicsclasses{1}=physicsclassorcellarray;
else
  physicsclasses=physicsclassorcellarray;
end

% Convert classnameorcellarray parameter into cell array classnames
if isa(classnameorcellarray,'string') | isa(classnameorcellarray,'char')
  classnames={};
  classnames{1}=classnameorcellarray;
else
  classnames=classnameorcellarray;
end

%bcobjs={};

for cnt=1:length(physicsclasses)
  physicsclass=physicsclasses{cnt};

  % Do we have an array of boundary conditions for this physics class yet? 
  if ~isfield(object.boundaryconditions,physicsclass)
      % if not, create one
      object.boundaryconditions.(physicsclass)={};
  end

  % The BuildLater class is 'bctemplate_' with physicsclass appended. 
  % The tag has physics class and '_bct" appended
  bcobj=BuildLater(M,[ tag '_' physicsclass '_bct' ],[ 'bctemplate_' physicsclass ], buildfcn);
  bcobj.addprop('classnames');
  bcobj.classnames=classnames;
  bcobj.addprop('bctag');
  bcobj.bctag=tag;


  object.boundaryconditions.(physicsclass){length(object.boundaryconditions.(physicsclass))+1}=bcobj;

  %bcobjs{length(bcobjs)+1}=bcobj;
  
  end
end

