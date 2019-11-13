%> ADDMEASUREMENTTOEXPLOG Add Measurement to Experiment Log
%>   ADDMEASUREMENTTOEXPLOG(explog) Add measurement to specified experiment log
%>   This function appends a measurement element at the end of experiment log and increments the
%>   next measurement number in dc:summary field
function [explog] = AddMeasurementToExpLog(explog,using_datacollect)

    if ~exist('using_datacollect','var')
        using_datacollect=false;  % default using_datacollect to false
    end


    % Make Sure They Are Setting Ouput Argument
    if nargout ~= 1
        error('AddMeasurementToExpLog:ArgumentError', 'AddMeasurementToExpLog Output Must Be Assigned Back To The Experiment Log Struct');
    end

    % Prepare Access to Paramdb
    global paramdb;

    % Initialize if It Doesn't Exist
	if ~isstruct(paramdb) && ~isempty(paramdb)
		error('AddMeasurementToExpLog:ParamdbError', 'Local paramdb Variable Exists But It Is Not A Struct. Will not continue.');
	elseif ~isstruct(paramdb)
		paramdb = struct();
	end

	% get the current measurement number
	measnum = explog.nextmeasnum;

    % dc:measurement
    dc_measurement = explog.docNode.createElement('dc:measurement');

    % dc:measurement/dc:measnum
    dc_measnum = explog.docNode.createElement('dc:measnum');
    dc_measurement.appendChild(dc_measnum);
    dc_measnum_text = explog.docNode.createTextNode(num2str(measnum));
    dc_measnum.appendChild(dc_measnum_text);

    % dc:measurement/dc:recordmeastimestamp
    recordmeastimestamp = [datestr(now, 'YYYY-mm-DDTHH:MM:SS'),sprintf('%02d:00', -java.util.Date().getTimezoneOffset()/60)];
    dc_recordmeastimestamp = explog.docNode.createElement('dc:recordmeastimestamp');
    dc_measurement.appendChild(dc_recordmeastimestamp);
    dc_recordmeastimestamp_text = explog.docNode.createTextNode(recordmeastimestamp);
    dc_recordmeastimestamp.appendChild(dc_recordmeastimestamp_text);

    % clinfo/cltitle
    chx_clinfo = explog.docNode.createElement('chx:clinfo');
    dc_measurement.appendChild(chx_clinfo);
    chx_cltitle = explog.docNode.createElement('chx:cltitle');
    dc_measurement.appendChild(chx_cltitle);

    % Prepare Output
    measurement = struct();
    measurement.node = dc_measurement;
    measurement.measnum = measnum;
    measurement.timestamp = recordmeastimestamp;
    measurement.basenodes = struct();
    measurement.basenodes.dc_recordmeastimestamp = dc_recordmeastimestamp;
    measurement.basenodes.dc_recordmeastimestamp_text = dc_recordmeastimestamp_text;
    measurement.basenodes.chx_clinfo = chx_clinfo;
    measurement.basenodes.chx_cltitle = chx_cltitle;
    measurement.paramnodes = struct();

    % Loop over all fields
    for field = fields(paramdb)'
    	field = cell2mat(field);
    	tmpfield = explog.docNode.createElement(['dc:', field]);
    	dc_measurement.appendChild(tmpfield);
    	param = getfield(paramdb, field);
        if isfield(param, 'exctype')
            if strcmp(param.exctype, 'SWEEP')
                tmpfield.setAttribute('dcv:exctype', 'sweep');

                f0 = explog.docNode.createElement('dcv:f0');
                tmpfield.appendChild(f0);
                f0.setAttribute('dcv:units', param.f0.units);
                f0_text = explog.docNode.createTextNode(num2str(param.f0.value));
                f0.appendChild(f0_text);
                
                f1 = explog.docNode.createElement('dcv:f1');
                tmpfield.appendChild(f1);
                f1.setAttribute('dcv:units', param.f1.units);
                f1_text = explog.docNode.createTextNode(num2str(param.f1.value));
                f1.appendChild(f1_text);

                t0 = explog.docNode.createElement('dcv:t0');
                tmpfield.appendChild(t0);
                t0.setAttribute('dcv:units', param.t0.units);
                t0_text = explog.docNode.createTextNode(num2str(param.t0.value));
                t0.appendChild(t0_text);

                t1 = explog.docNode.createElement('dcv:t1');
                tmpfield.appendChild(t1);
                t1.setAttribute('dcv:units', param.t1.units);
                t1_text = explog.docNode.createTextNode(num2str(param.t1.value));
                t1.appendChild(t1_text);

                t2 = explog.docNode.createElement('dcv:t2');
                tmpfield.appendChild(t2);
                t2.setAttribute('dcv:units', param.t2.units);
                t2_text = explog.docNode.createTextNode(num2str(param.t2.value));
                t2.appendChild(t2_text);

                t3 = explog.docNode.createElement('dcv:t3');
                tmpfield.appendChild(t3);
                t3.setAttribute('dcv:units', param.t3.units);
                t3_text = explog.docNode.createTextNode(num2str(param.t3.value));
                t3.appendChild(t3_text);

                measurement.paramnodes = setfield(measurement.paramnodes, ['dc_', field], tmpfield);
            elseif strcmp(param.exctype, 'BURST')
                tmpfield.setAttribute('dcv:exctype', 'burst');

                f0 = explog.docNode.createElement('dcv:f0');
                tmpfield.appendChild(f0);
                f0.setAttribute('dcv:units', param.f0.units);
                f0_text = explog.docNode.createTextNode(num2str(param.f0.value));
                f0.appendChild(f0_text);

                t0 = explog.docNode.createElement('dcv:t0');
                tmpfield.appendChild(t0);
                t0.setAttribute('dcv:units', param.t0.units);
                t0_text = explog.docNode.createTextNode(num2str(param.t0.value));
                t0.appendChild(t0_text);

                t1 = explog.docNode.createElement('dcv:t1');
                tmpfield.appendChild(t1);
                t1.setAttribute('dcv:units', param.t1.units);
                t1_text = explog.docNode.createTextNode(num2str(param.t1.value));
                t1.appendChild(t1_text);

                t2 = explog.docNode.createElement('dcv:t2');
                tmpfield.appendChild(t2);
                t2.setAttribute('dcv:units', param.t2.units);
                t2_text = explog.docNode.createTextNode(num2str(param.t2.value));
                t2.appendChild(t2_text);

                t3 = explog.docNode.createElement('dcv:t3');
                tmpfield.appendChild(t3);
                t3.setAttribute('dcv:units', param.t3.units);
                t3_text = explog.docNode.createTextNode(num2str(param.t3.value));
                t3.appendChild(t3_text);

                measurement.paramnodes = setfield(measurement.paramnodes, ['dc_', field], tmpfield);
            else
                tmpfield.setAttribute('dcv:exctype', 'INVALID');
                measurement.paramnodes = setfield(measurement.paramnodes, ['dc_', field], tmpfield);
            end
    	elseif isstr(param.value)
    		tmpfield_text = explog.docNode.createTextNode(param.value);
            tmpfield.appendChild(tmpfield_text);
            measurement.paramnodes = setfield(measurement.paramnodes, ['dc_', field], tmpfield);
            measurement.paramnodes = setfield(measurement.paramnodes, ['dc_', field, '_text'], tmpfield_text);
    	else
    		tmpfield_text = explog.docNode.createTextNode(num2str(param.value));
    		if ~strcmp(param.units, '')
    			tmpfield.setAttribute('dcv:units', param.units)
    		end
            tmpfield.appendChild(tmpfield_text);
            measurement.paramnodes = setfield(measurement.paramnodes, ['dc_', field], tmpfield);
            measurement.paramnodes = setfield(measurement.paramnodes, ['dc_', field, '_text'], tmpfield_text);
    	end
    end

    % Write out datacollect parameter fields only if datacollect is being used
    if using_datacollect
        % Loop over all paramdb fields
        paramlist = dc_getparamlist();
        for q = 1:length(paramlist)
            field = cell2mat(paramlist(q,1));
            paramtype = cell2mat(paramlist(q,2));
            if (strcmp(paramtype, 'numericunitsvalue') || strcmp(paramtype, 'stringunitsvalue') || strcmp(paramtype, 'complexunitsvalue') || strcmp(paramtype, 'excitationparamsvalue'))
                tmpfield = explog.docNode.createElement(['dc:', field]);
                dc_measurement.appendChild(tmpfield);
                if strcmp(paramtype, 'stringvalue')
                    paramvalue = dc_param(field);
                    tmpfield_text = explog.docNode.createTextNode(paramvalue);
                    tmpfield.appendChild(tmpfield_text);
                    measurement.paramnodes = setfield(measurement.paramnodes, ['dc_', field], tmpfield);
                    measurement.paramnodes = setfield(measurement.paramnodes, ['dc_', field, '_text'], tmpfield_text);
                elseif strcmp(paramtype, 'numericunitsvalue') || strcmp(paramtype, 'complexunitsvalue')
                    [paramvalue, paramunits,~] = dc_param(field);
                    tmpfield_text =explog.docNode.createTextNode(num2str(paramvalue));
                    tmpfield.setAttribute('dcv:units', paramunits);
                    tmpfield.appendChild(tmpfield_text);
                    measurement.paramnodes = setfield(measurement.paramnodes, ['dc_', field], tmpfield);
                    measurement.paramnodes = setfield(measurement.paramnodes, ['dc_', field, '_text'], tmpfield_text);
                elseif strcmp(paramtype, 'excitationparamsvalue')
                    excstring = dc_param(field);
                    tokens = regexp(excstring, 'SWEEP Arb ([-+]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][-+]?\d+)?) Hz ([-+]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][-+]?\d+)?) Hz ([-+]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][-+]?\d+)?) s ([-+]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][-+]?\d+)?) s ([-+]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][-+]?\d+)?) s ([-+]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][-+]?\d+)?) s', 'tokens');
                    if ~isempty(tokens)
                        tmpfield.setAttribute('dcv:exctype', 'sweep');

                        f0 = explog.docNode.createElement('dcv:f0');
                        tmpfield.appendChild(f0);
                        f0.setAttribute('dcv:units', 'Hz');
                        f0_text = explog.docNode.createTextNode(tokens{1}{1});
                        f0.appendChild(f0_text);
                        
                        f1 = explog.docNode.createElement('dcv:f1');
                        tmpfield.appendChild(f1);
                        f1.setAttribute('dcv:units', 'Hz');
                        f1_text = explog.docNode.createTextNode(tokens{1}{2});
                        f1.appendChild(f1_text);

                        t0 = explog.docNode.createElement('dcv:t0');
                        tmpfield.appendChild(t0);
                        t0.setAttribute('dcv:units', 's');
                        t0_text = explog.docNode.createTextNode(tokens{1}{3});
                        t0.appendChild(t0_text);

                        t1 = explog.docNode.createElement('dcv:t1');
                        tmpfield.appendChild(t1);
                        t1.setAttribute('dcv:units', 's');
                        t1_text = explog.docNode.createTextNode(tokens{1}{4});
                        t1.appendChild(t1_text);

                        t2 = explog.docNode.createElement('dcv:t2');
                        tmpfield.appendChild(t2);
                        t2.setAttribute('dcv:units', 's');
                        t2_text = explog.docNode.createTextNode(tokens{1}{5});
                        t2.appendChild(t2_text);

                        t3 = explog.docNode.createElement('dcv:t3');
                        tmpfield.appendChild(t3);
                        t3.setAttribute('dcv:units', 's');
                        t3_text = explog.docNode.createTextNode(tokens{1}{6});
                        t3.appendChild(t3_text);

                        measurement.paramnodes = setfield(measurement.paramnodes, ['dc_', field], tmpfield);
                    else
                        tokens = regexp(excstring, 'BURST Arb ([-+]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][-+]?\d+)?) Hz ([-+]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][-+]?\d+)?) s ([-+]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][-+]?\d+)?) s ([-+]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][-+]?\d+)?) s ([-+]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][-+]?\d+)?) s', 'tokens');
                        if ~isempty(tokens)
                            tmpfield.setAttribute('dcv:exctype', 'burst');

                            f0 = explog.docNode.createElement('dcv:f0');
                            tmpfield.appendChild(f0);
                            f0.setAttribute('dcv:units', 'Hz');
                            f0_text = explog.docNode.createTextNode(tokens{1}{1});
                            f0.appendChild(f0_text);

                            t0 = explog.docNode.createElement('dcv:t0');
                            tmpfield.appendChild(t0);
                            t0.setAttribute('dcv:units', 's');
                            t0_text = explog.docNode.createTextNode(tokens{1}{2});
                            t0.appendChild(t0_text);

                            t1 = explog.docNode.createElement('dcv:t1');
                            tmpfield.appendChild(t1);
                            t1.setAttribute('dcv:units', 's');
                            t1_text = explog.docNode.createTextNode(tokens{1}{3});
                            t1.appendChild(t1_text);

                            t2 = explog.docNode.createElement('dcv:t2');
                            tmpfield.appendChild(t2);
                            t2.setAttribute('dcv:units', 's');
                            t2_text = explog.docNode.createTextNode(tokens{1}{4});
                            t2.appendChild(t2_text);

                            t3 = explog.docNode.createElement('dcv:t3');
                            tmpfield.appendChild(t3);
                            t3.setAttribute('dcv:units', 's');
                            t3_text = explog.docNode.createTextNode(tokens{1}{5});
                            t3.appendChild(t3_text);

                            measurement.paramnodes = setfield(measurement.paramnodes, ['dc_', field], tmpfield);
                        else
                            tmpfield.setAttribute('dcv:exctype', 'INVALID');
                        end
                    end
                end
            end
        end
    end

    % We've Made It This Far... Let's add it to the document
    explog.docRootNode.appendChild(dc_measurement);

    % Increment Measurement Number
    explog.nextmeasnum = explog.nextmeasnum + 1;

    % Add struct to explog struct
    explog.measurements = setfield(explog.measurements, ['meas', sprintf('%04d',measurement.measnum)], measurement);    

    % Write Experiment Log
    xmlwrite(explog.filename, explog.docNode);

end
