%> LOGMSG Writes a log message to the console given provided log level
%> Log Levels:  1 - Errors/Always Displayed Messages
%>              2 - Warnings
%>              3 - Information
%>              4 - Debugging
%>   [] = LOGMSG(message) Displays Log Message with Log Level 3
%>   [] = LOGMSG(message, loglevel) Displays Log Message with Given Log Level
function [] = LogMsg(varargin)

    % Parse Input Values
    p = inputParser;
    p.addRequired('logmsg',  @isstr);
    validationFcn = @(x) isnumeric(x) && isscalar(x) && (x > 0) && (x < 5) && mod(x,1)==0;
    p.addOptional('loglevel', 3, validationFcn);
    p.parse(varargin{:});

    % Parsed Inputs
    logmsg = p.Results.logmsg;
    loglevel = p.Results.loglevel;

    % Get Global Log Level
    %global CmdLineParams;

    % There is a strange bug associated with the global parameter disappearing
    % Reset to default if it does
    %try
    %    globalloglevel = CmdLineParams.Results.LogLevel;
    %catch
        globalloglevel = 1;
    %end

    % Verify if we should output
    if globalloglevel >= loglevel
        % Output Message
        fprintf([logmsg, '\n']);

        % Flush Output Buffer
        drawnow();
    end

end
