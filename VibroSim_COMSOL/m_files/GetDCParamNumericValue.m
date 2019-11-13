%> GETDCPARAMNUMERICVALUE Fetches a Datacollect Numeric Value
%>   [valuestruct] = GETDCPARAMNUMERICVALUE(M,field, [units]) Fetches DC Param in Specified Units
function [valuestruct] = GetDCParamNumericValue(M,varargin)

    % Default Values
    defaultUnits = '';

    % Parse Input Values
    p = inputParser;
    p.addRequired('field', @isstr);
    p.addOptional('units', defaultUnits, @isstr);
    p.parse(varargin{:});

    % Parsed Inputs
    field = p.Results.field;
    units = p.Results.units;

    % Prep Output
    valuestruct = struct();
    valuestruct.paramname = field;

	global paramdb;

    % Check for paramdb global variable - use it instead
    if isstruct(paramdb)

        % Make Sure The Field Doesn't Exist In Datacollect
		try
			test = dc_param(field);
		catch err
			% Do Nothing
		end
		
		if exist('test') && ~any(strfind(test, 'ERROR ')) && isfield(paramdb,field)
			error('GetDCParamNumericValue:DatacollectError', ['Field ''', field, ''' exists in a local paramdb and in Datacollect.  Will not continue.']);
		end

		if isfield(paramdb, field)
			paramdbfield = getfield(paramdb, field);
			valuestruct.raw_value = paramdbfield.value; origval = paramdbfield.value;
			valuestruct.raw_units = paramdbfield.units; origunits = paramdbfield.units;
			valuestruct.raw_string = [num2str(paramdbfield.value), ' [', paramdbfield.units, ']']; origstring = [num2str(paramdbfield.value), ' [', paramdbfield.units, ']'];
		else
			% Let's see if it's in Datacollect
			try
				test = dc_param(field);
				if (strfind(test, 'ERROR '))
			   		error('GetDCParamNumericValue:DatacollectError', test);
				end

				% Fetch Value
				[origval, origunits, origstring] = dc_param(field);
				valuestruct.raw_value = origval;
				valuestruct.raw_units = origunits;
				valuestruct.raw_repr = origstring;
			catch err
				error('GetDCParamNumericValue:DatacollectError', ['Unable to Connect to Datacollect2 and ''', field, ''' does not exist in the local paramdb.']);
			end
		end		

	else

		% Check to Be Sure it Exists
		try
			test = dc_param(field);
		catch err
			error('GetDCParamNumericValue:DatacollectError', 'Unable to Connect to Datacollect2 and No paramdb Variable Exists in the Workspace.  Be sure paramdb is declared globally.');
		end
		if (strfind(test, 'ERROR '))
		    error('GetDCParamNumericValue:DatacollectError', test);
		end

		% Fetch Value
		[origval, origunits, origstring] = dc_param(field);
		valuestruct.raw_value = origval;
		valuestruct.raw_units = origunits;
		valuestruct.raw_repr = origstring;
    end

    if ~isempty(units)
        %dcuc_init;
        %dcuc_push;
        %[newval,newstr]=dcuc_evalinunits([num2str(origval), ' ', origunits], units);
        %dcuc_pop;
        %valuestruct.value = newval;
        %valuestruct.units = units;
        %valuestruct.repr = newstr;
        %origunits
	%units
	%[num2str(origval,18),'[',origunits,']']
        if strcmp(origunits,units)
	  % identical unit match
	  newval=origval;
	else
	  % NOTE: If the call to mphevaluate fails with 'Inconsistent units'
	  % it may be a COMSOL 5.0 bug whereby mphevaluate fails if you 
	  % specify complicated output units. 
	  % 
	  % As an interim workaround we try to be consistent with units
	  % (above strcmp()) so mphevaluate never gets called. 
	  %M.node
	  %[num2str(origval,18),'[',origunits,']']
          %units
          newval=mphevaluate(M.node,[num2str(origval,18),'[',origunits,']'],units);
	end
	valuestruct.value=newval;
	valuestruct.units=units;
	valuestruct.repr =[num2str(newval,18) '[' units ']'];
      
      
    else
        valuestruct.value = origval;
        valuestruct.units = origunits;
        valuestruct.repr = strrep(origstring, '[]', '');
    end

end
