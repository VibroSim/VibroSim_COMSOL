function wrapper=WrapComsolNode(M,node,parent)

wrapper=ModelWrapper(M,char(node.tag));
wrapper.node=node;

if exist('parent','var')
  wrapper.parent=parent;
end

