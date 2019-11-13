%> Obtains the named COMSOL parameter corresponding to the named DC parameter.
%> (The names are always the same, but this function makes sure that the
%> parameter has a COMSOL definitition and is initialized to the current dc_param
%> value)
function[name]=ObtainDCParameter(M,name,units)

try
  comsolparamobj=FindWrappedObject(M,[ 'param_' name ]);
end

if ~exist('comsolparamobj','var')
  % Param does not exist... create it...

  % Extract current value
  if exist('units','var')
    DCValue=GetDCParamNumericValue(M,name,units);
    CreateParameter(M,name,DCValue.repr);
  else
    DCValue=GetDCParamStringValue(M,name);
    CreateParameter(M,name,DCValue.value);
  end


  % CreateParameter just returns the name, so to find the object
  % we have to use FindWrappedObject()
  comsolparamobj=FindWrappedObject(M,[ 'param_' name ]);

  if exist('units','var')
    % Give comsolparamobj a units property if we have units
    addprop(comsolparamobj,'units');
    comsolparamobj.units=units;
  end

else
  % Parameter does exist, in comsolparamobj
  % check that units existence and value match
  if exist('units','var')
    assert(isprop(comsolparamobj,'units'))
    if ~strcmp(comsolparamobj.units,units)
      error(sprintf('ObtainDCParameter unit mismatch: ''%s'' vs. ''%s''',comsolparamobj.units,units))
    end
  else
    assert(~isprop(comsolparamobj,'units'))
  end
end


% name returns automatically
