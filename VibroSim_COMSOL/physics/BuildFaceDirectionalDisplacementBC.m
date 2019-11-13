%> NOTE: Direction MUST be a unit vector
%> harmonicperdirection, harmonicpermagnitude are optional and if given
%> result in the creation of a harmonic perturbation
function bcobj = BuildFaceDirectionalDisplacementBC(M,geom,physics,object,bcobj,getfaceselectionfunc,direction,magnitude,harmonicperdirection,harmonicpermagnitude)


direction_ca=to_cellstr_array(direction);

%H={ direction_ca, { '0','0','0' }, { '0','0','0' } };

% must extract elements in Fortran-order
H={ direction_ca{1},'0','0', direction_ca{2},'0','0',direction_ca{3},'0','0' } ;


if isa(magnitude,'double')
  magnitude=num2str(magnitude,18);
end

R={ magnitude, '0', '0' };

if exist('harmonicperdirection','var')
  harmonicperdirection_ca=to_cellstr_array(harmonicperdirection);

  if isa(harmonicpermagnitude,'double')
    harmonicpermagnitude=num2str(harmonicpermagnitude,18);
  end


  %HarmonicH={ harmonicperdirection_ca, { '0','0','0' }, { '0','0','0' } };
  % must extract elements in Fortran-order
  HarmonicPerH={ harmonicperdirection_ca{1},'0','0', harmonicperdirection_ca{2},'0','0',harmonicperdirection_ca{3},'0','0' } ;
  HarmonicPerR={ harmonicpermagnitude, '0', '0' };

  BuildFaceDisplacementBC(M,geom,physics,object,bcobj,getfaceselectionfunc,H,R,HarmonicPerH,HarmonicPerR);

else

  BuildFaceDisplacementBC(M,geom,physics,object,bcobj,getfaceselectionfunc,H,R);
end
  

