function res=negate_cellstr_array(vec1)

  len=length(vec1);

  res={};

  for cnt=1:len
    res{cnt}=[ '-(' vec1{cnt} ')' ];
  end
