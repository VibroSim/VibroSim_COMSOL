function unitvec=normalize_cellstr_array(array)

magnitude=magnitude_cellstr_array(array);

unitvec={};

for cnt=1:length(array)
  unitvec{cnt}=[ '(' array{cnt} ')/(' magnitude ')' ];
end
