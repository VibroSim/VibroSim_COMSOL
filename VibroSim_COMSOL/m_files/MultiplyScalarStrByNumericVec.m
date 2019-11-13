%> function product = MultiplyScalarStrByNumericVec(str,vec)
%> This function gives the cell string array result of
%> multiplying a scalar value represented as a string str
%> by each component of numeric vector vec.
function product = MultiplyScalarStrByNumericVec(str,vec)

product={};
for cnt=1:3
  product{cnt}=['(' str ')*' num2str(vec(cnt),18)];
end
