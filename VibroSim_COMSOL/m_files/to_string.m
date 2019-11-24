%> function str=to_string(inp, default_units)
%> Convert provided input, which could be a number or a string representation
%> of a number into a string representation of a number. If the input is a number
%> attach the default_units (optional parameter), if given
function str=to_string(inp, default_units)

if isa(inp,'double') || isa(inp,'int64') || isa(inp,'int32') || isa(inp,'uint32') || isa(inp,'uint64')
  if exist('default_units','var')
    str=[ num2str(inp,18) '[' default_units ']' ];
  else
    str=num2str(inp,18);
  end
elseif isa(inp,'java.lang.String')
  str=inp.toCharArray';
else
  str=inp;
end
