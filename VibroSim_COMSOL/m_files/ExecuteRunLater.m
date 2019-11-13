%> Execute all the runlater objects of the specified class
function ExecuteRunLater(M,runlaterclass)

RLobjects=FindBuildLater(M,runlaterclass);

for objectcnt=1:length(RLobjects)
  rlobj=RLobjects{objectcnt};

  % rlobj is a BuildLater object
  % rlobj.classnames  is a cell array of class names
  % rlobj.tag tag name)
  % and rlobj.buildfcn  (anonymous build function) parameters

  % Run this runlater object
  rlobj.buildfcn(M,rlobj);
end
