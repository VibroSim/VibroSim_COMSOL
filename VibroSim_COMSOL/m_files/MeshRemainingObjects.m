%> Instantiate all unbuilt buildable mesh objects, in creation order
%> given the global mesh object. Buildable mesh objects are
%> found by searching the WrappedObjectDB for objects with a
%> 'meshbuilder' property, and add them to the COMSOL tree.
%>
%> meshbuilder called as meshbuilder(M,geom,mesh,object);
function MeshRemainingObjects(M,geom,mesh)


  % Find all BuildLater objects with 'meshbuilder' class
  sortedbuildmeshobjects=FindBuildLater(M,'meshbuilder');

  % error('MeshRemainingObjects')

  % build their meshes
  for cnt=1:length(sortedbuildmeshobjects)
    sortedbuildmeshobjects{cnt}.buildfcn(M,mesh,sortedbuildmeshobjects{cnt});
    sortedbuildmeshobjects{cnt}.is_built=true;
  end
  
  % build all meshes
  mesh.node.run();
