%> Convert a matrix of java strings to a regular matlab matrix
function nummat = StringMatrix2Numeric(strmat)

nummat=[];

nrows=prod(size(strmat));
if nrows > 0
  ncols=prod(size(strmat(1)));

  nummat=zeros(nrows,ncols);
  for row=1:nrows
    for col=1:ncols
      nummat(row,col)=str2num(strmat(row,col));
    end
  end
end
