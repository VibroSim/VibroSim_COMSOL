function entities=GetNamedSelectionEntities(M,name);
selection=mphgetselection(M.node.selection(name));
entities=selection.entities;
