function object = BuildLaterWithNormal(M,geom,tag,pos,buildfcn)

  object=BuildLater(M,tag,'buildlaterwithnormal',buildfcn);

  addprop(object,'buildlaterwithnormalpos');
  object.buildlaterwithnormalpos=pos;

