%> GETDCPARAMSTRINGVALUE Fetches a Datacollect Exciation Params Value
%>   [valuestruct] = GETDCPARAMEXCITATIONVALUE(field) Fetches DC Param
function [valuestruct] = GetDCParamExcitationValue(M,varargin)

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
			error('GetDCParamExcitationValue:DatacollectError', ['Field ''', field, ''' exists in a local paramdb and in Datacollect.  Will not continue.']);
		end

		if isfield(paramdb, field)
			paramdbfield = getfield(paramdb, field);
			valuestruct.raw_value = paramdbfield; 
			origval = paramdbfield;
			valuestruct.raw_units = '';
			valuestruct.raw_repr = paramdbfield;
			valuestruct.value = paramdbfield;
			valuestruct.units = '';
			% Build repr string
			if strcmp(paramdbfield.exctype, 'BURST')
				valuestruct.repr = ['BURST Arb ', num2str(paramdbfield.f0.value), ' ', paramdbfield.f0.units, ' ', num2str(paramdbfield.t0.value), ' ', paramdbfield.t0.units, ' ', num2str(paramdbfield.t1.value), ' ', paramdbfield.t1.units, ' ', num2str(paramdbfield.t2.value), ' ', paramdbfield.t2.units, ' ', num2str(paramdbfield.t3.value), ' ', paramdbfield.t3.units];
				valuestruct.raw_repr = valuestruct.repr;
			elseif strcmp(paramdbfield.exctype, 'SWEEP')
				valuestruct.repr = ['SWEEP Arb ', num2str(paramdbfield.f0.value), ' ', paramdbfield.f0.units, ' ', num2str(paramdbfield.f1.value), ' ', paramdbfield.f1.units, ' ', num2str(paramdbfield.t0.value), ' ', paramdbfield.t0.units, ' ', num2str(paramdbfield.t1.value), ' ', paramdbfield.t1.units, ' ', num2str(paramdbfield.t2.value), ' ', paramdbfield.t2.units, ' ', num2str(paramdbfield.t3.value), ' ', paramdbfield.t3.units];
				valuestruct.raw_repr = valuestruct.repr;
			end

			% Return without continuing
			return
		else
			% Let's see if it's in Datacollect
			try
				test = dc_param(field);
				if (strfind(test, 'ERROR '))
			   		error('GetDCParamExcitationValue:DatacollectError', test);
				end

				% Fetch Value
				origval = dc_param(field);
				valuestruct.raw_value = origval;
				valuestruct.raw_units = '';
				valuestruct.raw_repr = origval;
			catch err
				error('GetDCParamNumericValue:DatacollectError', ['Unable to Connect to Datacollect2 and ''', field, ''' does not exist in the local paramdb.']);
			end
		end		

	else

		% Check to Be Sure it Exists
		try
			test = dc_param(field);
		catch err
			error('GetDCParamExcitationValue:DatacollectError', 'Unable to Connect to Datacollect2 and No paramdb Variable Exists in the Workspace.  Be sure paramdb is declared globally.');
		end
		if (strfind(test, 'ERROR '))
		    error('GetDCParamExcitationValue:DatacollectError', test);
		end

		% Fetch Value
		origval = dc_param(field);
		valuestruct.raw_value = origval;
		valuestruct.raw_units = '';
		valuestruct.raw_repr = origval;
    end

    excstring = valuestruct.raw_value;

    outstruct = struct();

    tokens = regexp(excstring, 'SWEEP Arb ([-+]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][-+]?\d+)?) Hz ([-+]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][-+]?\d+)?) Hz ([-+]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][-+]?\d+)?) s ([-+]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][-+]?\d+)?) s ([-+]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][-+]?\d+)?) s ([-+]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][-+]?\d+)?) s', 'tokens');
    if ~isempty(tokens)
    	outstruct.exctype = 'SWEEP';
		outstruct.f0 = struct();
    	outstruct.f0.value = str2num(tokens{1}{1});
    	outstruct.f0.units = 'Hz';
    	outstruct.f0.repr = [tokens{1}{1}, '[Hz]'];
    	outstruct.f1 = struct();
    	outstruct.f1.value = str2num(tokens{1}{2});
    	outstruct.f1.units = 'Hz';
    	outstruct.f1.repr = [tokens{1}{2}, '[Hz]'];
    	outstruct.t0 = struct();
    	outstruct.t0.value = str2num(tokens{1}{3});
    	outstruct.t0.units = 's';
    	outstruct.t0.repr = [tokens{1}{3}, '[s]'];
    	outstruct.t1 = struct();
    	outstruct.t1.value = str2num(tokens{1}{4});
    	outstruct.t1.units = 's';
    	outstruct.t1.repr = [tokens{1}{4}, '[s]'];
    	outstruct.t2 = struct();
    	outstruct.t2.value = str2num(tokens{1}{5});
    	outstruct.t2.units = 's';
    	outstruct.t2.repr = [tokens{1}{5}, '[s]'];
    	outstruct.t3 = struct();
    	outstruct.t3.value = str2num(tokens{1}{6});
    	outstruct.t3.units = 's';
    	outstruct.t3.repr = [tokens{1}{6}, '[s]'];
    else
    	tokens = regexp(excstring, 'BURST Arb ([-+]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][-+]?\d+)?) Hz ([-+]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][-+]?\d+)?) s ([-+]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][-+]?\d+)?) s ([-+]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][-+]?\d+)?) s ([-+]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][-+]?\d+)?) s', 'tokens');
  		if ~isempty(tokens)
  			outstruct.exctype = 'BURST';
			outstruct.f0 = struct();
	    	outstruct.f0.value = str2num(tokens{1}{1});
	    	outstruct.f0.units = 'Hz';
	    	outstruct.f0.repr = [tokens{1}{1}, '[Hz]'];
	    	outstruct.t0 = struct();
	    	outstruct.t0.value = str2num(tokens{1}{2});
	    	outstruct.t0.units = 's';
	    	outstruct.t0.repr = [tokens{1}{2}, '[s]'];
	    	outstruct.t1 = struct();
	    	outstruct.t1.value = str2num(tokens{1}{3});
	    	outstruct.t1.units = 's';
	    	outstruct.t1.repr = [tokens{1}{3}, '[s]'];
	    	outstruct.t2 = struct();
	    	outstruct.t2.value = str2num(tokens{1}{4});
	    	outstruct.t2.units = 's';
	    	outstruct.t2.repr = [tokens{1}{4}, '[s]'];
	    	outstruct.t3 = struct();
	    	outstruct.t3.value = str2num(tokens{1}{5});
	    	outstruct.t3.units = 's';
	    	outstruct.t3.repr = [tokens{1}{5}, '[s]'];
  		else
  			error('GetDCParamExcitationValue:InvalidExcitationString', ['Invalid Excitation String ''', excstring, '''']);
  		end
  	end

    valuestruct.value = outstruct;
    valuestruct.units = '';
    valuestruct.repr = origval;

end
