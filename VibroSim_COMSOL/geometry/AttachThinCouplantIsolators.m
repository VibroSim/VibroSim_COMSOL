function specimen=AttachThinCouplantIsolators(M,geom, specimen, couplant_coord, isolator_coords)
% function specimen=AttachThinCouplantIsolators(M,geom, specimen, couplant_coord, isolator_coords)
% Attach thin couplants and isolators to the given specimen 
% at the specified coordinates. specimen.couplant will store the couplant object
% and specimen.isolators will be a cell array containing the isolator objects. 
% Creates circular isolators so angle is irrelevant
% 
% couplant_coord should be a single row-vector
% isolator_coords should be a matrix -- series of row-vectors
%
% each row should be x, y, z, angle. Set angle to NaN to obtain a circular
% isolator



% Add isolators

addprop(specimen,'isolators');

specimen.isolators={};

for cnt=1:size(isolator_coords,1)
  if isnan(isolator_coords(cnt,4))
    % circular isolator
    specimen.isolators{cnt}=BuildLaterWithNormal(M,geom,sprintf('%s_isolator%.2d',specimen.tag,cnt), ...
  				             ... % position
					         isolator_coords(cnt,1:3), ... 
				             ... % params provided with build (including 
				             ... % geometrically extracted normal)	
					         @(M,geom,object,pos,normal) ... 
				             ... % Function to run to build the isolator
					         BuildThinIsolator(M,geom,object, specimen, ...
								   'Circle',pos,normal));
  else
    % rectangular isolator
    specimen.isolators{cnt}=BuildLaterWithNormal(M,geom,sprintf('%s_isolator%.2d',specimen.tag,cnt), ...
  				             ... % position
					         isolator_coords(cnt,1:3), ... 
				             ... % params provided with build (including 
				             ... % geometrically extracted normal)	
					         @(M,geom,object,pos,normal) ... 
				             ... % Function to run to build the isolator
					         BuildThinIsolator(M,geom,object,specimen, ...
						               'Rectangle',pos,normal,isolator_coords(cnt,4)));
  end
end

% Add transducer/couplant
addprop(specimen,'couplant');

if isnan(couplant_coord(4))
  % circular couplant						
  specimen.couplant=BuildLaterWithNormal(M,geom,[ specimen.tag '_couplant' ], ...
				         couplant_coord(1:3), ...
				         @(M,geom,object,pos,normal) ...
				         BuildThinCouplant(M,geom,object,specimen,'Circle', pos, normal));
else
  % rectangular couplant						
  specimen.couplant=BuildLaterWithNormal(M,geom,[ specimen.tag '_couplant' ], ...
				         couplant_coord(1:3), ...
				         @(M,geom,object,pos,normal) ...
				         BuildThinCouplant(M,geom,object,specimen,'Rectangle', pos, normal,couplant_coord(4)));
end

