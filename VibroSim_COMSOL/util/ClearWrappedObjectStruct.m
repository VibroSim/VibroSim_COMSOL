function ClearWrappedObjectStruct(structure_to_clear)

  names=fieldnames(structure_to_clear);
  for namecnt=1:length(names)
    if strcmp(class(structure_to_clear.(names{namecnt})),'ModelWrapper')
      ClearWrappedObjectStruct(structure_to_clear.(names{namecnt}));
    elseif length(strfind(class(structure_to_clear.(names{namecnt})),'comsol')) > 0
      % How to destroy comsol object???
    end
  end

		      
