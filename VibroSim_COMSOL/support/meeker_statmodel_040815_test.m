freq=15600*ones(1,3);
centerstrainmag=3.0e-5*ones(1,3);
semimajoraxislen=3.0e-3*ones(1,3);
closure=-30e6*ones(1,3);
semimajoraxispos1=0.0e-3*ones(1,3);
semimajoraxispos2=1.0e-3*ones(1,3);
wh=20e6*ones(1,3);
percentile=[50 5 95];

vals1=meeker_statmodel_040815_eval(freq,centerstrainmag,semimajoraxislen,closure,semimajoraxispos1,semimajoraxispos2,wh,percentile);

vals1
fprintf(1,'Compare to [497 79 3218] W/m^2 from report\n');

closure=0.0e6*ones(1,3);
semimajoraxispos1=1.0e-3*ones(1,3);
semimajoraxispos2=2.0e-3*ones(1,3);

vals2=meeker_statmodel_040815_eval(freq,centerstrainmag,semimajoraxislen,closure,semimajoraxispos1,semimajoraxispos2,wh,percentile);

vals2
fprintf(1,'Compare to [1031 164 6479] W/m^2 from report\n');


closure=60.0e6*ones(1,3);
semimajoraxispos1=2.0e-3*ones(1,3);
semimajoraxispos2=3.0e-3*ones(1,3);

vals3=meeker_statmodel_040815_eval(freq,centerstrainmag,semimajoraxislen,closure,semimajoraxispos1,semimajoraxispos2,wh,percentile);

vals3
fprintf(1,'Compare to [141 22 896] W/m^2 from report\n');
