%> CREATEEXPERIMENTLOG Create An Experiment Log
%>   CREATEEXPERIMENTLOG(filename,reldest,summarystruct) Creates An Experiment Log with Specified Filename
%>   Parameters:
%>   summarystruct - (struct) structure with all the (fieldname,value) pairs to add to the summary node of experiment log
function [explog] = CreateExperimentLog(filename,summarystruct)

	% File Must Not Exist
	if exist(filename, 'file') ~= 0
		error('CreateExperimentLog:InputError', ['File "', filename, '" exists - Will not overwrite!'])
	end

	% File Must End in .xlg
	if ~strcmp(filename(end-3:end), '.xlg')
		error('CreateExperimentLog:InputError', ['File "', filename, '" must end with .xlg'])
	end

    [fullpath, basefilename, ext] = fileparts(filename);

    % create reldest field if it doesn't exist in the summary struct
    if ~isfield(summarystruct,'reldest')
        reldest = [basefilename, '_files'];
        setfield(summarystruct,'reldest',reldest);
    else
        reldest = getfield(summarystruct,'reldest');
    end

    % Create reldest directory, if reldest exists, warn the user that directory exists
    [status,message,messageid] = mkdir(fullfile(fullpath,reldest));
    if ~isempty(message)
        LogMsg(message,1);
        end

    % Set Up XML Document for the xlg file
    docNode = com.mathworks.xml.XMLUtils.createDocument('dc:experiment');
    docRootNode = docNode.getDocumentElement;
    docRootNode.setAttribute('xmlns:dbvar', 'http://thermal.cnde.iastate.edu/databrowse/variable');
    docRootNode.setAttribute('xmlns:sp', 'http://thermal.cnde.iastate.edu/spatial');
    docRootNode.setAttribute('xmlns:dc', 'http://thermal.cnde.iastate.edu/datacollect');
    docRootNode.setAttribute('xmlns:dcv', 'http://thermal.cnde.iastate.edu/dcvalue');
    docRootNode.setAttribute('xmlns:dcp', 'http://thermal.cnde.iastate.edu/datacollect/provenance');
    docRootNode.setAttribute('xmlns:chx', 'http://thermal.cnde.iastate.edu/checklist');
    docRootNode.setAttribute('xmlns:dbdir', 'http://thermal.cnde.iastate.edu/databrowse/dir');
    docRootNode.setAttribute('xmlns','http://thermal.cnde.iastate.edu/datacollect');

    % Create a summary node at the top of experiment log
    dc_summary = docNode.createElement('dc:summary');
    docRootNode.appendChild(dc_summary);

    % dc:summary/dc:date
    dc_date = docNode.createElement('dc:date');
    dc_summary.appendChild(dc_date);
    dc_date_text = docNode.createTextNode(datestr(now,29)); % ISO format date
    dc_date.appendChild(dc_date_text);

    % dc:summary/dc:hostname
    hostname = char(java.net.InetAddress.getLocalHost.getHostName);
    dc_hostname = docNode.createElement('dc:hostname');
    dc_summary.appendChild(dc_hostname);
    dc_hostname_text = docNode.createTextNode(hostname);
    dc_hostname.appendChild(dc_hostname_text);

    % dc:summary/dc:nextmeasnum
    nextmeasnum = 0;
    dc_nextmeasnum = docNode.createElement('dc:nextmeasnum');
    dc_summary.appendChild(dc_nextmeasnum);
    dc_nextmeasnum_text = docNode.createTextNode(num2str(nextmeasnum));
    dc_nextmeasnum.appendChild(dc_nextmeasnum_text);

    % dc:summary/dc:plans
    dc_plans = docNode.createElement('dc:plans');
    dc_summary.appendChild(dc_plans);

    % dc:summary/dc:checklists
    dc_checklists = docNode.createElement('dc:checklists');
    dc_summary.appendChild(dc_checklists);

    if exist('summarystruct','var')
        % Create all the other fields specified by the summarystruct
        summaryentries = fieldnames(summarystruct)';
        for i = 1:length(summaryentries)
            % dc:summary/dc:<fieldname>
            element = docNode.createElement(sprintf('dc:%s',char(summaryentries(i))));
            dc_summary.appendChild(element);
            elementtext = docNode.createTextNode(getfield(summarystruct,char(summaryentries(i))));
            element.appendChild(elementtext);
        end
    end

    % Prepare Output
    explog = struct();
    explog.filename = filename;
    explog.nextmeasnum = nextmeasnum;
    explog.docNode = docNode;
    explog.docRootNode = docRootNode;
    explog.summary = struct();
    explog.summary.node = dc_summary;
    explog.summary.dc_date = dc_date;
    explog.summary.dc_date_text = dc_date_text;
    explog.summary.dc_hostname = dc_hostname;
    explog.summary.dc_hostname_text = dc_hostname_text;
    explog.summary.dc_nextmeasnum = dc_nextmeasnum;
    explog.summary.dc_nextmeasnum_text = dc_nextmeasnum_text;
    explog.summary.dc_plans = dc_plans;
    explog.summary.dc_checklists = dc_checklists;
    if exist('summarystruct','var')
        % add all the other summary fields from summarystruct 
        summaryentries = fieldnames(summarystruct)';
        for i = 1:length(summaryentries)
            setfield(explog.summary,sprintf('dc_%s',char(summaryentries(i))),getfield(summarystruct,char(summaryentries(i))));
        end
    end
    % create an empty struct for measurements
    explog.measurements = struct();

    % Write Experiment Log
    xmlwrite(explog.filename, explog.docNode);

end
