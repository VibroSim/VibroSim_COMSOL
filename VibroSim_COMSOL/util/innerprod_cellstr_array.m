function iprod=innerprod_cellstr_array(vec1,vec2)

  len=length(vec1);
  assert(len==length(vec2));

  iprod='0.0';

  for cnt=1:len
    iprod=[ iprod ' + (' vec1{cnt} ')*(' vec2{cnt} ')' ];
  end
  
