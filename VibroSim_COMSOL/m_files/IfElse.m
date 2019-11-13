function res=IfElse(condition,if_fcn,else_fcn)

res=[];

if condition
  res=if_fcn();
else
  if exist('else_fcn','var')
    res=else_fcn();
  end
end
