function crackheatingmodel=CreateCrackHeatingModel(M,tag)

if 0 % Analytic form
  crackheatingmodel=CreateFunction(M,tag,'Analytic');
  crackheatingmodel.node.label(crackheatingmodel.tag);
  crackheatingmodel.node.set('funcname',crackheatingmodel.tag);

  % arguments
  crackheatingmodel.node.set('args','freq, centerstrainmag, semimajoraxislen, closure, semimajoraxispos1, semimajoraxispos2');

  % function units
  crackheatingmodel.node.set('fununit', 'W/m^2');

  % parameter units
  crackheatingmodel.node.set('argunit', 'Hz, 1, m, MPa, m, m');

  ltip = '(semimajoraxislen - ((semimajoraxispos1  + semimajoraxispos2)/2))';

  % For now we are using the power law form of the strain dependence.
  crackheatingmodel.node.set('expr',[ 'expV0*(centerstrainmag/100e-6)^V1*freq*(1.0/(1.0+exp(-m1*((' ltip ')-l0))))*(1.0/(4.0*wh))*exp(-abs(closure/2.0/wh))' ]);

else
  % Based on draws from statistical model  

  funcname='meeker_statmodel_040815_eval';

  crackheatingmodel=CreateFunction(M,tag,'MATLAB');
  crackheatingmodel.node.label(crackheatingmodel.tag);
  crackheatingmodel.node.setIndex('funcs',funcname,0,0);
  crackheatingmodel.node.setIndex('funcs','freq, centerstrainmag, semimajoraxislen, closure, semimajoraxispos1, semimajoraxispos2, wh, percentile',0,1);


  % Set all derivatives to be zero
  crackheatingmodel.node.setIndex('ders',funcname,0,0);
  crackheatingmodel.node.setIndex('ders','freq',0,1);
  crackheatingmodel.node.setIndex('ders','0',0,2);

  crackheatingmodel.node.setIndex('ders',funcname,1,0);
  crackheatingmodel.node.setIndex('ders','centerstrainmag',1,1);
  crackheatingmodel.node.setIndex('ders','0',1,2);

  crackheatingmodel.node.setIndex('ders',funcname,2,0);
  crackheatingmodel.node.setIndex('ders','semimajoraxislen',2,1);
  crackheatingmodel.node.setIndex('ders','0',2,2);

  crackheatingmodel.node.setIndex('ders',funcname,3,0);
  crackheatingmodel.node.setIndex('ders','closure',3,1);
  crackheatingmodel.node.setIndex('ders','0',3,2);

  crackheatingmodel.node.setIndex('ders',funcname,4,0);
  crackheatingmodel.node.setIndex('ders','semimajoraxispos1',4,1);
  crackheatingmodel.node.setIndex('ders','0',4,2);

  crackheatingmodel.node.setIndex('ders',funcname,5,0);
  crackheatingmodel.node.setIndex('ders','semimajoraxispos2',5,1);
  crackheatingmodel.node.setIndex('ders','0',5,2);

  crackheatingmodel.node.setIndex('ders',funcname,6,0);
  crackheatingmodel.node.setIndex('ders','wh',6,1);
  crackheatingmodel.node.setIndex('ders','0',6,2);

  crackheatingmodel.node.setIndex('ders',funcname,7,0);
  crackheatingmodel.node.setIndex('ders','percentile',7,1);
  crackheatingmodel.node.setIndex('ders','0',7,2);

end


