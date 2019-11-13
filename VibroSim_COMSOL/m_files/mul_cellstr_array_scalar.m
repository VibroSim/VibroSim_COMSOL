function prod=mul_cellstr_array_scalar(vec,scalar)

  len=length(vec);

  sum={};

  for cnt=1:len
    prod{cnt}=[ '(' vec{cnt} ')*(' to_string(scalar) ')' ];
  end
  
