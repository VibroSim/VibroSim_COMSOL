%> Add a newly created wrapped model as a property to object
%> The new ModelWrapper will be object.propname
%> parent is the COMSOL object which will be used for creation
%> (parent.create(tag,varargin{:})
function newobj=CreateWrappedProperty(M,object,propname,tag,parent,varargin)

  addprop(object,(propname));
  object.(propname)=ModelWrapper(M,tag,parent);
  object.(propname).node=parent.create(object.(propname).tag,varargin{:});
  newobj=object.(propname);
