%> GETDCPARAMSTRINGVALUE Fetches a Datacollect Numeric Value
%>   [valuestruct] = GETDCPARAMSTRINGVALUE(field) Fetches DC Param
function [valuestruct] = GetDCParamStringValue(M,varargin)

    % Parse Input Values
    p = inputParser;
    p.addRequired('field', @isstr);
    p.parse(varargin{:});

    % Parsed Inputs
    field = p.Results.field;

    % Prep Output
    valuestruct = struct();
    valuestruct.paramname = field;

    % Prep Access to Global Paramdb
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
			error('GetDCParamStringValue:DatacollectError', ['Field ''', field, ''' exists in a local paramdb and in Datacollect.  Will not continue.']);
		end

		if isfield(paramdb, field)
			paramdbfield = getfield(paramdb, field);
			valuestruct.raw_value = paramdbfield.value; 
			origval = paramdbfield.value;
			valuestruct.raw_units = '';
			valuestruct.raw_repr = paramdbfield.value;
		else
			% Let's see if it's in Datacollect
			try
				test = dc_param(field);
				if (strfind(test, 'ERROR '))
			   		error('GetDCParamStringValue:DatacollectError', test);
				end

				% Fetch Value
				origval = dc_param(field);
				valuestruct.raw_value = origval;
				valuestruct.raw_units = '';
				valuestruct.raw_repr = origval;
			catch err
				error('GetDCParamStringValue:DatacollectError', ['Unable to Connect to Datacollect2 and ''', field, ''' does not exist in the local paramdb.']);
			end
		end		

	else

		% Check to Be Sure it Exists
		try
			test = dc_param(field);
		catch err
			error('GetDCParamStringValue:DatacollectError', 'Unable to Connect to Datacollect2 and No paramdb Variable Exists in the Workspace.  Be sure paramdb is declared globally.');
		end
		if (strfind(test, 'ERROR '))
		    error('GetDCParamStringValue:DatacollectError', test);
		end

		% Fetch Value
		origval = dc_param(field);
		valuestruct.raw_value = origval;
		valuestruct.raw_units = '';
		valuestruct.raw_repr = origval;
    end


    valuestruct.value = origval;
    valuestruct.units = '';
    valuestruct.repr = origval;

end
