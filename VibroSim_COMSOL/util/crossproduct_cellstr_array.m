function xprod=crossproduct_cellstr_array(vec1,vec2)

  assert(length(vec1)==3);
  assert(length(vec2)==3);


  % Cross product:
  % |  xhat   yhat   zhat  |
  % |  x1     y1     z1    |
  % |  x2     y2     z2    |
  % =   xhat(y1 z2 - z1 y2)
  %   + yhat(z1 x2 - x1 z2)
  %   + zhat(x1 y2 - y1 x2) 
  
  xprod={
	 sub_cellstrs( mul_cellstrs(vec1{2},vec2{3}), mul_cellstrs(vec1{3},vec2{2}) ), ...
	 sub_cellstrs( mul_cellstrs(vec1{3},vec2{1}), mul_cellstrs(vec1{1},vec2{3}) ), ...
	 sub_cellstrs( mul_cellstrs(vec1{1},vec2{2}), mul_cellstrs(vec1{2},vec2{1}) ) };

