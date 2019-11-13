function diff=sub_cellstr_array(vec1,vec2)

  len=length(vec1);
  assert(len==length(vec2));

  diff={};

  for cnt=1:len
    diff{cnt}=[ '(' vec1{cnt} ')-(' vec2{cnt} ')' ];
  end
  
