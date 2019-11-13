function sum=add_cellstr_array(vec1,vec2)

  len=length(vec1);
  assert(len==length(vec2));

  sum={};

  for cnt=1:len
    sum{cnt}=[ '(' vec1{cnt} ')+(' vec2{cnt} ')' ];
  end

