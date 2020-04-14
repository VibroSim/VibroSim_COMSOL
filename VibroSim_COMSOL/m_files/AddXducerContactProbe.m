%> function M = AddXDucerContactProbe(M,geom,specimen,xducercoord)
%> @param xducercoord: coordinates of transducer contact (i.e. couplant_coord)
%>
%> This is intended to be sequenced with a pipe after VibroPhysics to add 
%> a transducer contact probe to the relevant physics nodes. 

function M = AddXducerContactProbe(M,geom,specimen,xducercoord)


  %% Create time domain model

  % Since the Physics is created after getnormals() is called, we can access the normal directions
  [normal,numpos]=GetNormal(M,geom,[ xducercoord(1), xducercoord(2), xducercoord(3) ]);

  if isprop(M,'solidmech_timedomain')
    addprop(M,'timedomain_xducercontactprobe');
    M.timedomain_xducercontactprobe=CreateProbe(M, 'vibrodynamic_timedomain_xducercontactprobe', M.solidmech_timedomain.tag, ...	
  						xducercoord(1), ...
  						xducercoord(2), ...
						xducercoord(3), ... 
  						normal(1), ...
  						normal(2), ...
  						normal(3), ...
  						'bndsnap3','on');
  end

  if isprop(M,'solidmech_harmonicsweep')
    addprop(M,'harmonicsweep_xducercontactprobe');
    M.harmonicsweep_xducercontactprobe=CreateProbe(M, 'vibrodynamic_harmonicsweep_xducercontactprobe', M.solidmech_harmonicsweep.tag, ...	
  						   xducercoord(1), ...
  						   xducercoord(2), ...
  						   xducercoord(3), ... 
  						   normal(1), ...
  						   normal(2), ...
  						   normal(3), ...
  						   'bndsnap3','on');
  end

  if isprop(M,'solidmech_harmonicburst')
    addprop(M,'harmonicburst_xducercontactprobe');
    M.harmonicburst_xducercontactprobe=CreateProbe(M, 'vibrodynamic_harmonicburst_xducercontactprobe', M.solidmech_harmonicburst.tag, ...	
  						   xducercoord(1), ...
  						   xducercoord(2), ...
  						   xducercoord(3), ... 
  						   normal(1), ...
  						   normal(2), ...
  						   normal(3), ...
  						   'bndsnap3','on');
  end

  if isprop(M,'solidmech_multisweep')
    addprop(M,'multisweep_xducercontactprobe');
    M.multisweep_xducercontactprobe=CreateProbe(M, 'vibrodynamic_multisweep_xducercontactprobe', M.solidmech_multisweep.tag, ...	
						xducercoord(1), ...
						xducercoord(2), ...
						xducercoord(3), ... 
						normal(1), ...
						normal(2), ...
						normal(3), ...
						'bndsnap3','on');
  end

