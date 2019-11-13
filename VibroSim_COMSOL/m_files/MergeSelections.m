function selections=MergeSelections(M,geom,object,selection_getter_ca)

selections=[];
for cnt=1:length(selection_getter_ca)
  selections=union(selections,selection_getter_ca{cnt}(M,geom,object));
end
