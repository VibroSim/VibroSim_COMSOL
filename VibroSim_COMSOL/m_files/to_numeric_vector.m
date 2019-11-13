%> function numvec = to_numeric_vector(M,vec,unit)
%> Convert provided vector vec, which may already  be numeric, or
%> may be a cell string array, into a numeric vector. unit is an
%> optional parameter (should NOT have brackets) that is passed to
%> mphevaluate if given.
%>
%> This calls mphevaluate to determine values.  Please note that this
%> fixes parameters, etc. and depending on how complete the model
%> is and what has been instantiated, some values may not
%> be available.
%>
%> returns a row-vector
function numvec = to_numeric_vector(M,vec,unit)

  if strcmp(class(vec),'cell')
    % Evaluate cell string array
    numvec=[];
    for cnt2=1:3
      %vec{cnt2}

      % mphevaluate fails on a unit error if you give it just plain '0'
      % so we check for that case hand handle it manually
      if prod(size(str2num(vec{cnt2}))) > 0 & str2num(vec{cnt2})==0
	numvec(1,cnt2)=0;
      else
	if exist('unit','var')
	  %vec{cnt2}
	  %unit
	  numvec(1,cnt2)=mphevaluate(M.node,vec{cnt2},unit);
	else
	  numvec(1,cnt2)=mphevaluate(M.node,vec{cnt2});
	end
      end
    end
  elseif size(vec,1) > 1
    % convert column vector to row vector
    numvec=vec.';
  else
    numvec=vec;
  end
