function magnitude=magnitude_cellstr_array(array)
% function magnitude=magnitude_cellstr_array(array)
%
% Calculate the vector magnitude of a vector represented
% as a cell array of strings

% Initialize magnitude-squared to 0 
magnitudesq='0.0';

% Accumulate the absolute square of each element  
for cnt=1:length(array)
  magnitudesq=[ magnitudesq ' + abs(' array{cnt} ')^2' ];
end

% return the square root. 
magnitude=[ 'sqrt(' magnitudesq ')' ];
