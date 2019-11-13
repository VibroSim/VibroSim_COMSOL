%> H and R are the displacement constraints, defined below and in the COMSOL manual
%> Note that if you provide H as a 1 dimensional cell array you must provide the
%> elements in Fortran order (column by column)
%> HarmonicPerR and HarmonicPerR are optional. If given, a hamonic perturbation node
%> is created in addition to a static node with the given values
%> Create a fixed boundary condition for a face identified via a selection function
function bcobj = BuildFaceDisplacementBC(M,geom,physics,object,bcobj,getfaceselectionfunc,H,R,HarmonicPerH,HarmonicPerR)

  bcobj.parent=physics.node.feature;  % So we know how to delete this object
  bcobj.node=physics.node.feature.create(bcobj.tag,'Displacement2');  % 2 is the dimensionality ... we might need to concatenate it into the string
  bcobj.node.label(bcobj.tag);

  % in general mode, you define Hu=R, for matrix H, vector R, and displacement u
  % We want to specify the displacement along an axis, call it ahat.
  % Meaning our constraint is that u*ahat=specified value.
  % Therefore, first row of H=ahat, first element of R is specified value
  % second and 3rd rows of both H and R are zero.

  faceentities=getfaceselectionfunc(M,geom,object);
  bcobj.node.selection.set(faceentities);

  bcobj.node.set('Notation','GeneralNotation');

  bcobj.node.set('H',H);
  bcobj.node.set('R',R);

  if exist('HarmonicPerH','var')
    % Create harmonic perturbation sub-node

    addprop(bcobj,'harmonicper');
    bcobj.harmonicper=ModelWrapper(M,[ bcobj.tag '_hper' ],physics.node.feature);
    bcobj.harmonicper.node=bcobj.node.feature.create(bcobj.harmonicper.tag,'HarmonicPerturbation',2);  % 2 is the dimensionality ... we might need to concatenate it into the string
    bcobj.harmonicper.node.label(bcobj.harmonicper.tag);

    bcobj.harmonicper.node.set('H',HarmonicPerH);
    bcobj.harmonicper.node.set('R',HarmonicPerR);



  end
