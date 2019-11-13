function [name] = CreateParameter(varargin)
% CREATEPARAMETER Creates a Model Parameter
%   [name] = CREATEPARAMETER(M, name, value) Creates a Parameter in the Given Model

    % Parse Input Values
    p = inputParser;
    p.addRequired('M', @(x) isa(x,'ModelWrapper'))
    p.addRequired('name', @isstr);
    p.addRequired('value');
    p.parse(varargin{:});

    % Parsed Inputs
    M = p.Results.M;
    name = p.Results.name;
    value = p.Results.value;

    % Initialize access to our list of override parameters
    global overrideparamlist;

    % Initialize if It Doesn't Exist
    if ~isstruct(overrideparamlist) && ~isempty(overrideparamlist)
        error('CreateOverrideParmeter:ParamListError', 'Local variable overrideparamlist exists but is not a struct.  Will not continue.');
    elseif ~isstruct(overrideparamlist)
        overrideparamlist = struct();
    end

    % Check to see if an override exists
    if isfield(overrideparamlist, name)
        % Make Sure We Haven't Tried Setting It Already With CreateParameter
        if getfield(overrideparamlist, name) == 0
            % Double Check to Make Sure the Parameter Does Exist
            try
	        FindWrappedObject(M, ['param_' name ]);
                ValidateUniqueTag(name, M.node.param.varnames, false);

                % We Shouldn't Get to This Point Because An Exception Should Have Been Thrown
                error('CreateOverrideParmeter:ParamOverrideError', ['The parameter ''', name, ''' has been marked as overwritten, but does not exist.']);
            catch err
                if strcmp(err.identifier, 'ValidateUniqueTag:DuplicateTagException')
                    % Let the User Know
                    LogMsg(['Parameter ''', name,''' overridden - Ignoring call to CreateParameter']);
                    % Keep Track of the Fact We've Called CreateParameter already
                    overrideparamlist = setfield(overrideparamlist, name, 1);
                    % Ignore attempt to set value and return
                    % name is still set, so the parameter name is still returned.

                    return
                else
                    % Something is wrong... rethrow the exception
                    rethrow(err);
                end
            end
        % We've already called create parameter on an overridden parameter
        else
            error('CreateParameter:DuplicateTagException', 'CreateParameter being called again on an overridden parameter')
        end
    else
        % Not an overridden parameter - continue as normal

        paramobj=ModelWrapper(M, ['param_' name ]);
	paramobj.name=name;

        % Set the Value
        M.node.param.set(name, value);

    end

end
