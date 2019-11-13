function obj=CreateCameraNoise(M,tag,camera_netd);

  obj=CreateWrappedModel(M,tag,M.node.func,'Random');
  obj.node.model(M.component.tag); % attach to component rather than global
  obj.node.set('funcname',tag);
  obj.node.label(tag);
  obj.node.set('nargs','3'); % 3 parameters -- x,y,z dependence
  obj.node.set('type','normal'); % normally distributed
  obj.node.set('normalsigma',camera_netd);
  obj.node.set('mean','0[K]');
  