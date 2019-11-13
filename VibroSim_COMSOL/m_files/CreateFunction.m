%> CREATEFUNCTION Creates a Function
%
%> type can be 'Interpolation', 'Analytic', 'Rectangle', etc
function [func] = CreateFunction(M,tag,type)
% CREATEFUNCTION Creates a Function
%   [func] = CREATEFUNCTION(M, tag, type) Creates Function of the given type
%   type can be 'Interpolation', 'Analytic', 'Rectangle', etc


  func=ModelWrapper(M,tag,M.node.func);
  func.node=M.node.func.create(func.tag,type);
  
