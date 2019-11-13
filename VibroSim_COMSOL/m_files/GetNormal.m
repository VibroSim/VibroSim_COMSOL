%> Get the normal vector at the closest boundary node to pos
%> Note that this doesn't necessarily guarantee which geometric object the normal
%> comes from, so you might get the normal in the wrong direction!
%>
%> THIS FUNCTION MAY ONLY BE CALLED ONCE GEOM IS MESHED AND getnormals STUDY COMPLETED
%>
%> If you want a normal that is always flipped to point outward from a convex object,
%> see GetOutwardNormal(M,Geom,pos)
function [normal,numpos]=GetNormal(M,geom,pos)

  numpos=to_numeric_vector(M,pos,'m');  % convert to numeric vector



  % mphinterp doesn't work because the normals don't have interpolation functions
  %  [normalx,normaly,normalz]=mphinterp(M.node,{'nx','ny','nz'},'Edim','boundary','Coord',sortedbuildlater{cnt}.buildlaterwithnormalpos);


  % Instead find the closest normal
  dat=mpheval(M.node,{'nx','ny','nz'},'Edim','boundary');

  %numpos
  %size(dat.p)
  %size(numpos)
  %size((numpos.')*ones(1,size(dat.p,2)))

  [junk,minidx]=min(sum((dat.p-(numpos.')*ones(1,size(dat.p,2))).^2,1));
  normalx=dat.d1(minidx);
  normaly=dat.d2(minidx);
  normalz=dat.d3(minidx); 

  normal=[normalx,normaly,normalz];
