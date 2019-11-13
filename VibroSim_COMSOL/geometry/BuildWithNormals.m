%> NOTE: Since we use GetNormal() rather than GetOutwardNormal()
%> if you call this multiple times, such as in debug mode
%> you might get flipped normals -- from getting the normal to the thing
%> built in the previour round !!!
function BuildWithNormals(M,geom)

%[sortedbuildlater]=FindWrappedObjectsWithNonNumericParam(M,'buildlaterwithnormal');
[sortedbuildlater]=FindBuildLater(M,'buildlaterwithnormal');

for cnt=1:length(sortedbuildlater)

  pos=sortedbuildlater{cnt}.buildlaterwithnormalpos;

  [normal,numpos]=GetNormal(M,geom,pos);

  sortedbuildlater{cnt}.buildfcn(M,geom,sortedbuildlater{cnt},numpos.',normal);

  sortedbuildlater{cnt}.is_built=true;

end

