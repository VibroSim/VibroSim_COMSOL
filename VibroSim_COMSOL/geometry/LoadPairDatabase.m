% LoadPairDatabase -- load database of automatically generated boundary
% pairs for geometry
function LoadPairDatabase(M,geom)

pairs=M.node.pair.tags;

addprop(geom,'bndpairdb');
geom.bndpairdb=containers.Map();
addprop(geom,'bndpairdb_byboundary');
geom.bndpairdb_byboundary=containers.Map(int64(-1),'foo');
geom.bndpairdb_byboundary.remove(int64(-1));

for cnt=1:length(pairs)
  pairname=pairs(cnt);
  pairobj=M.node.pair(pairname);
  assert(strcmp(pairobj.source.geom,geom.tag)); % Single geometry supported -- must match!

  if pairobj.source.dimension==2 % boundary pairs only    
    source=pairobj.source.inputEntities();
    dest=pairobj.destination.inputEntities();
    %geom.bndpairdb
    %pairname
    geom.bndpairdb(char(pairname))=[source dest];
    geom.bndpairdb_byboundary(int64(source))=char(pairname);
    geom.bndpairdb_byboundary(int64(dest))=char(pairname);
  end
end
