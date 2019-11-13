function study = CreateStudy(M,geom,tag)

  study=ModelWrapper(M,tag,M.node.study);
  study.node=M.node.study.create(study.tag);
  study.node.label(study.tag);
  

  addprop(study,'steps');
  % study.steps is a cell array of the study steps

  study.steps={};
