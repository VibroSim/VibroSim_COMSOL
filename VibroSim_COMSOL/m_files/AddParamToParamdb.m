%> ADDPARAMTOPARAMDB Adds A Parameter to A Local Paramdb Object
%>   ADDPARAMTOPARAMDB(M,field, string) Adds a String Value to A Local Paramdb
%>   ADDPARAMTOPARAMDB(M,field, number) Adds a Unitless Numeric Value to A Local Paramdb
%>   ADDPARAMTOPARAMDB(M,field, number, units) Adds a Numeric Value to A Local Paramdb
%> NOTE: The parameter M is requested for consistency and for future
%> compatibility should the local parameter database be shifted from
%> a global variable to existing within the wrapped model object M.
%> As of the current version it is not used and you can just pass []
function AddParamToParamdb(M,varargin)

    % Parse Input Values
    p = inputParser;
    p.addRequired('field', @isstr);
    p.addRequired('value', @(x) isstr(x) || isnumeric(x));
    p.addOptional('units', '', @isstr);
    p.parse(varargin{:});

    % Parsed Inputs
    field = p.Results.field;
    value = p.Results.value;
    units = p.Results.units;

	% Validate Input
	if isstr(value) && ~strcmp(units,'')
		error('AddParamToPraamdb:InputError', 'String Values Cannot Have Units');
	end

    % Prep Access to Global Paramdb
    global paramdb;

	% Initialize if It Doesn't Exist
	if ~isstruct(paramdb) && ~isempty(paramdb)
		error('AddParamToParamdb:ParamdbError', 'Local paramdb Variable Exists But It Is Not A Struct. Will not continue.');
	elseif ~isstruct(paramdb)
		paramdb = struct();
	end

	newvalue = struct();
	newvalue.value = value;
	newvalue.units = units;

	paramdb = setfield(paramdb, field, newvalue);

end
