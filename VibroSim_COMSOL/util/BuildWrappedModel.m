%> Build a wrapped model inside a pre-existing wrapper
function object=BuildWrappedModel(M,object,parent,varargin)

  object.parent=parent;
  object.node=parent.create(object.tag,varargin{:});

