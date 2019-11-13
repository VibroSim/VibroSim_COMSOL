function object=CreateWrappedModel(M,tag,parent,varargin)
% Create and return a newly wrapped model object

  object=ModelWrapper(M,tag,parent);
  object.node=parent.create(object.tag,varargin{:});

