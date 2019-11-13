%> Add a frequency domain step to the specified study, with the specified physicses enabled and active.
function step=StudyAddFrequencyStep(M,geom,study,tag,freqrange,varargin);
% function step=StudyAddFrequencyStep(M,geom,study,tag,physics1, physics2, ...);
step=StudyAddStep(M,geom,study,tag,'Frequency',varargin{:});

step.node.set('plist',freqrange);
