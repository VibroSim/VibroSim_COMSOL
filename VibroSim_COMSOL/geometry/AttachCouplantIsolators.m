%> function specimen=AttachCouplantIsolators(M,geom,tag, maincreationfunc, couplant_coord, isolator_coords,followupfunc)
%> Use maincreationfunc to create the specimen; then attach couplants and isolators to it
%> at the specified coordinates. specimen.couplant will store the couplant object
%> and specimen.isolators will be a cell array containing the isolator objects.
%> Creates circular isolators so angle is irrelevant
%>
%> maincreationfunc is called as specimen=maincreationfunc(M,geom,tag)
%> couplant_coord should be a single row-vector
%> isolator_coords should be a matrix -- series of row-vectors
%>
%> each row should be x, y, z, angle. Set angle to NaN to obtain a circular
%> isolator
%>
%> followupfunc (optional), if provided, will be called as
%> followupfunc(M,geom,tag,specimen) once the couplant and isolators have been
%> defined. Note that they will not have actually been created (they won't be
%> created until after the getnormals study), but they can still be referenced.
%>
%> Note that for now, complete boundary conditions are only set up for the frequency
%> study, as there is not (yet) any standard means to specify the static
%> boundary conditions (you could do in manually through followupfunc, though)
function specimen=AttachCouplantIsolators(M,geom,tag, maincreationfunc, couplant_coord, isolator_coords,followupfunc)

specimen=maincreationfunc(M,geom,tag);


% Add isolators

addprop(specimen,'isolators');

specimen.isolators={};

for cnt=1:size(isolator_coords,1)
  if isnan(isolator_coords(cnt,4))
    % circular isolator
    specimen.isolators{cnt}=BuildLaterWithNormal(M,geom,sprintf('%s_isolator%.2d',tag,cnt), ...
  				             ... % position
					         isolator_coords(cnt,1:3), ... 
				             ... % params provided with build (including 
				             ... % geometrically extracted normal)	
					         @(M,geom,object,pos,normal) ... 
				             ... % Function to run to build the isolator
					         BuildIsolator(M,geom,object, ...
						               'Circle',pos,normal));
  else
    % rectangular isolator
    specimen.isolators{cnt}=BuildLaterWithNormal(M,geom,sprintf('%s_isolator%.2d',tag,cnt), ...
  				             ... % position
					         isolator_coords(cnt,1:3), ... 
				             ... % params provided with build (including 
				             ... % geometrically extracted normal)	
					         @(M,geom,object,pos,normal) ... 
				             ... % Function to run to build the isolator
					         BuildIsolator(M,geom,object, ...
						               'Rectangle',pos,normal,isolator_coords(cnt,4)));
  end
end

% Add transducer/couplant
addprop(specimen,'couplant');

if isnan(couplant_coord(4))
  % circular couplant						
  specimen.couplant=BuildLaterWithNormal(M,geom,[ tag '_couplant' ], ...
				         couplant_coord(1:3), ...
				         @(M,geom,object,pos,normal) ...
				         BuildCouplant(M,geom,object, 'Circle', pos, normal));
else
  % rectangular couplant						
  specimen.couplant=BuildLaterWithNormal(M,geom,[ tag '_couplant' ], ...
				         couplant_coord(1:3), ...
				         @(M,geom,object,pos,normal) ...
				         BuildCouplant(M,geom,object, 'Rectangle', pos, normal,couplant_coord(4)));
end

