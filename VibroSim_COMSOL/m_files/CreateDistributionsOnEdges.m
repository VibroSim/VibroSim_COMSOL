%> Create a Distribution on each edge surrounding and inside boundaryselection --
%> which is a set of boundary entities. These Distributions are for meshedobj
%> (caller is responsible for adding to the struct).
%> numelemfunc is the function to call to determine the number of elements in
%> a particular edge. It is called as
%> numelem=numelemfunc(M,geom,meshedobj,edgeid,edgelength)
function [dists] = CreateDistributionsOnEdges(M,geom,tagbase,meshedobj,boundaryselectionentities,numelemfunc)


  edgenums=[];

  for cnt=1:length(boundaryselectionentities)
    edges=mphgetadj(M.node,geom.tag,'edge','boundary',boundaryselectionentities(cnt));
    edgenums=[edgenums edges];
  end

  dists={};

  for cnt=1:length(edgenums)
    dists{cnt}=ModelWrapper(M,sprintf('%s_%d',tagbase,cnt),meshedobj.node.feature);
    dists{cnt}.node=meshedobj.node.feature.create(dists{cnt}.tag,'Distribution');
    dists{cnt}.node.label(dists{cnt}.tag);
    %edgenums
    %edgenums(cnt)

    dists{cnt}.node.selection.geom('Geom',1); % set to 1-dimensional (edge) distribution
    dists{cnt}.node.selection.set(edgenums(cnt));
    addprop(dists{cnt},'edgelength');
    dists{cnt}.edgelength=GetMeasurement(M,geom,edgenums(cnt),1);
    addprop(dists{cnt},'numelem');
    dists{cnt}.numelem=numelemfunc(M,geom,meshedobj,edgenums(cnt),dists{cnt}.edgelength);
    dists{cnt}.node.set('numelem',dists{cnt}.numelem);
  end
