function M_or_Model=VibroResults(M_or_Model,output_base_filename)
% The first parameter to VibroResults can be either the ModelWrapper 'M' or its underlying
% COMSOL object 'model'. 
% That way if you have loaded a model from disk and it is no longer wrapped you can run VibroResults
% on it directly. However, pipelines will not work with un-wrapped models (just run each pipeline
% entry in sequence)
%
% output_base_filename is an optional parameter... Will not auto-select save file names otherwise


if isa(M_or_Model,'ModelWrapper')
   model = M_or_Model.node;
else
   model = M_or_Model;
end

if DataSetExistsForSolution(model,'solidmech_static_solution')
  CreateOrReplace(model.result,'vibro_static_plot','PlotGroup3D');
  model.result('vibro_static_plot').label('vibro_static_plot');
  if string_in_cellstr_array('specimen_view',cell(model.view.tags))
    model.result('vibro_static_plot').set('view','specimen_view');
  end
  model.result('vibro_static_plot').set('data', GetDataSetForSolution(model,'solidmech_static_solution'));
  model.result('vibro_static_plot').create('vibro_static_plot_surface', 'Surface');
  model.result('vibro_static_plot').feature('vibro_static_plot_surface').label('vibro_static_plot_surface');
  model.result('vibro_static_plot').feature('vibro_static_plot_surface').create('vibro_static_plot_surface_displacement', 'Deform');
  model.result('vibro_static_plot').feature('vibro_static_plot_surface').feature('vibro_static_plot_surface_displacement').label('vibro_static_plot_surface_displacement');
  model.result('vibro_static_plot').run;
end


if DataSetExistsForSolution(model,'solidmech_modal_solution')
  CreateOrReplace(model.result,'vibro_modal_plot','PlotGroup3D');
  model.result('vibro_modal_plot').label('vibro_modal_plot');
  if string_in_cellstr_array('specimen_view',cell(model.view.tags))
    model.result('vibro_modal_plot').set('view','specimen_view');
  end
  model.result('vibro_modal_plot').set('data', GetDataSetForSolution(model,'solidmech_modal_solution'));
  model.result('vibro_modal_plot').create('vibro_modal_plot_surface', 'Surface');
  model.result('vibro_modal_plot').feature('vibro_modal_plot_surface').label('vibro_modal_plot_surface');
  model.result('vibro_modal_plot').feature('vibro_modal_plot_surface').create('vibro_modal_plot_surface_deform', 'Deform');
  % model.result('vibro_modal_plot').setIndex('looplevel', '2', 0);
  model.result('vibro_modal_plot').feature('vibro_modal_plot_surface').feature('vibro_modal_plot_surface_deform').label('vibro_modal_plot_surface_displacement');
  model.result('vibro_modal_plot').feature('vibro_modal_plot_surface').set('expr', 'solidmech_modal.sx');
  model.result('vibro_modal_plot').feature('vibro_modal_plot_surface').set('descr', 'Stress tensor, X-component');
  model.result('vibro_modal_plot').run
end


if DataSetExistsForSolution(model,'solidmech_harmonic_solution')
  CreateOrReplace(model.result,'vibro_harmonic_plot','PlotGroup3D');
  model.result('vibro_harmonic_plot').label('vibro_harmonic_plot');
  if string_in_cellstr_array('specimen_view',cell(model.view.tags))
    model.result('vibro_harmonic_plot').set('view','specimen_view');
  end
  model.result('vibro_harmonic_plot').set('data', GetDataSetForSolution(model,'solidmech_harmonic_solution'));
  model.result('vibro_harmonic_plot').create('vibro_harmonic_plot_surface', 'Surface');
  model.result('vibro_harmonic_plot').feature('vibro_harmonic_plot_surface').label('vibro_harmonic_plot_surface');
  model.result('vibro_harmonic_plot').feature('vibro_harmonic_plot_surface').create('vibro_harmonic_plot_surface_deform', 'Deform');
  %model.result('vibro_harmonic_plot').setIndex('looplevel', '2', 0);
  model.result('vibro_harmonic_plot').feature('vibro_harmonic_plot_surface').feature('vibro_harmonic_plot_surface_deform').label('vibro_harmonic_plot_surface_displacement');
  model.result('vibro_harmonic_plot').feature('vibro_harmonic_plot_surface').set('expr', 'solidmech_harmonic.SX');
  model.result('vibro_harmonic_plot').feature('vibro_harmonic_plot_surface').set('descr', 'Second Piola-Kirchhoff stress, X component');
  model.result('vibro_harmonic_plot').run
end


if DataSetExistsForSolution(model,'solidmech_harmonicper_solution')
  CreateOrReplace(model.result,'vibro_harmonicper_plot','PlotGroup3D');
  model.result('vibro_harmonicper_plot').label('vibro_harmonicper_plot');
  if string_in_cellstr_array('specimen_view',cell(model.view.tags))
    model.result('vibro_harmonicper_plot').set('view','specimen_view');
  end

  model.result('vibro_harmonicper_plot').set('data', GetDataSetForSolution(model,'solidmech_harmonicper_solution'));
  model.result('vibro_harmonicper_plot').create('vibro_harmonicper_plot_surface', 'Surface');
  model.result('vibro_harmonicper_plot').feature('vibro_harmonicper_plot_surface').label('vibro_harmonicper_plot_surface');
  model.result('vibro_harmonicper_plot').feature('vibro_harmonicper_plot_surface').create('vibro_harmonicper_plot_surface_deform', 'Deform');
  %model.result('vibro_harmonicper_plot').setIndex('looplevel', '2', 0);
  model.result('vibro_harmonicper_plot').feature('vibro_harmonicper_plot_surface').feature('vibro_harmonicper_plot_surface_deform').label('vibro_harmonicper_plot_surface_displacement');
  model.result('vibro_harmonicper_plot').feature('vibro_harmonicper_plot_surface').set('expr', 'solidmech_harmonicper.SX');
  model.result('vibro_harmonicper_plot').feature('vibro_harmonicper_plot_surface').set('descr', 'Second Piola-Kirchhoff stress, X component');
  model.result('vibro_harmonicper_plot').run
end


if DataSetExistsForSolution(model,'solidmech_timedomain_solution')
  CreateOrReplace(model.result,'vibro_timedomain_plot','PlotGroup3D');
  model.result('vibro_timedomain_plot').set('data', GetDataSetForSolution(model,'solidmech_timedomain_solution'));
  
  if string_in_cellstr_array('specimen_view',cell(model.view.tags))
    model.result('vibro_timedomain_plot').set('view','specimen_view');
  end

  model.result('vibro_timedomain_plot').create('vibro_timedomain_plot_surface', 'Surface');
  model.result('vibro_timedomain_plot').feature('vibro_timedomain_plot_surface').label('vibro_timedomain_plot_surface');
  model.result('vibro_timedomain_plot').feature('vibro_timedomain_plot_surface').create('vibro_timedomain_plot_surface_deform', 'Deform');
  model.result('vibro_timedomain_plot').feature('vibro_timedomain_plot_surface').feature('vibro_timedomain_plot_surface_deform').set('expr', { 'solidmech_timedomainu', 'solidmech_timedomainv', 'solidmech_timedomainw' }); 

  %model.result('vibro_harmonicsweep_plot').setIndex('looplevel', '2', 0);
  model.result('vibro_timedomain_plot').feature('vibro_timedomain_plot_surface').feature('vibro_timedomain_plot_surface_deform').label('vibro_timedomain_plot_surface_displacement');
  model.result('vibro_timedomain_plot').feature('vibro_timedomain_plot_surface').set('expr', 'solidmech_timedomain.SX');
  model.result('vibro_timedomain_plot').feature('vibro_timedomain_plot_surface').set('descr', 'Second Piola-Kirchhoff stress, X component');
  model.result('vibro_timedomain_plot').run


  if string_in_cellstr_array('solidmech_timedomain_laser',cell(model.probe.tags))
    CreateOrReplace(model.result,'vibro_timedomain_laser_vel','PlotGroup1D');
    model.result('vibro_timedomain_laser_vel').label('vibro_timedomain_laser_vel');
    model.result('vibro_timedomain_laser_vel').set('data', GetDataSetForSolution(model,'solidmech_timedomain_solution'));
    model.result('vibro_timedomain_laser_vel').create('vibro_timedomain_laser_vel_global','Global');
    model.result('vibro_timedomain_laser_vel').feature('vibro_timedomain_laser_vel_global').set('expr',{'solidmech_timedomain_laser_vel'});
    model.result('vibro_timedomain_laser_vel').feature('vibro_timedomain_laser_vel_global').set('unit',{'mm/s'});
    model.result('vibro_timedomain_laser_vel').feature('vibro_timedomain_laser_vel_global').setIndex('descr','Laser vibrometer velocity response', 0);
    model.result('vibro_timedomain_laser_vel').feature('vibro_timedomain_laser_vel_global').label('vibro_timedomain_laser_vel_global');
    model.result('vibro_timedomain_laser_vel').run;
  end


  if string_in_cellstr_array('solidmech_timedomain_laser',cell(model.probe.tags))
    % Manually create data set, derived value, and table to store
    % the probe output. We need to increase the max # of rows in the table!
     
    %CreateOrReplace(model.result.dataset,'custom_solidmech_timedomain_solution','Solution');
    %model.result.dataset('custom_solidmech_timedomain_solution').set('solution','solidmech_timedomain_solution');
    %model.result.dataset('custom_solidmech_timedomain_solution').set('frametype','geometry');

    CreateOrReplace(model.result.dataset,'custom_solidmech_timedomain_laser','CutPoint3D');
    model.result.dataset('custom_solidmech_timedomain_laser').label('custom_solidmech_timedomain_laser');
    model.result.dataset('custom_solidmech_timedomain_laser').set('data',GetDataSetForSolution(model,'solidmech_timedomain_solution')); % 'custom_solidmech_timedomain_solution');
    probepoint = model.probe('solidmech_timedomain_laser').getStringMatrix('coords');
    model.result.dataset('custom_solidmech_timedomain_laser').set('pointx', probepoint(1,1)); % This extracts the coordinates from the laser probe
    model.result.dataset('custom_solidmech_timedomain_laser').set('pointy', probepoint(1,2)); % This extracts the coordinates from the laser probe
    model.result.dataset('custom_solidmech_timedomain_laser').set('pointz', probepoint(1,3)); % This extracts the coordinates from the laser probe
    model.result.dataset('custom_solidmech_timedomain_laser').set('bndsnap','on');
    model.result.dataset('custom_solidmech_timedomain_laser').run;

    CreateOrReplace(model.result.numerical,'custom_solidmech_timedomain_laser_displ','EvalPoint');
    model.result.numerical('custom_solidmech_timedomain_laser_displ').label('custom_solidmech_timedomain_laser_displ');
    model.result.numerical('custom_solidmech_timedomain_laser_displ').set('data','custom_solidmech_timedomain_laser');
    
    model.result.numerical('custom_solidmech_timedomain_laser_displ').setIndex('expr',model.probe('solidmech_timedomain_laser').feature('solidmech_timedomain_laser_displ').getString('expr'),0);


    CreateOrReplace(model.result.table,'custom_solidmech_timedomain_laser_displ_table','Table');
    model.result.table('custom_solidmech_timedomain_laser_displ_table').label('custom_solidmech_timedomain_laser_displ_table');
    model.result.table('custom_solidmech_timedomain_laser_displ_table').set('tablebuffersize','1000000');
    model.result.numerical('custom_solidmech_timedomain_laser_displ').set('table','custom_solidmech_timedomain_laser_displ_table');
    
    model.result.numerical('custom_solidmech_timedomain_laser_displ').run;

    
    % Now do the velocity output
    CreateOrReplace(model.result.numerical,'custom_solidmech_timedomain_laser_vel','EvalPoint');
    model.result.numerical('custom_solidmech_timedomain_laser_vel').label('custom_solidmech_timedomain_laser_vel');
    model.result.numerical('custom_solidmech_timedomain_laser_vel').set('data','custom_solidmech_timedomain_laser');
    
    model.result.numerical('custom_solidmech_timedomain_laser_vel').setIndex('expr',model.probe('solidmech_timedomain_laser').feature('solidmech_timedomain_laser_vel').getString('expr'),0);


    CreateOrReplace(model.result.table,'custom_solidmech_timedomain_laser_vel_table','Table');
    model.result.table('custom_solidmech_timedomain_laser_vel_table').label('custom_solidmech_timedomain_laser_vel_table');
    model.result.table('custom_solidmech_timedomain_laser_vel_table').set('tablebuffersize','1000000');
    model.result.numerical('custom_solidmech_timedomain_laser_vel').set('table','custom_solidmech_timedomain_laser_vel_table');
    
    model.result.numerical('custom_solidmech_timedomain_laser_vel').run;



  end




  if string_in_cellstr_array('vibrodynamic_timedomain_xducercontactprobe',cell(model.probe.tags))
    % Manually create data set, derived value, and table to store
    % the probe output. We need to increase the max # of rows in the table!
     
    %CreateOrReplace(model.result.dataset,'custom_solidmech_timedomain_solution','Solution');
    %model.result.dataset('custom_solidmech_timedomain_solution').set('solution','solidmech_timedomain_solution');
    %model.result.dataset('custom_solidmech_timedomain_solution').set('frametype','geometry');

    CreateOrReplace(model.result.dataset,'custom_vibrodynamic_xducercontactprobe','CutPoint3D');
    model.result.dataset('custom_vibrodynamic_xducercontactprobe').label('custom_vibrodynamic_xducercontactprobe');
    model.result.dataset('custom_vibrodynamic_xducercontactprobe').set('data',GetDataSetForSolution(model,'solidmech_timedomain_solution')); % 'custom_solidmech_timedomain_solution');
    probepoint = model.probe('vibrodynamic_timedomain_xducercontactprobe').getStringMatrix('coords');
    model.result.dataset('custom_vibrodynamic_xducercontactprobe').set('pointx', probepoint(1,1)); % This extracts the coordinates from the laser probe
    model.result.dataset('custom_vibrodynamic_xducercontactprobe').set('pointy', probepoint(1,2)); % This extracts the coordinates from the laser probe
    model.result.dataset('custom_vibrodynamic_xducercontactprobe').set('pointz', probepoint(1,3)); % This extracts the coordinates from the laser probe
    model.result.dataset('custom_vibrodynamic_xducercontactprobe').set('bndsnap','on');
    model.result.dataset('custom_vibrodynamic_xducercontactprobe').run;

    CreateOrReplace(model.result.numerical,'custom_vibrodynamic_xducercontactprobe_displ','EvalPoint');
    model.result.numerical('custom_vibrodynamic_xducercontactprobe_displ').label('custom_vibrodynamic_xducercontactprobe_displ');
    model.result.numerical('custom_vibrodynamic_xducercontactprobe_displ').set('data','custom_vibrodynamic_xducercontactprobe');
    
    model.result.numerical('custom_vibrodynamic_xducercontactprobe_displ').setIndex('expr',model.probe('vibrodynamic_timedomain_xducercontactprobe').feature('vibrodynamic_timedomain_xducercontactprobe_displ').getString('expr'),0);


    CreateOrReplace(model.result.table,'custom_vibrodynamic_xducercontactprobe_displ_table','Table');
    model.result.table('custom_vibrodynamic_xducercontactprobe_displ_table').label('custom_vibrodynamic_xducercontactprobe_displ_table');
    model.result.table('custom_vibrodynamic_xducercontactprobe_displ_table').set('tablebuffersize','1000000');
    model.result.numerical('custom_vibrodynamic_xducercontactprobe_displ').set('table','custom_vibrodynamic_xducercontactprobe_displ_table');
    
    model.result.numerical('custom_vibrodynamic_xducercontactprobe_displ').run;

    
    % Now do the velocity output
    CreateOrReplace(model.result.numerical,'custom_vibrodynamic_xducercontactprobe_vel','EvalPoint');
    model.result.numerical('custom_vibrodynamic_xducercontactprobe_vel').label('custom_vibrodynamic_xducercontactprobe_vel');
    model.result.numerical('custom_vibrodynamic_xducercontactprobe_vel').set('data','custom_vibrodynamic_xducercontactprobe');
    
    model.result.numerical('custom_vibrodynamic_xducercontactprobe_vel').setIndex('expr',model.probe('vibrodynamic_timedomain_xducercontactprobe').feature('vibrodynamic_timedomain_xducercontactprobe_vel').getString('expr'),0);


    CreateOrReplace(model.result.table,'custom_vibrodynamic_xducercontactprobe_vel_table','Table');
    model.result.table('custom_vibrodynamic_xducercontactprobe_vel_table').label('custom_vibrodynamic_xducercontactprobe_vel_table');
    model.result.table('custom_vibrodynamic_xducercontactprobe_vel_table').set('tablebuffersize','1000000');
    model.result.numerical('custom_vibrodynamic_xducercontactprobe_vel').set('table','custom_vibrodynamic_xducercontactprobe_vel_table');
    
    model.result.numerical('custom_vibrodynamic_xducercontactprobe_vel').run;



  end


  if string_in_cellstr_array('vibrodynamic_timedomain_xducercontactprobe',cell(model.probe.tags))
    CreateOrReplace(model.result,'vibro_timedomain_contact_disp','PlotGroup1D');
    model.result('vibro_timedomain_contact_disp').label('vibro_timedomain_contact_disp');
    model.result('vibro_timedomain_contact_disp').set('data', GetDataSetForSolution(model,'solidmech_timedomain_solution'));
    model.result('vibro_timedomain_contact_disp').create('vibro_timedomain_contact_disp_global','Global');
    model.result('vibro_timedomain_contact_disp').feature('vibro_timedomain_contact_disp_global').set('expr',{'vibrodynamic_timedomain_xducercontactprobe_displ'});
    model.result('vibro_timedomain_contact_disp').feature('vibro_timedomain_contact_disp_global').set('unit',{'m'});
    model.result('vibro_timedomain_contact_disp').feature('vibro_timedomain_contact_disp_global').setIndex('descr','Transducer contact position normal displacement', 0);
    model.result('vibro_timedomain_contact_disp').feature('vibro_timedomain_contact_disp_global').label('vibro_timedomain_contact_disp_global');
    model.result('vibro_timedomain_contact_disp').run;
  end

  %if DataSetExistsForProbe(model,'vibrodynamic_timedomain_xducercontactprobe')
  %  CreateOrReplace(model.result.export,'vibrodynamic_timedomain_xducercontactprobe_export','Data');
  %  model.result.export('vibrodynamic_timedomain_xducercontactprobe_export').set('data',GetDataSetForProbe(model,'vibrodynamic_timedomain_xducercontactprobe'))
  %  % !!!*** Bug! Need to do:
  %  % model.result.export('vibrodynamic_timedomain_xducercontactprobe_export').set('solnum',{'1' '2' '3'  .... n }) where n is the number of points in the range from the study... usually range(timedomain_start_time,timedomain_step_time,timedomain_end_time)
  %  model.result.export('vibrodynamic_timedomain_xducercontactprobe_export').set('expr', {'vibrodynamic_timedomain_xducercontactprobe_displ'});
  %  model.result.export('vibrodynamic_timedomain_xducercontactprobe_export').set('descr', {'Probe variable vibrodynamic_timedomain_xducercontactprobe_displ'});
  %  model.result.export('vibrodynamic_timedomain_xducercontactprobe_export').set('unit', {'m'});
  %  model.result.export('vibrodynamic_timedomain_xducercontactprobe_export').set('alwaysask', 'on');
  %  %model.result.export('vibrodynamic_timedomain_xducercontactprobe_export').set('filename', '/tmp/foo.dat.txt');
  %  model.result.export('vibrodynamic_timedomain_xducercontactprobe_export').run;

  %end

end



if DataSetExistsForSolution(model,'solidmech_harmonicsweep_solution')
  CreateOrReplace(model.result,'vibro_harmonicsweep_plot','PlotGroup3D');
  model.result('vibro_harmonicsweep_plot').label('vibro_harmonicsweep_plot');
  if string_in_cellstr_array('specimen_view',cell(model.view.tags))
    model.result('vibro_harmonicsweep_plot').set('view','specimen_view');
  end
  model.result('vibro_harmonicsweep_plot').set('data', GetDataSetForSolution(model,'solidmech_harmonicsweep_solution'));
  model.result('vibro_harmonicsweep_plot').create('vibro_harmonicsweep_plot_surface', 'Surface');
  model.result('vibro_harmonicsweep_plot').feature('vibro_harmonicsweep_plot_surface').label('vibro_harmonicsweep_plot_surface');
  model.result('vibro_harmonicsweep_plot').feature('vibro_harmonicsweep_plot_surface').create('vibro_harmonicsweep_plot_surface_deform', 'Deform');
  model.result('vibro_harmonicsweep_plot').feature('vibro_harmonicsweep_plot_surface').feature('vibro_harmonicsweep_plot_surface_deform').set('expr', { 'solidmech_harmonicsweepu', 'solidmech_harmonicsweepv', 'solidmech_harmonicsweepw' }); 

  %model.result('vibro_harmonicsweep_plot').setIndex('looplevel', '2', 0);
  model.result('vibro_harmonicsweep_plot').feature('vibro_harmonicsweep_plot_surface').feature('vibro_harmonicsweep_plot_surface_deform').label('vibro_harmonicsweep_plot_surface_displacement');
  model.result('vibro_harmonicsweep_plot').feature('vibro_harmonicsweep_plot_surface').set('expr', 'solidmech_harmonicsweep.SX');
  model.result('vibro_harmonicsweep_plot').feature('vibro_harmonicsweep_plot_surface').set('descr', 'Second Piola-Kirchhoff stress, X component');
  model.result('vibro_harmonicsweep_plot').run


  if string_in_cellstr_array('crack_centerstrain',to_cellstr_array(model.variable.tags))
    CreateOrReplace(model.result,'vibro_harmonicsweep_spectrum','PlotGroup1D');
    model.result('vibro_harmonicsweep_spectrum').label('vibro_harmonicsweep_spectrum');
    model.result('vibro_harmonicsweep_spectrum').set('data', GetDataSetForSolution(model,'solidmech_harmonicsweep_solution'));
    model.result('vibro_harmonicsweep_spectrum').create('vibro_harmonicsweep_spectrum_global','Global');
    model.result('vibro_harmonicsweep_spectrum').feature('vibro_harmonicsweep_spectrum_global').set('expr',{'crack_centerstrainmag_solidmech_harmonicsweep','crack_centerstrainnormal_solidmech_harmonicsweep','crack_centerstrainshear_solidmech_harmonicsweep'});
    model.result('vibro_harmonicsweep_spectrum').feature('vibro_harmonicsweep_spectrum_global').setIndex('descr','Magnitude of engineering dynamic strain at crack location', 0);
    model.result('vibro_harmonicsweep_spectrum').feature('vibro_harmonicsweep_spectrum_global').setIndex('descr','Engineering dynamic normal strain at crack location', 1);
    model.result('vibro_harmonicsweep_spectrum').feature('vibro_harmonicsweep_spectrum_global').setIndex('descr','Engineering dynamic shear strain at crack location', 2);
    model.result('vibro_harmonicsweep_spectrum').feature('vibro_harmonicsweep_spectrum_global').label('vibro_harmonicsweep_spectrum_global');
    model.result('vibro_harmonicsweep_spectrum').run;
  end

  if string_in_cellstr_array('solidmech_harmonicsweep_laser',cell(model.probe.tags))
    CreateOrReplace(model.result,'vibro_harmonicsweep_laser_displ','PlotGroup1D');
    model.result('vibro_harmonicsweep_laser_displ').label('vibro_harmonicsweep_laser_displ');
    model.result('vibro_harmonicsweep_laser_displ').set('data', GetDataSetForSolution(model,'solidmech_harmonicsweep_solution'));
    model.result('vibro_harmonicsweep_laser_displ').create('vibro_harmonicsweep_laser_displ_global','Global');
    model.result('vibro_harmonicsweep_laser_displ').feature('vibro_harmonicsweep_laser_displ_global').set('expr',{'abs(solidmech_harmonicsweep_laser_displ)'});
    model.result('vibro_harmonicsweep_laser_displ').feature('vibro_harmonicsweep_laser_displ_global').set('unit',{'um'});
    model.result('vibro_harmonicsweep_laser_displ').feature('vibro_harmonicsweep_laser_displ_global').setIndex('descr','Magnitude of laser vibrometer displacement response', 0);
    model.result('vibro_harmonicsweep_laser_displ').feature('vibro_harmonicsweep_laser_displ_global').label('vibro_harmonicsweep_laser_displ_global');
    model.result('vibro_harmonicsweep_laser_displ').run;

    CreateOrReplace(model.result,'vibro_harmonicsweep_laser_vel','PlotGroup1D');
    model.result('vibro_harmonicsweep_laser_vel').label('vibro_harmonicsweep_laser_vel');
    model.result('vibro_harmonicsweep_laser_vel').set('data', GetDataSetForSolution(model,'solidmech_harmonicsweep_solution'));
    model.result('vibro_harmonicsweep_laser_vel').create('vibro_harmonicsweep_laser_vel_global','Global');
model.result('vibro_harmonicsweep_laser_vel').feature('vibro_harmonicsweep_laser_vel_global').set('expr',{'abs(solidmech_harmonicsweep_laser_vel)','imag(log(solidmech_harmonicsweep_laser_vel))'});
    model.result('vibro_harmonicsweep_laser_vel').feature('vibro_harmonicsweep_laser_vel_global').set('unit',{'mm/s'});
    model.result('vibro_harmonicsweep_laser_vel').feature('vibro_harmonicsweep_laser_vel_global').setIndex('descr','Magnitude of laser vibrometer velocity response', 0);
    model.result('vibro_harmonicsweep_laser_vel').feature('vibro_harmonicsweep_laser_vel_global').setIndex('descr','Angle of laser vibrometer velocity response', 1);
    model.result('vibro_harmonicsweep_laser_vel').feature('vibro_harmonicsweep_laser_vel_global').label('vibro_harmonicsweep_laser_vel_global');
    model.result('vibro_harmonicsweep_laser_vel').run;

  end




  if string_in_cellstr_array('vibrodynamic_harmonicsweep_xducercontactprobe',cell(model.probe.tags))
    CreateOrReplace(model.result,'vibrodynamic_harmonicsweep_xducercontactprobe_displ','PlotGroup1D');
    model.result('vibrodynamic_harmonicsweep_xducercontactprobe_displ').label('vibrodynamic_harmonicsweep_xducercontactprobe_displ');
    model.result('vibrodynamic_harmonicsweep_xducercontactprobe_displ').set('data', GetDataSetForSolution(model,'solidmech_harmonicsweep_solution'));
    model.result('vibrodynamic_harmonicsweep_xducercontactprobe_displ').create('vibrodynamic_harmonicsweep_xducercontactprobe_displ_global','Global');
    model.result('vibrodynamic_harmonicsweep_xducercontactprobe_displ').feature('vibrodynamic_harmonicsweep_xducercontactprobe_displ_global').set('expr',{'abs(vibrodynamic_harmonicsweep_xducercontactprobe_displ)','imag(log(vibrodynamic_harmonicsweep_xducercontactprobe_displ))'});
    model.result('vibrodynamic_harmonicsweep_xducercontactprobe_displ').feature('vibrodynamic_harmonicsweep_xducercontactprobe_displ_global').set('unit',{'um'});
    model.result('vibrodynamic_harmonicsweep_xducercontactprobe_displ').feature('vibrodynamic_harmonicsweep_xducercontactprobe_displ_global').setIndex('descr','Magnitude of transducer contact displacement response', 0);
    model.result('vibrodynamic_harmonicsweep_xducercontactprobe_displ').feature('vibrodynamic_harmonicsweep_xducercontactprobe_displ_global').label('vibrodynamic_harmonicsweep_xducercontactprobe_displ_global');
    model.result('vibrodynamic_harmonicsweep_xducercontactprobe_displ').run;

    CreateOrReplace(model.result,'vibrodynamic_harmonicsweep_xducercontactprobe_vel','PlotGroup1D');
    model.result('vibrodynamic_harmonicsweep_xducercontactprobe_vel').label('vibrodynamic_harmonicsweep_xducercontactprobe_vel');
    model.result('vibrodynamic_harmonicsweep_xducercontactprobe_vel').set('data', GetDataSetForSolution(model,'solidmech_harmonicsweep_solution'));
    model.result('vibrodynamic_harmonicsweep_xducercontactprobe_vel').create('vibrodynamic_harmonicsweep_xducercontactprobe_vel_global','Global');
    model.result('vibrodynamic_harmonicsweep_xducercontactprobe_vel').feature('vibrodynamic_harmonicsweep_xducercontactprobe_vel_global').set('expr',{'abs(vibrodynamic_harmonicsweep_xducercontactprobe_vel)','imag(log(vibrodynamic_harmonicsweep_xducercontactprobe_vel))'});
    model.result('vibrodynamic_harmonicsweep_xducercontactprobe_vel').feature('vibrodynamic_harmonicsweep_xducercontactprobe_vel_global').set('unit',{'mm/s'});
    model.result('vibrodynamic_harmonicsweep_xducercontactprobe_vel').feature('vibrodynamic_harmonicsweep_xducercontactprobe_vel_global').setIndex('descr','Magnitude of contact velocity response', 0);
    model.result('vibrodynamic_harmonicsweep_xducercontactprobe_vel').feature('vibrodynamic_harmonicsweep_xducercontactprobe_vel_global').setIndex('descr','Angle of contact velocity response', 1);
    model.result('vibrodynamic_harmonicsweep_xducercontactprobe_vel').feature('vibrodynamic_harmonicsweep_xducercontactprobe_vel_global').label('vibrodynamic_harmonicsweep_xducercontactprobe_vel_global');
    model.result('vibrodynamic_harmonicsweep_xducercontactprobe_vel').run;

  end

end



if DataSetExistsForSolution(model,'solidmech_harmonicburst_solution')
  CreateOrReplace(model.result,'vibro_harmonicburst_plot','PlotGroup3D');
  model.result('vibro_harmonicburst_plot').label('vibro_harmonicburst_plot');
  if string_in_cellstr_array('specimen_view',cell(model.view.tags))
    model.result('vibro_harmonicburst_plot').set('view','specimen_view');
  end
  model.result('vibro_harmonicburst_plot').set('data', GetDataSetForSolution(model,'solidmech_harmonicburst_solution'));
  model.result('vibro_harmonicburst_plot').create('vibro_harmonicburst_plot_surface', 'Surface');
  model.result('vibro_harmonicburst_plot').feature('vibro_harmonicburst_plot_surface').label('vibro_harmonicburst_plot_surface');
  model.result('vibro_harmonicburst_plot').feature('vibro_harmonicburst_plot_surface').create('vibro_harmonicburst_plot_surface_deform', 'Deform');
  model.result('vibro_harmonicburst_plot').feature('vibro_harmonicburst_plot_surface').feature('vibro_harmonicburst_plot_surface_deform').set('expr', { 'solidmech_harmonicburstu', 'solidmech_harmonicburstv', 'solidmech_harmonicburstw' }); 

  %model.result('vibro_harmonicburst_plot').setIndex('looplevel', '1', 0);
  model.result('vibro_harmonicburst_plot').feature('vibro_harmonicburst_plot_surface').feature('vibro_harmonicburst_plot_surface_deform').label('vibro_harmonicburst_plot_surface_displacement');
  model.result('vibro_harmonicburst_plot').feature('vibro_harmonicburst_plot_surface').set('expr', 'solidmech_harmonicburst.SX');
  model.result('vibro_harmonicburst_plot').feature('vibro_harmonicburst_plot_surface').set('descr', 'Second Piola-Kirchhoff stress, X component');
  model.result('vibro_harmonicburst_plot').run
end

% Should plot synthetic burst signal:
%  real(solidmech_harmonicburst_laser_displ*exp(i*2*pi*solidmech_harmonicburst.freq*t))
%  ... if we can figure out how!


if DataSetExistsForSolution(model,'heatflow_solution')
  CreateOrReplace(model.result,'vibro_heating_plot','PlotGroup3D');
  model.result('vibro_heating_plot').label('vibro_heating_plot');

  if string_in_cellstr_array('specimen_view',cell(model.view.tags))
    model.result('vibro_heating_plot').set('view','specimen_view');
  end
  model.result('vibro_heating_plot').set('data', GetDataSetForSolution(model,'heatflow_solution'));
  model.result('vibro_heating_plot').create('vibro_heating_plot_surface', 'Surface');
  model.result('vibro_heating_plot').feature('vibro_heating_plot_surface').set('expr', '(T-293.15)*simulationsurfaceemissivity + cameranoise(x,y,z)');
  model.result('vibro_heating_plot').feature('vibro_heating_plot_surface').set('descr', 'Temperature');
  %model.result('vibro_heating_plot').setIndex('looplevel', '50', 0);
  model.result('vibro_heating_plot').feature('vibro_heating_plot_surface').label('vibro_heating_plot_surface');
  model.result('vibro_heating_plot').feature('vibro_heating_plot_surface').set('rangecoloractive', 'on');
  model.result('vibro_heating_plot').feature('vibro_heating_plot_surface').set('rangecolormin', '-.025');
  model.result('vibro_heating_plot').feature('vibro_heating_plot_surface').set('rangecolormax', '.5');
  model.result('vibro_heating_plot').run;
end

if DataSetExistsForSolution(model,'solidmech_modal_solution')
  %model.result.export.create('data1', 'dset2', 'Data');
  CreateOrReplace(model.result.export,'solidmech_modal_export',GetDataSetForSolution(model,'solidmech_modal_solution'),'Data');
  model.result.export('solidmech_modal_export').label('Modal frequencies');
  model.result.export('solidmech_modal_export').set('expr', {'freq'});
  model.result.export('solidmech_modal_export').set('descr', {'Frequency'});
  %model.result.export('data1').set('filename', '/home/sdh4/welder_modeling_COMSOL/cantilever_model_modalanal_2019-07-10.txt');
  % model.result.export('solidmech_model_export').run;
end


if DataSetExistsForSolution(model,'solidmech_multisweep_seg1_solution')

  if string_in_cellstr_array('crack_centerstrain',to_cellstr_array(model.variable.tags))

    CreateOrReplace(model.result.numerical,'solidmech_multisweep_seg1_crackcenterstrain','EvalGlobal');
    model.result.numerical('solidmech_multisweep_seg1_crackcenterstrain').label('solidmech_multisweep_seg1_crackcenterstrain');
    model.result.numerical('solidmech_multisweep_seg1_crackcenterstrain').set('data',GetDataSetForSolution(model,'solidmech_multisweep_seg1_solution'));
    
    model.result.numerical('solidmech_multisweep_seg1_crackcenterstrain').setIndex('expr','crack_centerstrainmag_solidmech_multisweep',0);
    model.result.numerical('solidmech_multisweep_seg1_crackcenterstrain').setIndex('descr','Magnitude_of_strain_at_crack_center_seg1',0);
    model.result.numerical('solidmech_multisweep_seg1_crackcenterstrain').setIndex('expr','crack_centerstrainnormal_solidmech_multisweep',1);
    model.result.numerical('solidmech_multisweep_seg1_crackcenterstrain').setIndex('descr','Normal_strain_at_crack_center_seg1',1);
    model.result.numerical('solidmech_multisweep_seg1_crackcenterstrain').setIndex('expr','crack_centerstrainshear_solidmech_multisweep',2);
    model.result.numerical('solidmech_multisweep_seg1_crackcenterstrain').setIndex('descr','Shear_strain_at_crack_center_seg1',2);

    CreateOrReplace(model.result.table,'solidmech_multisweep_seg1_crackcenterstrain_table','Table');
    model.result.table('solidmech_multisweep_seg1_crackcenterstrain_table').label('solidmech_multisweep_seg1_crackcenterstrain_table');
    model.result.table('solidmech_multisweep_seg1_crackcenterstrain_table').set('tablebuffersize','1000000');
    model.result.numerical('solidmech_multisweep_seg1_crackcenterstrain').set('table','solidmech_multisweep_seg1_crackcenterstrain_table');
    
    if exist('output_base_filename','var') % if base filename was provided
      model.result.table('solidmech_multisweep_seg1_crackcenterstrain_table').set('storetable','inmodelandonfile');
      model.result.table('solidmech_multisweep_seg1_crackcenterstrain_table').set('filename',sprintf('%s_crackcenterstrainspec_seg1.txt',output_base_filename));
       
    end
       
    model.result.numerical('solidmech_multisweep_seg1_crackcenterstrain').run;
    model.result.numerical('solidmech_multisweep_seg1_crackcenterstrain').setResult;


  end

  if string_in_cellstr_array('solidmech_multisweep_laser',cell(model.probe.tags))
    % Manually create data set, derived value, and table to store
    % the probe output. We need to increase the max # of rows in the table!
     
    %CreateOrReplace(model.result.dataset,'custom_solidmech_multisweep_solution','Solution');
    %model.result.dataset('custom_solidmech_multisweep_solution').set('solution','solidmech_multisweep_solution');
    %model.result.dataset('custom_solidmech_multisweep_solution').set('frametype','geometry');

    CreateOrReplace(model.result.dataset,'custom_solidmech_multisweep_seg1_laser','CutPoint3D');
    model.result.dataset('custom_solidmech_multisweep_seg1_laser').label('custom_solidmech_multisweep_seg1_laser');
    model.result.dataset('custom_solidmech_multisweep_seg1_laser').set('data',GetDataSetForSolution(model,'solidmech_multisweep_seg1_solution'));
    probepoint = model.probe('solidmech_multisweep_laser').getStringMatrix('coords');
    model.result.dataset('custom_solidmech_multisweep_seg1_laser').set('pointx', probepoint(1,1)); % This extracts the coordinates from the laser probe
    model.result.dataset('custom_solidmech_multisweep_seg1_laser').set('pointy', probepoint(1,2)); % This extracts the coordinates from the laser probe
    model.result.dataset('custom_solidmech_multisweep_seg1_laser').set('pointz', probepoint(1,3)); % This extracts the coordinates from the laser probe
    model.result.dataset('custom_solidmech_multisweep_seg1_laser').set('bndsnap','on');
    model.result.dataset('custom_solidmech_multisweep_seg1_laser').run;

    % laser displacement
    CreateOrReplace(model.result.numerical,'custom_solidmech_multisweep_seg1_laser_displ','EvalPoint');
    model.result.numerical('custom_solidmech_multisweep_seg1_laser_displ').label('custom_solidmech_multisweep_seg1_laser_displ');
    model.result.numerical('custom_solidmech_multisweep_seg1_laser_displ').set('data','custom_solidmech_multisweep_seg1_laser');
    
    model.result.numerical('custom_solidmech_multisweep_seg1_laser_displ').setIndex('expr',model.probe('solidmech_multisweep_laser').feature('solidmech_multisweep_laser_displ').getString('expr'),0);


    CreateOrReplace(model.result.table,'custom_solidmech_multisweep_seg1_laser_displ_table','Table');
    model.result.table('custom_solidmech_multisweep_seg1_laser_displ_table').label('custom_solidmech_multisweep_seg1_laser_displ_table');
    model.result.table('custom_solidmech_multisweep_seg1_laser_displ_table').set('tablebuffersize','1000000');
    model.result.numerical('custom_solidmech_multisweep_seg1_laser_displ').set('table','custom_solidmech_multisweep_seg1_laser_displ_table');

    if exist('output_base_filename','var') % if base filename was provided
      model.result.table('custom_solidmech_multisweep_seg1_laser_displ_table').set('storetable','inmodelandonfile');
      model.result.table('custom_solidmech_multisweep_seg1_laser_displ_table').set('filename',sprintf('%s_laser_dispspec_seg1.txt',output_base_filename));
       
    end
       
    model.result.numerical('custom_solidmech_multisweep_seg1_laser_displ').run;
    model.result.numerical('custom_solidmech_multisweep_seg1_laser_displ').setResult;


    
    % Now do the velocity output
    CreateOrReplace(model.result.numerical,'custom_solidmech_multisweep_seg1_laser_vel','EvalPoint');
    model.result.numerical('custom_solidmech_multisweep_seg1_laser_vel').label('custom_solidmech_multisweep_seg1_laser_vel');
    model.result.numerical('custom_solidmech_multisweep_seg1_laser_vel').set('data','custom_solidmech_multisweep_seg1_laser');
    
    model.result.numerical('custom_solidmech_multisweep_seg1_laser_vel').setIndex('expr',model.probe('solidmech_multisweep_laser').feature('solidmech_multisweep_laser_vel').getString('expr'),0);


    CreateOrReplace(model.result.table,'custom_solidmech_multisweep_seg1_laser_vel_table','Table');
    model.result.table('custom_solidmech_multisweep_seg1_laser_vel_table').label('custom_solidmech_multisweep_seg1_laser_vel_table');
    model.result.table('custom_solidmech_multisweep_seg1_laser_vel_table').set('tablebuffersize','1000000');
    model.result.numerical('custom_solidmech_multisweep_seg1_laser_vel').set('table','custom_solidmech_multisweep_seg1_laser_vel_table');


    if exist('output_base_filename','var') % if base filename was provided
      model.result.table('custom_solidmech_multisweep_seg1_laser_vel_table').set('storetable','inmodelandonfile');
      model.result.table('custom_solidmech_multisweep_seg1_laser_vel_table').set('filename',sprintf('%s_laser_velspec_seg1.txt',output_base_filename));       
    end
    
    model.result.numerical('custom_solidmech_multisweep_seg1_laser_vel').run;
    model.result.numerical('custom_solidmech_multisweep_seg1_laser_vel').setResult;


    % Create laser plots
    CreateOrReplace(model.result,'custom_solidmech_multisweep_seg1_laser_dispabs_plot','PlotGroup1D');
    model.result('custom_solidmech_multisweep_seg1_laser_dispabs_plot').label('custom_solidmech_multisweep_seg1_laser_dispabs_plot');
    model.result('custom_solidmech_multisweep_seg1_laser_dispabs_plot').set('data','custom_solidmech_multisweep_seg1_laser');
    model.result('custom_solidmech_multisweep_seg1_laser_dispabs_plot').create('custom_solidmech_multisweep_seg1_laser_disp_abs','PointGraph');
    model.result('custom_solidmech_multisweep_seg1_laser_dispabs_plot').feature('custom_solidmech_multisweep_seg1_laser_disp_abs').label('custom_solidmech_multisweep_seg1_laser_disp_abs');
    model.result('custom_solidmech_multisweep_seg1_laser_dispabs_plot').feature('custom_solidmech_multisweep_seg1_laser_disp_abs').set('expr',sprintf('abs(%s)',to_string(model.probe('solidmech_multisweep_laser').feature('solidmech_multisweep_laser_displ').getString('expr'))));
    model.result('custom_solidmech_multisweep_seg1_laser_dispabs_plot').set('xlog', true);
    model.result('custom_solidmech_multisweep_seg1_laser_dispabs_plot').set('ylog', true);
    model.result('custom_solidmech_multisweep_seg1_laser_dispabs_plot').run;


    CreateOrReplace(model.result,'custom_solidmech_multisweep_seg1_laser_dispangle_plot','PlotGroup1D');
    model.result('custom_solidmech_multisweep_seg1_laser_dispangle_plot').label('custom_solidmech_multisweep_seg1_laser_dispangle_plot');
    model.result('custom_solidmech_multisweep_seg1_laser_dispangle_plot').set('data','custom_solidmech_multisweep_seg1_laser');
    model.result('custom_solidmech_multisweep_seg1_laser_dispangle_plot').create('custom_solidmech_multisweep_seg1_laser_disp_angle','PointGraph');
    model.result('custom_solidmech_multisweep_seg1_laser_dispangle_plot').feature('custom_solidmech_multisweep_seg1_laser_disp_angle').label('custom_solidmech_multisweep_seg1_laser_disp_angle');
    model.result('custom_solidmech_multisweep_seg1_laser_dispangle_plot').feature('custom_solidmech_multisweep_seg1_laser_disp_angle').set('expr',sprintf('imag(log(%s))',to_string(model.probe('solidmech_multisweep_laser').feature('solidmech_multisweep_laser_displ').getString('expr'))));
    model.result('custom_solidmech_multisweep_seg1_laser_dispangle_plot').set('xlog', true);
    model.result('custom_solidmech_multisweep_seg1_laser_dispangle_plot').set('ylog', false);
    model.result('custom_solidmech_multisweep_seg1_laser_dispangle_plot').run;


    CreateOrReplace(model.result,'custom_solidmech_multisweep_seg1_laser_velabs_plot','PlotGroup1D');
    model.result('custom_solidmech_multisweep_seg1_laser_velabs_plot').label('custom_solidmech_multisweep_seg1_laser_velabs_plot');
    model.result('custom_solidmech_multisweep_seg1_laser_velabs_plot').set('data','custom_solidmech_multisweep_seg1_laser');
    model.result('custom_solidmech_multisweep_seg1_laser_velabs_plot').create('custom_solidmech_multisweep_seg1_laser_vel_abs','PointGraph');
    model.result('custom_solidmech_multisweep_seg1_laser_velabs_plot').feature('custom_solidmech_multisweep_seg1_laser_vel_abs').label('custom_solidmech_multisweep_seg1_laser_vel_abs');
    model.result('custom_solidmech_multisweep_seg1_laser_velabs_plot').feature('custom_solidmech_multisweep_seg1_laser_vel_abs').set('expr',sprintf('abs(%s)',to_string(model.probe('solidmech_multisweep_laser').feature('solidmech_multisweep_laser_vel').getString('expr'))));
    model.result('custom_solidmech_multisweep_seg1_laser_velabs_plot').set('xlog', true);
    model.result('custom_solidmech_multisweep_seg1_laser_velabs_plot').set('ylog', true);
    model.result('custom_solidmech_multisweep_seg1_laser_velabs_plot').run;


    CreateOrReplace(model.result,'custom_solidmech_multisweep_seg1_laser_velangle_plot','PlotGroup1D');
    model.result('custom_solidmech_multisweep_seg1_laser_velangle_plot').label('custom_solidmech_multisweep_seg1_laser_velangle_plot');
    model.result('custom_solidmech_multisweep_seg1_laser_velangle_plot').set('data','custom_solidmech_multisweep_seg1_laser');
    model.result('custom_solidmech_multisweep_seg1_laser_velangle_plot').create('custom_solidmech_multisweep_seg1_laser_vel_angle','PointGraph');
    model.result('custom_solidmech_multisweep_seg1_laser_velangle_plot').feature('custom_solidmech_multisweep_seg1_laser_vel_angle').label('custom_solidmech_multisweep_seg1_laser_vel_angle');
    model.result('custom_solidmech_multisweep_seg1_laser_velangle_plot').feature('custom_solidmech_multisweep_seg1_laser_vel_angle').set('expr',sprintf('imag(log(%s))',to_string(model.probe('solidmech_multisweep_laser').feature('solidmech_multisweep_laser_vel').getString('expr'))));
    model.result('custom_solidmech_multisweep_seg1_laser_velangle_plot').set('xlog', true);
    model.result('custom_solidmech_multisweep_seg1_laser_velangle_plot').set('ylog', false);
    model.result('custom_solidmech_multisweep_seg1_laser_velangle_plot').run;
    
  end
  
  if string_in_cellstr_array('vibrodynamic_multisweep_xducercontactprobe',cell(model.probe.tags))
    % Manually create data set, derived value, and table to store
    % the probe output. We need to increase the max # of rows in the table!
     
    %CreateOrReplace(model.result.dataset,'custom_solidmech_multisweep_solution','Solution');
    %model.result.dataset('custom_solidmech_multisweep_solution').set('solution','solidmech_multisweep_solution');
    %model.result.dataset('custom_solidmech_multisweep_solution').set('frametype','geometry');

    CreateOrReplace(model.result.dataset,'custom_vibrodynamic_multisweep_seg1_xducercontactprobe','CutPoint3D');
    model.result.dataset('custom_vibrodynamic_multisweep_seg1_xducercontactprobe').label('custom_vibrodynamic_multisweep_seg1_xducercontactprobe');
    model.result.dataset('custom_vibrodynamic_multisweep_seg1_xducercontactprobe').set('data',GetDataSetForSolution(model,'solidmech_multisweep_seg1_solution')); % 'custom_solidmech_timedomain_solution');
    probepoint = model.probe('vibrodynamic_multisweep_xducercontactprobe').getStringMatrix('coords');
    model.result.dataset('custom_vibrodynamic_multisweep_seg1_xducercontactprobe').set('pointx', probepoint(1,1)); % This extracts the coordinates from the laser probe
    model.result.dataset('custom_vibrodynamic_multisweep_seg1_xducercontactprobe').set('pointy', probepoint(1,2)); % This extracts the coordinates from the laser probe
    model.result.dataset('custom_vibrodynamic_multisweep_seg1_xducercontactprobe').set('pointz', probepoint(1,3)); % This extracts the coordinates from the laser probe
    model.result.dataset('custom_vibrodynamic_multisweep_seg1_xducercontactprobe').set('bndsnap','on');
    model.result.dataset('custom_vibrodynamic_multisweep_seg1_xducercontactprobe').run;

    CreateOrReplace(model.result.numerical,'custom_vibrodynamic_multisweep_seg1_xducercontactprobe_displ','EvalPoint');
    model.result.numerical('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_displ').label('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_displ');
    model.result.numerical('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_displ').set('data','custom_vibrodynamic_multisweep_seg1_xducercontactprobe');
    
    model.result.numerical('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_displ').setIndex('expr',model.probe('vibrodynamic_multisweep_xducercontactprobe').feature('vibrodynamic_multisweep_xducercontactprobe_displ').getString('expr'),0);


    CreateOrReplace(model.result.table,'custom_vibrodynamic_multisweep_seg1_xducercontactprobe_displ_table','Table');
    model.result.table('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_displ_table').label('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_displ_table');
    model.result.table('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_displ_table').set('tablebuffersize','1000000');
    model.result.numerical('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_displ').set('table','custom_vibrodynamic_multisweep_seg1_xducercontactprobe_displ_table');

    if exist('output_base_filename','var') % if base filename was provided
      model.result.table('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_displ_table').set('storetable','inmodelandonfile');
      model.result.table('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_displ_table').set('filename',sprintf('%s_xducercontactprobe_dispspec_seg1.txt',output_base_filename));
       
    end
           
    model.result.numerical('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_displ').run;
    model.result.numerical('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_displ').setResult;

     
    % Now do the velocity output
    CreateOrReplace(model.result.numerical,'custom_vibrodynamic_multisweep_seg1_xducercontactprobe_vel','EvalPoint');
    model.result.numerical('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_vel').label('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_vel');
    model.result.numerical('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_vel').set('data','custom_vibrodynamic_multisweep_seg1_xducercontactprobe');
    
    model.result.numerical('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_vel').setIndex('expr',model.probe('vibrodynamic_multisweep_xducercontactprobe').feature('vibrodynamic_multisweep_xducercontactprobe_vel').getString('expr'),0);


    CreateOrReplace(model.result.table,'custom_vibrodynamic_multisweep_seg1_xducercontactprobe_vel_table','Table');
    model.result.table('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_vel_table').label('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_vel_table');
    model.result.table('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_vel_table').set('tablebuffersize','1000000');
    model.result.numerical('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_vel').set('table','custom_vibrodynamic_multisweep_seg1_xducercontactprobe_vel_table');
    
    if exist('output_base_filename','var') % if base filename was provided
      model.result.table('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_vel_table').set('storetable','inmodelandonfile');
      model.result.table('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_vel_table').set('filename',sprintf('%s_xducercontactprobe_velspec_seg1.txt',output_base_filename));
       
    end

    model.result.numerical('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_vel').run;
    model.result.numerical('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_vel').setResult;



    % Create xducercontact plots


    CreateOrReplace(model.result,'custom_vibrodynamic_multisweep_seg1_xducercontactprobe_dispabs_plot','PlotGroup1D');
    model.result('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_dispabs_plot').label('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_dispabs_plot');
    model.result('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_dispabs_plot').set('data','custom_vibrodynamic_multisweep_seg1_xducercontactprobe');
    model.result('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_dispabs_plot').create('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_disp_abs','PointGraph');
    model.result('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_dispabs_plot').feature('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_disp_abs').label('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_disp_abs');
    model.result('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_dispabs_plot').feature('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_disp_abs').set('expr',sprintf('abs(%s)',to_string(model.probe('vibrodynamic_multisweep_xducercontactprobe').feature('vibrodynamic_multisweep_xducercontactprobe_displ').getString('expr'))));
    model.result('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_dispabs_plot').set('xlog', true);
    model.result('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_dispabs_plot').set('ylog', true);
    model.result('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_dispabs_plot').run;


    CreateOrReplace(model.result,'custom_vibrodynamic_multisweep_seg1_xducercontactprobe_dispangle_plot','PlotGroup1D');
    model.result('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_dispangle_plot').label('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_dispangle_plot');
    model.result('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_dispangle_plot').set('data','custom_vibrodynamic_multisweep_seg1_xducercontactprobe');
    model.result('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_dispangle_plot').create('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_disp_angle','PointGraph');
    model.result('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_dispangle_plot').feature('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_disp_angle').label('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_disp_angle');
    model.result('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_dispangle_plot').feature('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_disp_angle').set('expr',sprintf('imag(log(%s))',to_string(model.probe('vibrodynamic_multisweep_xducercontactprobe').feature('vibrodynamic_multisweep_xducercontactprobe_displ').getString('expr'))));
    model.result('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_dispangle_plot').set('xlog', true);
    model.result('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_dispangle_plot').set('ylog', false);
    model.result('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_dispangle_plot').run;


    CreateOrReplace(model.result,'custom_vibrodynamic_multisweep_seg1_xducercontactprobe_velabs_plot','PlotGroup1D');
    model.result('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_velabs_plot').label('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_velabs_plot');
    model.result('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_velabs_plot').set('data','custom_vibrodynamic_multisweep_seg1_xducercontactprobe');
    model.result('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_velabs_plot').create('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_vel_abs','PointGraph');
    model.result('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_velabs_plot').feature('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_vel_abs').label('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_vel_abs');
    model.result('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_velabs_plot').feature('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_vel_abs').set('expr',sprintf('abs(%s)',to_string(model.probe('vibrodynamic_multisweep_xducercontactprobe').feature('vibrodynamic_multisweep_xducercontactprobe_vel').getString('expr'))));
    model.result('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_velabs_plot').set('xlog', true);
    model.result('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_velabs_plot').set('ylog', true);
    model.result('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_velabs_plot').run;


    CreateOrReplace(model.result,'custom_vibrodynamic_multisweep_seg1_xducercontactprobe_velangle_plot','PlotGroup1D');
    model.result('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_velangle_plot').label('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_velangle_plot');
    model.result('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_velangle_plot').set('data','custom_vibrodynamic_multisweep_seg1_xducercontactprobe');
    model.result('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_velangle_plot').create('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_vel_angle','PointGraph');
    model.result('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_velangle_plot').feature('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_vel_angle').label('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_vel_angle');
    model.result('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_velangle_plot').feature('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_vel_angle').set('expr',sprintf('imag(log(%s))',to_string(model.probe('vibrodynamic_multisweep_xducercontactprobe').feature('vibrodynamic_multisweep_xducercontactprobe_vel').getString('expr'))));
    model.result('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_velangle_plot').set('xlog', true);
    model.result('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_velangle_plot').set('ylog', false);
    model.result('custom_vibrodynamic_multisweep_seg1_xducercontactprobe_velangle_plot').run;



  end





end



if DataSetExistsForSolution(model,'solidmech_multisweep_seg2_solution')

  if string_in_cellstr_array('crack_centerstrain',to_cellstr_array(model.variable.tags))

    CreateOrReplace(model.result.numerical,'solidmech_multisweep_seg2_crackcenterstrain','EvalGlobal');
    model.result.numerical('solidmech_multisweep_seg2_crackcenterstrain').label('solidmech_multisweep_seg2_crackcenterstrain');
    model.result.numerical('solidmech_multisweep_seg2_crackcenterstrain').set('data',GetDataSetForSolution(model,'solidmech_multisweep_seg2_solution'));
    
    model.result.numerical('solidmech_multisweep_seg2_crackcenterstrain').setIndex('expr','crack_centerstrainmag_solidmech_multisweep',0);
    model.result.numerical('solidmech_multisweep_seg2_crackcenterstrain').setIndex('descr','Magnitude_of_strain_at_crack_center_seg2',0);
    model.result.numerical('solidmech_multisweep_seg2_crackcenterstrain').setIndex('expr','crack_centerstrainnormal_solidmech_multisweep',1);
    model.result.numerical('solidmech_multisweep_seg2_crackcenterstrain').setIndex('descr','Normal_strain_at_crack_center_seg2',1);
    model.result.numerical('solidmech_multisweep_seg2_crackcenterstrain').setIndex('expr','crack_centerstrainshear_solidmech_multisweep',2);
    model.result.numerical('solidmech_multisweep_seg2_crackcenterstrain').setIndex('descr','Shear_strain_at_crack_center_seg2',2);

    CreateOrReplace(model.result.table,'solidmech_multisweep_seg2_crackcenterstrain_table','Table');
    model.result.table('solidmech_multisweep_seg2_crackcenterstrain_table').label('solidmech_multisweep_seg2_crackcenterstrain_table');
    model.result.table('solidmech_multisweep_seg2_crackcenterstrain_table').set('tablebuffersize','1000000');
    model.result.numerical('solidmech_multisweep_seg2_crackcenterstrain').set('table','solidmech_multisweep_seg2_crackcenterstrain_table');
    
    if exist('output_base_filename','var') % if base filename was provided
      model.result.table('solidmech_multisweep_seg2_crackcenterstrain_table').set('storetable','inmodelandonfile');
      model.result.table('solidmech_multisweep_seg2_crackcenterstrain_table').set('filename',sprintf('%s_crackcenterstrainspec_seg2.txt',output_base_filename));
       
    end
       
    model.result.numerical('solidmech_multisweep_seg2_crackcenterstrain').run;
    model.result.numerical('solidmech_multisweep_seg2_crackcenterstrain').setResult;


  end

  if string_in_cellstr_array('solidmech_multisweep_laser',cell(model.probe.tags))
    % Manually create data set, derived value, and table to store
    % the probe output. We need to increase the max # of rows in the table!
     
    %CreateOrReplace(model.result.dataset,'custom_solidmech_multisweep_solution','Solution');
    %model.result.dataset('custom_solidmech_multisweep_solution').set('solution','solidmech_multisweep_solution');
    %model.result.dataset('custom_solidmech_multisweep_solution').set('frametype','geometry');

    CreateOrReplace(model.result.dataset,'custom_solidmech_multisweep_seg2_laser','CutPoint3D');
    model.result.dataset('custom_solidmech_multisweep_seg2_laser').label('custom_solidmech_multisweep_seg2_laser');
    model.result.dataset('custom_solidmech_multisweep_seg2_laser').set('data',GetDataSetForSolution(model,'solidmech_multisweep_seg2_solution'));
    probepoint = model.probe('solidmech_multisweep_laser').getStringMatrix('coords');
    model.result.dataset('custom_solidmech_multisweep_seg2_laser').set('pointx', probepoint(1,1)); % This extracts the coordinates from the laser probe
    model.result.dataset('custom_solidmech_multisweep_seg2_laser').set('pointy', probepoint(1,2)); % This extracts the coordinates from the laser probe
    model.result.dataset('custom_solidmech_multisweep_seg2_laser').set('pointz', probepoint(1,3)); % This extracts the coordinates from the laser probe
    model.result.dataset('custom_solidmech_multisweep_seg2_laser').set('bndsnap','on');
    model.result.dataset('custom_solidmech_multisweep_seg2_laser').run;

    % laser displacement
    CreateOrReplace(model.result.numerical,'custom_solidmech_multisweep_seg2_laser_displ','EvalPoint');
    model.result.numerical('custom_solidmech_multisweep_seg2_laser_displ').label('custom_solidmech_multisweep_seg2_laser_displ');
    model.result.numerical('custom_solidmech_multisweep_seg2_laser_displ').set('data','custom_solidmech_multisweep_seg2_laser');
    
    model.result.numerical('custom_solidmech_multisweep_seg2_laser_displ').setIndex('expr',model.probe('solidmech_multisweep_laser').feature('solidmech_multisweep_laser_displ').getString('expr'),0);


    CreateOrReplace(model.result.table,'custom_solidmech_multisweep_seg2_laser_displ_table','Table');
    model.result.table('custom_solidmech_multisweep_seg2_laser_displ_table').label('custom_solidmech_multisweep_seg2_laser_displ_table');
    model.result.table('custom_solidmech_multisweep_seg2_laser_displ_table').set('tablebuffersize','1000000');
    model.result.numerical('custom_solidmech_multisweep_seg2_laser_displ').set('table','custom_solidmech_multisweep_seg2_laser_displ_table');

    if exist('output_base_filename','var') % if base filename was provided
      model.result.table('custom_solidmech_multisweep_seg2_laser_displ_table').set('storetable','inmodelandonfile');
      model.result.table('custom_solidmech_multisweep_seg2_laser_displ_table').set('filename',sprintf('%s_laser_dispspec_seg2.txt',output_base_filename));
       
    end
       
    model.result.numerical('custom_solidmech_multisweep_seg2_laser_displ').run;
    model.result.numerical('custom_solidmech_multisweep_seg2_laser_displ').setResult;


    
    % Now do the velocity output
    CreateOrReplace(model.result.numerical,'custom_solidmech_multisweep_seg2_laser_vel','EvalPoint');
    model.result.numerical('custom_solidmech_multisweep_seg2_laser_vel').label('custom_solidmech_multisweep_seg2_laser_vel');
    model.result.numerical('custom_solidmech_multisweep_seg2_laser_vel').set('data','custom_solidmech_multisweep_seg2_laser');
    
    model.result.numerical('custom_solidmech_multisweep_seg2_laser_vel').setIndex('expr',model.probe('solidmech_multisweep_laser').feature('solidmech_multisweep_laser_vel').getString('expr'),0);


    CreateOrReplace(model.result.table,'custom_solidmech_multisweep_seg2_laser_vel_table','Table');
    model.result.table('custom_solidmech_multisweep_seg2_laser_vel_table').label('custom_solidmech_multisweep_seg2_laser_vel_table');
    model.result.table('custom_solidmech_multisweep_seg2_laser_vel_table').set('tablebuffersize','1000000');
    model.result.numerical('custom_solidmech_multisweep_seg2_laser_vel').set('table','custom_solidmech_multisweep_seg2_laser_vel_table');


    if exist('output_base_filename','var') % if base filename was provided
      model.result.table('custom_solidmech_multisweep_seg2_laser_vel_table').set('storetable','inmodelandonfile');
      model.result.table('custom_solidmech_multisweep_seg2_laser_vel_table').set('filename',sprintf('%s_laser_velspec_seg2.txt',output_base_filename));       
    end
    
    model.result.numerical('custom_solidmech_multisweep_seg2_laser_vel').run;
    model.result.numerical('custom_solidmech_multisweep_seg2_laser_vel').setResult;


    % Create laser plots
    CreateOrReplace(model.result,'custom_solidmech_multisweep_seg2_laser_dispabs_plot','PlotGroup1D');
    model.result('custom_solidmech_multisweep_seg2_laser_dispabs_plot').label('custom_solidmech_multisweep_seg2_laser_dispabs_plot');
    model.result('custom_solidmech_multisweep_seg2_laser_dispabs_plot').set('data','custom_solidmech_multisweep_seg2_laser');
    model.result('custom_solidmech_multisweep_seg2_laser_dispabs_plot').create('custom_solidmech_multisweep_seg2_laser_disp_abs','PointGraph');
    model.result('custom_solidmech_multisweep_seg2_laser_dispabs_plot').feature('custom_solidmech_multisweep_seg2_laser_disp_abs').label('custom_solidmech_multisweep_seg2_laser_disp_abs');
    model.result('custom_solidmech_multisweep_seg2_laser_dispabs_plot').feature('custom_solidmech_multisweep_seg2_laser_disp_abs').set('expr',sprintf('abs(%s)',to_string(model.probe('solidmech_multisweep_laser').feature('solidmech_multisweep_laser_displ').getString('expr'))));
    model.result('custom_solidmech_multisweep_seg2_laser_dispabs_plot').set('xlog', true);
    model.result('custom_solidmech_multisweep_seg2_laser_dispabs_plot').set('ylog', true);
    model.result('custom_solidmech_multisweep_seg2_laser_dispabs_plot').run;


    CreateOrReplace(model.result,'custom_solidmech_multisweep_seg2_laser_dispangle_plot','PlotGroup1D');
    model.result('custom_solidmech_multisweep_seg2_laser_dispangle_plot').label('custom_solidmech_multisweep_seg2_laser_dispangle_plot');
    model.result('custom_solidmech_multisweep_seg2_laser_dispangle_plot').set('data','custom_solidmech_multisweep_seg2_laser');
    model.result('custom_solidmech_multisweep_seg2_laser_dispangle_plot').create('custom_solidmech_multisweep_seg2_laser_disp_angle','PointGraph');
    model.result('custom_solidmech_multisweep_seg2_laser_dispangle_plot').feature('custom_solidmech_multisweep_seg2_laser_disp_angle').label('custom_solidmech_multisweep_seg2_laser_disp_angle');
    model.result('custom_solidmech_multisweep_seg2_laser_dispangle_plot').feature('custom_solidmech_multisweep_seg2_laser_disp_angle').set('expr',sprintf('imag(log(%s))',to_string(model.probe('solidmech_multisweep_laser').feature('solidmech_multisweep_laser_displ').getString('expr'))));
    model.result('custom_solidmech_multisweep_seg2_laser_dispangle_plot').set('xlog', true);
    model.result('custom_solidmech_multisweep_seg2_laser_dispangle_plot').set('ylog', false);
    model.result('custom_solidmech_multisweep_seg2_laser_dispangle_plot').run;


    CreateOrReplace(model.result,'custom_solidmech_multisweep_seg2_laser_velabs_plot','PlotGroup1D');
    model.result('custom_solidmech_multisweep_seg2_laser_velabs_plot').label('custom_solidmech_multisweep_seg2_laser_velabs_plot');
    model.result('custom_solidmech_multisweep_seg2_laser_velabs_plot').set('data','custom_solidmech_multisweep_seg2_laser');
    model.result('custom_solidmech_multisweep_seg2_laser_velabs_plot').create('custom_solidmech_multisweep_seg2_laser_vel_abs','PointGraph');
    model.result('custom_solidmech_multisweep_seg2_laser_velabs_plot').feature('custom_solidmech_multisweep_seg2_laser_vel_abs').label('custom_solidmech_multisweep_seg2_laser_vel_abs');
    model.result('custom_solidmech_multisweep_seg2_laser_velabs_plot').feature('custom_solidmech_multisweep_seg2_laser_vel_abs').set('expr',sprintf('abs(%s)',to_string(model.probe('solidmech_multisweep_laser').feature('solidmech_multisweep_laser_vel').getString('expr'))));
    model.result('custom_solidmech_multisweep_seg2_laser_velabs_plot').set('xlog', true);
    model.result('custom_solidmech_multisweep_seg2_laser_velabs_plot').set('ylog', true);
    model.result('custom_solidmech_multisweep_seg2_laser_velabs_plot').run;


    CreateOrReplace(model.result,'custom_solidmech_multisweep_seg2_laser_velangle_plot','PlotGroup1D');
    model.result('custom_solidmech_multisweep_seg2_laser_velangle_plot').label('custom_solidmech_multisweep_seg2_laser_velangle_plot');
    model.result('custom_solidmech_multisweep_seg2_laser_velangle_plot').set('data','custom_solidmech_multisweep_seg2_laser');
    model.result('custom_solidmech_multisweep_seg2_laser_velangle_plot').create('custom_solidmech_multisweep_seg2_laser_vel_angle','PointGraph');
    model.result('custom_solidmech_multisweep_seg2_laser_velangle_plot').feature('custom_solidmech_multisweep_seg2_laser_vel_angle').label('custom_solidmech_multisweep_seg2_laser_vel_angle');
    model.result('custom_solidmech_multisweep_seg2_laser_velangle_plot').feature('custom_solidmech_multisweep_seg2_laser_vel_angle').set('expr',sprintf('imag(log(%s))',to_string(model.probe('solidmech_multisweep_laser').feature('solidmech_multisweep_laser_vel').getString('expr'))));
    model.result('custom_solidmech_multisweep_seg2_laser_velangle_plot').set('xlog', true);
    model.result('custom_solidmech_multisweep_seg2_laser_velangle_plot').set('ylog', false);
    model.result('custom_solidmech_multisweep_seg2_laser_velangle_plot').run;
    
  end
  
  if string_in_cellstr_array('vibrodynamic_multisweep_xducercontactprobe',cell(model.probe.tags))
    % Manually create data set, derived value, and table to store
    % the probe output. We need to increase the max # of rows in the table!
     
    %CreateOrReplace(model.result.dataset,'custom_solidmech_multisweep_solution','Solution');
    %model.result.dataset('custom_solidmech_multisweep_solution').set('solution','solidmech_multisweep_solution');
    %model.result.dataset('custom_solidmech_multisweep_solution').set('frametype','geometry');

    CreateOrReplace(model.result.dataset,'custom_vibrodynamic_multisweep_seg2_xducercontactprobe','CutPoint3D');
    model.result.dataset('custom_vibrodynamic_multisweep_seg2_xducercontactprobe').label('custom_vibrodynamic_multisweep_seg2_xducercontactprobe');
    model.result.dataset('custom_vibrodynamic_multisweep_seg2_xducercontactprobe').set('data',GetDataSetForSolution(model,'solidmech_multisweep_seg2_solution')); % 'custom_solidmech_timedomain_solution');
    probepoint = model.probe('vibrodynamic_multisweep_xducercontactprobe').getStringMatrix('coords');
    model.result.dataset('custom_vibrodynamic_multisweep_seg2_xducercontactprobe').set('pointx', probepoint(1,1)); % This extracts the coordinates from the laser probe
    model.result.dataset('custom_vibrodynamic_multisweep_seg2_xducercontactprobe').set('pointy', probepoint(1,2)); % This extracts the coordinates from the laser probe
    model.result.dataset('custom_vibrodynamic_multisweep_seg2_xducercontactprobe').set('pointz', probepoint(1,3)); % This extracts the coordinates from the laser probe
    model.result.dataset('custom_vibrodynamic_multisweep_seg2_xducercontactprobe').set('bndsnap','on');
    model.result.dataset('custom_vibrodynamic_multisweep_seg2_xducercontactprobe').run;

    CreateOrReplace(model.result.numerical,'custom_vibrodynamic_multisweep_seg2_xducercontactprobe_displ','EvalPoint');
    model.result.numerical('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_displ').label('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_displ');
    model.result.numerical('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_displ').set('data','custom_vibrodynamic_multisweep_seg2_xducercontactprobe');
    
    model.result.numerical('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_displ').setIndex('expr',model.probe('vibrodynamic_multisweep_xducercontactprobe').feature('vibrodynamic_multisweep_xducercontactprobe_displ').getString('expr'),0);


    CreateOrReplace(model.result.table,'custom_vibrodynamic_multisweep_seg2_xducercontactprobe_displ_table','Table');
    model.result.table('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_displ_table').label('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_displ_table');
    model.result.table('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_displ_table').set('tablebuffersize','1000000');
    model.result.numerical('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_displ').set('table','custom_vibrodynamic_multisweep_seg2_xducercontactprobe_displ_table');

    if exist('output_base_filename','var') % if base filename was provided
      model.result.table('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_displ_table').set('storetable','inmodelandonfile');
      model.result.table('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_displ_table').set('filename',sprintf('%s_xducercontactprobe_dispspec_seg2.txt',output_base_filename));
       
    end
           
    model.result.numerical('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_displ').run;
    model.result.numerical('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_displ').setResult;

     
    % Now do the velocity output
    CreateOrReplace(model.result.numerical,'custom_vibrodynamic_multisweep_seg2_xducercontactprobe_vel','EvalPoint');
    model.result.numerical('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_vel').label('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_vel');
    model.result.numerical('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_vel').set('data','custom_vibrodynamic_multisweep_seg2_xducercontactprobe');
    
    model.result.numerical('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_vel').setIndex('expr',model.probe('vibrodynamic_multisweep_xducercontactprobe').feature('vibrodynamic_multisweep_xducercontactprobe_vel').getString('expr'),0);


    CreateOrReplace(model.result.table,'custom_vibrodynamic_multisweep_seg2_xducercontactprobe_vel_table','Table');
    model.result.table('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_vel_table').label('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_vel_table');
    model.result.table('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_vel_table').set('tablebuffersize','1000000');
    model.result.numerical('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_vel').set('table','custom_vibrodynamic_multisweep_seg2_xducercontactprobe_vel_table');
    
    if exist('output_base_filename','var') % if base filename was provided
      model.result.table('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_vel_table').set('storetable','inmodelandonfile');
      model.result.table('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_vel_table').set('filename',sprintf('%s_xducercontactprobe_velspec_seg2.txt',output_base_filename));
       
    end

    model.result.numerical('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_vel').run;
    model.result.numerical('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_vel').setResult;



    % Create xducercontact plots


    CreateOrReplace(model.result,'custom_vibrodynamic_multisweep_seg2_xducercontactprobe_dispabs_plot','PlotGroup1D');
    model.result('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_dispabs_plot').label('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_dispabs_plot');
    model.result('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_dispabs_plot').set('data','custom_vibrodynamic_multisweep_seg2_xducercontactprobe');
    model.result('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_dispabs_plot').create('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_disp_abs','PointGraph');
    model.result('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_dispabs_plot').feature('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_disp_abs').label('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_disp_abs');
    model.result('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_dispabs_plot').feature('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_disp_abs').set('expr',sprintf('abs(%s)',to_string(model.probe('vibrodynamic_multisweep_xducercontactprobe').feature('vibrodynamic_multisweep_xducercontactprobe_displ').getString('expr'))));
    model.result('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_dispabs_plot').set('xlog', true);
    model.result('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_dispabs_plot').set('ylog', true);
    model.result('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_dispabs_plot').run;


    CreateOrReplace(model.result,'custom_vibrodynamic_multisweep_seg2_xducercontactprobe_dispangle_plot','PlotGroup1D');
    model.result('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_dispangle_plot').label('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_dispangle_plot');
    model.result('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_dispangle_plot').set('data','custom_vibrodynamic_multisweep_seg2_xducercontactprobe');
    model.result('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_dispangle_plot').create('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_disp_angle','PointGraph');
    model.result('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_dispangle_plot').feature('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_disp_angle').label('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_disp_angle');
    model.result('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_dispangle_plot').feature('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_disp_angle').set('expr',sprintf('imag(log(%s))',to_string(model.probe('vibrodynamic_multisweep_xducercontactprobe').feature('vibrodynamic_multisweep_xducercontactprobe_displ').getString('expr'))));
    model.result('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_dispangle_plot').set('xlog', true);
    model.result('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_dispangle_plot').set('ylog', false);
    model.result('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_dispangle_plot').run;


    CreateOrReplace(model.result,'custom_vibrodynamic_multisweep_seg2_xducercontactprobe_velabs_plot','PlotGroup1D');
    model.result('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_velabs_plot').label('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_velabs_plot');
    model.result('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_velabs_plot').set('data','custom_vibrodynamic_multisweep_seg2_xducercontactprobe');
    model.result('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_velabs_plot').create('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_vel_abs','PointGraph');
    model.result('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_velabs_plot').feature('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_vel_abs').label('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_vel_abs');
    model.result('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_velabs_plot').feature('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_vel_abs').set('expr',sprintf('abs(%s)',to_string(model.probe('vibrodynamic_multisweep_xducercontactprobe').feature('vibrodynamic_multisweep_xducercontactprobe_vel').getString('expr'))));
    model.result('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_velabs_plot').set('xlog', true);
    model.result('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_velabs_plot').set('ylog', true);
    model.result('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_velabs_plot').run;


    CreateOrReplace(model.result,'custom_vibrodynamic_multisweep_seg2_xducercontactprobe_velangle_plot','PlotGroup1D');
    model.result('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_velangle_plot').label('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_velangle_plot');
    model.result('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_velangle_plot').set('data','custom_vibrodynamic_multisweep_seg2_xducercontactprobe');
    model.result('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_velangle_plot').create('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_vel_angle','PointGraph');
    model.result('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_velangle_plot').feature('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_vel_angle').label('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_vel_angle');
    model.result('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_velangle_plot').feature('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_vel_angle').set('expr',sprintf('imag(log(%s))',to_string(model.probe('vibrodynamic_multisweep_xducercontactprobe').feature('vibrodynamic_multisweep_xducercontactprobe_vel').getString('expr'))));
    model.result('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_velangle_plot').set('xlog', true);
    model.result('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_velangle_plot').set('ylog', false);
    model.result('custom_vibrodynamic_multisweep_seg2_xducercontactprobe_velangle_plot').run;



  end





end


if DataSetExistsForSolution(model,'solidmech_multisweep_seg3_solution')

  if string_in_cellstr_array('crack_centerstrain',to_cellstr_array(model.variable.tags))

    CreateOrReplace(model.result.numerical,'solidmech_multisweep_seg3_crackcenterstrain','EvalGlobal');
    model.result.numerical('solidmech_multisweep_seg3_crackcenterstrain').label('solidmech_multisweep_seg3_crackcenterstrain');
    model.result.numerical('solidmech_multisweep_seg3_crackcenterstrain').set('data',GetDataSetForSolution(model,'solidmech_multisweep_seg3_solution'));
    
    model.result.numerical('solidmech_multisweep_seg3_crackcenterstrain').setIndex('expr','crack_centerstrainmag_solidmech_multisweep',0);
    model.result.numerical('solidmech_multisweep_seg3_crackcenterstrain').setIndex('descr','Magnitude_of_strain_at_crack_center_seg3',0);
    model.result.numerical('solidmech_multisweep_seg3_crackcenterstrain').setIndex('expr','crack_centerstrainnormal_solidmech_multisweep',1);
    model.result.numerical('solidmech_multisweep_seg3_crackcenterstrain').setIndex('descr','Normal_strain_at_crack_center_seg3',1);
    model.result.numerical('solidmech_multisweep_seg3_crackcenterstrain').setIndex('expr','crack_centerstrainshear_solidmech_multisweep',2);
    model.result.numerical('solidmech_multisweep_seg3_crackcenterstrain').setIndex('descr','Shear_strain_at_crack_center_seg3',2);

    CreateOrReplace(model.result.table,'solidmech_multisweep_seg3_crackcenterstrain_table','Table');
    model.result.table('solidmech_multisweep_seg3_crackcenterstrain_table').label('solidmech_multisweep_seg3_crackcenterstrain_table');
    model.result.table('solidmech_multisweep_seg3_crackcenterstrain_table').set('tablebuffersize','1000000');
    model.result.numerical('solidmech_multisweep_seg3_crackcenterstrain').set('table','solidmech_multisweep_seg3_crackcenterstrain_table');
    
    if exist('output_base_filename','var') % if base filename was provided
      model.result.table('solidmech_multisweep_seg3_crackcenterstrain_table').set('storetable','inmodelandonfile');
      model.result.table('solidmech_multisweep_seg3_crackcenterstrain_table').set('filename',sprintf('%s_crackcenterstrainspec_seg3.txt',output_base_filename));
       
    end
       
    model.result.numerical('solidmech_multisweep_seg3_crackcenterstrain').run;
    model.result.numerical('solidmech_multisweep_seg3_crackcenterstrain').setResult;


  end

  if string_in_cellstr_array('solidmech_multisweep_laser',cell(model.probe.tags))
    % Manually create data set, derived value, and table to store
    % the probe output. We need to increase the max # of rows in the table!
     
    %CreateOrReplace(model.result.dataset,'custom_solidmech_multisweep_solution','Solution');
    %model.result.dataset('custom_solidmech_multisweep_solution').set('solution','solidmech_multisweep_solution');
    %model.result.dataset('custom_solidmech_multisweep_solution').set('frametype','geometry');

    CreateOrReplace(model.result.dataset,'custom_solidmech_multisweep_seg3_laser','CutPoint3D');
    model.result.dataset('custom_solidmech_multisweep_seg3_laser').label('custom_solidmech_multisweep_seg3_laser');
    model.result.dataset('custom_solidmech_multisweep_seg3_laser').set('data',GetDataSetForSolution(model,'solidmech_multisweep_seg3_solution'));
    probepoint = model.probe('solidmech_multisweep_laser').getStringMatrix('coords');
    model.result.dataset('custom_solidmech_multisweep_seg3_laser').set('pointx', probepoint(1,1)); % This extracts the coordinates from the laser probe
    model.result.dataset('custom_solidmech_multisweep_seg3_laser').set('pointy', probepoint(1,2)); % This extracts the coordinates from the laser probe
    model.result.dataset('custom_solidmech_multisweep_seg3_laser').set('pointz', probepoint(1,3)); % This extracts the coordinates from the laser probe
    model.result.dataset('custom_solidmech_multisweep_seg3_laser').set('bndsnap','on');
    model.result.dataset('custom_solidmech_multisweep_seg3_laser').run;

    % laser displacement
    CreateOrReplace(model.result.numerical,'custom_solidmech_multisweep_seg3_laser_displ','EvalPoint');
    model.result.numerical('custom_solidmech_multisweep_seg3_laser_displ').label('custom_solidmech_multisweep_seg3_laser_displ');
    model.result.numerical('custom_solidmech_multisweep_seg3_laser_displ').set('data','custom_solidmech_multisweep_seg3_laser');
    
    model.result.numerical('custom_solidmech_multisweep_seg3_laser_displ').setIndex('expr',model.probe('solidmech_multisweep_laser').feature('solidmech_multisweep_laser_displ').getString('expr'),0);


    CreateOrReplace(model.result.table,'custom_solidmech_multisweep_seg3_laser_displ_table','Table');
    model.result.table('custom_solidmech_multisweep_seg3_laser_displ_table').label('custom_solidmech_multisweep_seg3_laser_displ_table');
    model.result.table('custom_solidmech_multisweep_seg3_laser_displ_table').set('tablebuffersize','1000000');
    model.result.numerical('custom_solidmech_multisweep_seg3_laser_displ').set('table','custom_solidmech_multisweep_seg3_laser_displ_table');

    if exist('output_base_filename','var') % if base filename was provided
      model.result.table('custom_solidmech_multisweep_seg3_laser_displ_table').set('storetable','inmodelandonfile');
      model.result.table('custom_solidmech_multisweep_seg3_laser_displ_table').set('filename',sprintf('%s_laser_dispspec_seg3.txt',output_base_filename));
       
    end
       
    model.result.numerical('custom_solidmech_multisweep_seg3_laser_displ').run;
    model.result.numerical('custom_solidmech_multisweep_seg3_laser_displ').setResult;


    
    % Now do the velocity output
    CreateOrReplace(model.result.numerical,'custom_solidmech_multisweep_seg3_laser_vel','EvalPoint');
    model.result.numerical('custom_solidmech_multisweep_seg3_laser_vel').label('custom_solidmech_multisweep_seg3_laser_vel');
    model.result.numerical('custom_solidmech_multisweep_seg3_laser_vel').set('data','custom_solidmech_multisweep_seg3_laser');
    
    model.result.numerical('custom_solidmech_multisweep_seg3_laser_vel').setIndex('expr',model.probe('solidmech_multisweep_laser').feature('solidmech_multisweep_laser_vel').getString('expr'),0);


    CreateOrReplace(model.result.table,'custom_solidmech_multisweep_seg3_laser_vel_table','Table');
    model.result.table('custom_solidmech_multisweep_seg3_laser_vel_table').label('custom_solidmech_multisweep_seg3_laser_vel_table');
    model.result.table('custom_solidmech_multisweep_seg3_laser_vel_table').set('tablebuffersize','1000000');
    model.result.numerical('custom_solidmech_multisweep_seg3_laser_vel').set('table','custom_solidmech_multisweep_seg3_laser_vel_table');


    if exist('output_base_filename','var') % if base filename was provided
      model.result.table('custom_solidmech_multisweep_seg3_laser_vel_table').set('storetable','inmodelandonfile');
      model.result.table('custom_solidmech_multisweep_seg3_laser_vel_table').set('filename',sprintf('%s_laser_velspec_seg3.txt',output_base_filename));       
    end
    
    model.result.numerical('custom_solidmech_multisweep_seg3_laser_vel').run;
    model.result.numerical('custom_solidmech_multisweep_seg3_laser_vel').setResult;


    % Create laser plots
    CreateOrReplace(model.result,'custom_solidmech_multisweep_seg3_laser_dispabs_plot','PlotGroup1D');
    model.result('custom_solidmech_multisweep_seg3_laser_dispabs_plot').label('custom_solidmech_multisweep_seg3_laser_dispabs_plot');
    model.result('custom_solidmech_multisweep_seg3_laser_dispabs_plot').set('data','custom_solidmech_multisweep_seg3_laser');
    model.result('custom_solidmech_multisweep_seg3_laser_dispabs_plot').create('custom_solidmech_multisweep_seg3_laser_disp_abs','PointGraph');
    model.result('custom_solidmech_multisweep_seg3_laser_dispabs_plot').feature('custom_solidmech_multisweep_seg3_laser_disp_abs').label('custom_solidmech_multisweep_seg3_laser_disp_abs');
    model.result('custom_solidmech_multisweep_seg3_laser_dispabs_plot').feature('custom_solidmech_multisweep_seg3_laser_disp_abs').set('expr',sprintf('abs(%s)',to_string(model.probe('solidmech_multisweep_laser').feature('solidmech_multisweep_laser_displ').getString('expr'))));
    model.result('custom_solidmech_multisweep_seg3_laser_dispabs_plot').set('xlog', true);
    model.result('custom_solidmech_multisweep_seg3_laser_dispabs_plot').set('ylog', true);
    model.result('custom_solidmech_multisweep_seg3_laser_dispabs_plot').run;


    CreateOrReplace(model.result,'custom_solidmech_multisweep_seg3_laser_dispangle_plot','PlotGroup1D');
    model.result('custom_solidmech_multisweep_seg3_laser_dispangle_plot').label('custom_solidmech_multisweep_seg3_laser_dispangle_plot');
    model.result('custom_solidmech_multisweep_seg3_laser_dispangle_plot').set('data','custom_solidmech_multisweep_seg3_laser');
    model.result('custom_solidmech_multisweep_seg3_laser_dispangle_plot').create('custom_solidmech_multisweep_seg3_laser_disp_angle','PointGraph');
    model.result('custom_solidmech_multisweep_seg3_laser_dispangle_plot').feature('custom_solidmech_multisweep_seg3_laser_disp_angle').label('custom_solidmech_multisweep_seg3_laser_disp_angle');
    model.result('custom_solidmech_multisweep_seg3_laser_dispangle_plot').feature('custom_solidmech_multisweep_seg3_laser_disp_angle').set('expr',sprintf('imag(log(%s))',to_string(model.probe('solidmech_multisweep_laser').feature('solidmech_multisweep_laser_displ').getString('expr'))));
    model.result('custom_solidmech_multisweep_seg3_laser_dispangle_plot').set('xlog', true);
    model.result('custom_solidmech_multisweep_seg3_laser_dispangle_plot').set('ylog', false);
    model.result('custom_solidmech_multisweep_seg3_laser_dispangle_plot').run;


    CreateOrReplace(model.result,'custom_solidmech_multisweep_seg3_laser_velabs_plot','PlotGroup1D');
    model.result('custom_solidmech_multisweep_seg3_laser_velabs_plot').label('custom_solidmech_multisweep_seg3_laser_velabs_plot');
    model.result('custom_solidmech_multisweep_seg3_laser_velabs_plot').set('data','custom_solidmech_multisweep_seg3_laser');
    model.result('custom_solidmech_multisweep_seg3_laser_velabs_plot').create('custom_solidmech_multisweep_seg3_laser_vel_abs','PointGraph');
    model.result('custom_solidmech_multisweep_seg3_laser_velabs_plot').feature('custom_solidmech_multisweep_seg3_laser_vel_abs').label('custom_solidmech_multisweep_seg3_laser_vel_abs');
    model.result('custom_solidmech_multisweep_seg3_laser_velabs_plot').feature('custom_solidmech_multisweep_seg3_laser_vel_abs').set('expr',sprintf('abs(%s)',to_string(model.probe('solidmech_multisweep_laser').feature('solidmech_multisweep_laser_vel').getString('expr'))));
    model.result('custom_solidmech_multisweep_seg3_laser_velabs_plot').set('xlog', true);
    model.result('custom_solidmech_multisweep_seg3_laser_velabs_plot').set('ylog', true);
    model.result('custom_solidmech_multisweep_seg3_laser_velabs_plot').run;


    CreateOrReplace(model.result,'custom_solidmech_multisweep_seg3_laser_velangle_plot','PlotGroup1D');
    model.result('custom_solidmech_multisweep_seg3_laser_velangle_plot').label('custom_solidmech_multisweep_seg3_laser_velangle_plot');
    model.result('custom_solidmech_multisweep_seg3_laser_velangle_plot').set('data','custom_solidmech_multisweep_seg3_laser');
    model.result('custom_solidmech_multisweep_seg3_laser_velangle_plot').create('custom_solidmech_multisweep_seg3_laser_vel_angle','PointGraph');
    model.result('custom_solidmech_multisweep_seg3_laser_velangle_plot').feature('custom_solidmech_multisweep_seg3_laser_vel_angle').label('custom_solidmech_multisweep_seg3_laser_vel_angle');
    model.result('custom_solidmech_multisweep_seg3_laser_velangle_plot').feature('custom_solidmech_multisweep_seg3_laser_vel_angle').set('expr',sprintf('imag(log(%s))',to_string(model.probe('solidmech_multisweep_laser').feature('solidmech_multisweep_laser_vel').getString('expr'))));
    model.result('custom_solidmech_multisweep_seg3_laser_velangle_plot').set('xlog', true);
    model.result('custom_solidmech_multisweep_seg3_laser_velangle_plot').set('ylog', false);
    model.result('custom_solidmech_multisweep_seg3_laser_velangle_plot').run;
    
  end
  
  if string_in_cellstr_array('vibrodynamic_multisweep_xducercontactprobe',cell(model.probe.tags))
    % Manually create data set, derived value, and table to store
    % the probe output. We need to increase the max # of rows in the table!
     
    %CreateOrReplace(model.result.dataset,'custom_solidmech_multisweep_solution','Solution');
    %model.result.dataset('custom_solidmech_multisweep_solution').set('solution','solidmech_multisweep_solution');
    %model.result.dataset('custom_solidmech_multisweep_solution').set('frametype','geometry');

    CreateOrReplace(model.result.dataset,'custom_vibrodynamic_multisweep_seg3_xducercontactprobe','CutPoint3D');
    model.result.dataset('custom_vibrodynamic_multisweep_seg3_xducercontactprobe').label('custom_vibrodynamic_multisweep_seg3_xducercontactprobe');
    model.result.dataset('custom_vibrodynamic_multisweep_seg3_xducercontactprobe').set('data',GetDataSetForSolution(model,'solidmech_multisweep_seg3_solution')); % 'custom_solidmech_timedomain_solution');
    probepoint = model.probe('vibrodynamic_multisweep_xducercontactprobe').getStringMatrix('coords');
    model.result.dataset('custom_vibrodynamic_multisweep_seg3_xducercontactprobe').set('pointx', probepoint(1,1)); % This extracts the coordinates from the laser probe
    model.result.dataset('custom_vibrodynamic_multisweep_seg3_xducercontactprobe').set('pointy', probepoint(1,2)); % This extracts the coordinates from the laser probe
    model.result.dataset('custom_vibrodynamic_multisweep_seg3_xducercontactprobe').set('pointz', probepoint(1,3)); % This extracts the coordinates from the laser probe
    model.result.dataset('custom_vibrodynamic_multisweep_seg3_xducercontactprobe').set('bndsnap','on');
    model.result.dataset('custom_vibrodynamic_multisweep_seg3_xducercontactprobe').run;

    CreateOrReplace(model.result.numerical,'custom_vibrodynamic_multisweep_seg3_xducercontactprobe_displ','EvalPoint');
    model.result.numerical('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_displ').label('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_displ');
    model.result.numerical('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_displ').set('data','custom_vibrodynamic_multisweep_seg3_xducercontactprobe');
    
    model.result.numerical('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_displ').setIndex('expr',model.probe('vibrodynamic_multisweep_xducercontactprobe').feature('vibrodynamic_multisweep_xducercontactprobe_displ').getString('expr'),0);


    CreateOrReplace(model.result.table,'custom_vibrodynamic_multisweep_seg3_xducercontactprobe_displ_table','Table');
    model.result.table('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_displ_table').label('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_displ_table');
    model.result.table('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_displ_table').set('tablebuffersize','1000000');
    model.result.numerical('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_displ').set('table','custom_vibrodynamic_multisweep_seg3_xducercontactprobe_displ_table');

    if exist('output_base_filename','var') % if base filename was provided
      model.result.table('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_displ_table').set('storetable','inmodelandonfile');
      model.result.table('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_displ_table').set('filename',sprintf('%s_xducercontactprobe_dispspec_seg3.txt',output_base_filename));
       
    end
           
    model.result.numerical('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_displ').run;
    model.result.numerical('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_displ').setResult;

     
    % Now do the velocity output
    CreateOrReplace(model.result.numerical,'custom_vibrodynamic_multisweep_seg3_xducercontactprobe_vel','EvalPoint');
    model.result.numerical('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_vel').label('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_vel');
    model.result.numerical('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_vel').set('data','custom_vibrodynamic_multisweep_seg3_xducercontactprobe');
    
    model.result.numerical('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_vel').setIndex('expr',model.probe('vibrodynamic_multisweep_xducercontactprobe').feature('vibrodynamic_multisweep_xducercontactprobe_vel').getString('expr'),0);


    CreateOrReplace(model.result.table,'custom_vibrodynamic_multisweep_seg3_xducercontactprobe_vel_table','Table');
    model.result.table('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_vel_table').label('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_vel_table');
    model.result.table('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_vel_table').set('tablebuffersize','1000000');
    model.result.numerical('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_vel').set('table','custom_vibrodynamic_multisweep_seg3_xducercontactprobe_vel_table');
    
    if exist('output_base_filename','var') % if base filename was provided
      model.result.table('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_vel_table').set('storetable','inmodelandonfile');
      model.result.table('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_vel_table').set('filename',sprintf('%s_xducercontactprobe_velspec_seg3.txt',output_base_filename));
       
    end

    model.result.numerical('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_vel').run;
    model.result.numerical('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_vel').setResult;



    % Create xducercontact plots


    CreateOrReplace(model.result,'custom_vibrodynamic_multisweep_seg3_xducercontactprobe_dispabs_plot','PlotGroup1D');
    model.result('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_dispabs_plot').label('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_dispabs_plot');
    model.result('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_dispabs_plot').set('data','custom_vibrodynamic_multisweep_seg3_xducercontactprobe');
    model.result('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_dispabs_plot').create('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_disp_abs','PointGraph');
    model.result('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_dispabs_plot').feature('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_disp_abs').label('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_disp_abs');
    model.result('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_dispabs_plot').feature('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_disp_abs').set('expr',sprintf('abs(%s)',to_string(model.probe('vibrodynamic_multisweep_xducercontactprobe').feature('vibrodynamic_multisweep_xducercontactprobe_displ').getString('expr'))));
    model.result('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_dispabs_plot').set('xlog', true);
    model.result('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_dispabs_plot').set('ylog', true);
    model.result('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_dispabs_plot').run;


    CreateOrReplace(model.result,'custom_vibrodynamic_multisweep_seg3_xducercontactprobe_dispangle_plot','PlotGroup1D');
    model.result('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_dispangle_plot').label('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_dispangle_plot');
    model.result('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_dispangle_plot').set('data','custom_vibrodynamic_multisweep_seg3_xducercontactprobe');
    model.result('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_dispangle_plot').create('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_disp_angle','PointGraph');
    model.result('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_dispangle_plot').feature('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_disp_angle').label('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_disp_angle');
    model.result('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_dispangle_plot').feature('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_disp_angle').set('expr',sprintf('imag(log(%s))',to_string(model.probe('vibrodynamic_multisweep_xducercontactprobe').feature('vibrodynamic_multisweep_xducercontactprobe_displ').getString('expr'))));
    model.result('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_dispangle_plot').set('xlog', true);
    model.result('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_dispangle_plot').set('ylog', false);
    model.result('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_dispangle_plot').run;


    CreateOrReplace(model.result,'custom_vibrodynamic_multisweep_seg3_xducercontactprobe_velabs_plot','PlotGroup1D');
    model.result('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_velabs_plot').label('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_velabs_plot');
    model.result('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_velabs_plot').set('data','custom_vibrodynamic_multisweep_seg3_xducercontactprobe');
    model.result('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_velabs_plot').create('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_vel_abs','PointGraph');
    model.result('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_velabs_plot').feature('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_vel_abs').label('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_vel_abs');
    model.result('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_velabs_plot').feature('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_vel_abs').set('expr',sprintf('abs(%s)',to_string(model.probe('vibrodynamic_multisweep_xducercontactprobe').feature('vibrodynamic_multisweep_xducercontactprobe_vel').getString('expr'))));
    model.result('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_velabs_plot').set('xlog', true);
    model.result('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_velabs_plot').set('ylog', true);
    model.result('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_velabs_plot').run;


    CreateOrReplace(model.result,'custom_vibrodynamic_multisweep_seg3_xducercontactprobe_velangle_plot','PlotGroup1D');
    model.result('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_velangle_plot').label('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_velangle_plot');
    model.result('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_velangle_plot').set('data','custom_vibrodynamic_multisweep_seg3_xducercontactprobe');
    model.result('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_velangle_plot').create('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_vel_angle','PointGraph');
    model.result('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_velangle_plot').feature('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_vel_angle').label('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_vel_angle');
    model.result('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_velangle_plot').feature('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_vel_angle').set('expr',sprintf('imag(log(%s))',to_string(model.probe('vibrodynamic_multisweep_xducercontactprobe').feature('vibrodynamic_multisweep_xducercontactprobe_vel').getString('expr'))));
    model.result('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_velangle_plot').set('xlog', true);
    model.result('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_velangle_plot').set('ylog', false);
    model.result('custom_vibrodynamic_multisweep_seg3_xducercontactprobe_velangle_plot').run;



  end





end



if DataSetExistsForSolution(model,'solidmech_multisweep_seg4_solution')

  if string_in_cellstr_array('crack_centerstrain',to_cellstr_array(model.variable.tags))

    CreateOrReplace(model.result.numerical,'solidmech_multisweep_seg4_crackcenterstrain','EvalGlobal');
    model.result.numerical('solidmech_multisweep_seg4_crackcenterstrain').label('solidmech_multisweep_seg4_crackcenterstrain');
    model.result.numerical('solidmech_multisweep_seg4_crackcenterstrain').set('data',GetDataSetForSolution(model,'solidmech_multisweep_seg4_solution'));
    
    model.result.numerical('solidmech_multisweep_seg4_crackcenterstrain').setIndex('expr','crack_centerstrainmag_solidmech_multisweep',0);
    model.result.numerical('solidmech_multisweep_seg4_crackcenterstrain').setIndex('descr','Magnitude_of_strain_at_crack_center_seg4',0);
    model.result.numerical('solidmech_multisweep_seg4_crackcenterstrain').setIndex('expr','crack_centerstrainnormal_solidmech_multisweep',1);
    model.result.numerical('solidmech_multisweep_seg4_crackcenterstrain').setIndex('descr','Normal_strain_at_crack_center_seg4',1);
    model.result.numerical('solidmech_multisweep_seg4_crackcenterstrain').setIndex('expr','crack_centerstrainshear_solidmech_multisweep',2);
    model.result.numerical('solidmech_multisweep_seg4_crackcenterstrain').setIndex('descr','Shear_strain_at_crack_center_seg4',2);

    CreateOrReplace(model.result.table,'solidmech_multisweep_seg4_crackcenterstrain_table','Table');
    model.result.table('solidmech_multisweep_seg4_crackcenterstrain_table').label('solidmech_multisweep_seg4_crackcenterstrain_table');
    model.result.table('solidmech_multisweep_seg4_crackcenterstrain_table').set('tablebuffersize','1000000');
    model.result.numerical('solidmech_multisweep_seg4_crackcenterstrain').set('table','solidmech_multisweep_seg4_crackcenterstrain_table');
    
    if exist('output_base_filename','var') % if base filename was provided
      model.result.table('solidmech_multisweep_seg4_crackcenterstrain_table').set('storetable','inmodelandonfile');
      model.result.table('solidmech_multisweep_seg4_crackcenterstrain_table').set('filename',sprintf('%s_crackcenterstrainspec_seg4.txt',output_base_filename));
       
    end
       
    model.result.numerical('solidmech_multisweep_seg4_crackcenterstrain').run;
    model.result.numerical('solidmech_multisweep_seg4_crackcenterstrain').setResult;


  end

  if string_in_cellstr_array('solidmech_multisweep_laser',cell(model.probe.tags))
    % Manually create data set, derived value, and table to store
    % the probe output. We need to increase the max # of rows in the table!
     
    %CreateOrReplace(model.result.dataset,'custom_solidmech_multisweep_solution','Solution');
    %model.result.dataset('custom_solidmech_multisweep_solution').set('solution','solidmech_multisweep_solution');
    %model.result.dataset('custom_solidmech_multisweep_solution').set('frametype','geometry');

    CreateOrReplace(model.result.dataset,'custom_solidmech_multisweep_seg4_laser','CutPoint3D');
    model.result.dataset('custom_solidmech_multisweep_seg4_laser').label('custom_solidmech_multisweep_seg4_laser');
    model.result.dataset('custom_solidmech_multisweep_seg4_laser').set('data',GetDataSetForSolution(model,'solidmech_multisweep_seg4_solution'));
    probepoint = model.probe('solidmech_multisweep_laser').getStringMatrix('coords');
    model.result.dataset('custom_solidmech_multisweep_seg4_laser').set('pointx', probepoint(1,1)); % This extracts the coordinates from the laser probe
    model.result.dataset('custom_solidmech_multisweep_seg4_laser').set('pointy', probepoint(1,2)); % This extracts the coordinates from the laser probe
    model.result.dataset('custom_solidmech_multisweep_seg4_laser').set('pointz', probepoint(1,3)); % This extracts the coordinates from the laser probe
    model.result.dataset('custom_solidmech_multisweep_seg4_laser').set('bndsnap','on');
    model.result.dataset('custom_solidmech_multisweep_seg4_laser').run;

    % laser displacement
    CreateOrReplace(model.result.numerical,'custom_solidmech_multisweep_seg4_laser_displ','EvalPoint');
    model.result.numerical('custom_solidmech_multisweep_seg4_laser_displ').label('custom_solidmech_multisweep_seg4_laser_displ');
    model.result.numerical('custom_solidmech_multisweep_seg4_laser_displ').set('data','custom_solidmech_multisweep_seg4_laser');
    
    model.result.numerical('custom_solidmech_multisweep_seg4_laser_displ').setIndex('expr',model.probe('solidmech_multisweep_laser').feature('solidmech_multisweep_laser_displ').getString('expr'),0);


    CreateOrReplace(model.result.table,'custom_solidmech_multisweep_seg4_laser_displ_table','Table');
    model.result.table('custom_solidmech_multisweep_seg4_laser_displ_table').label('custom_solidmech_multisweep_seg4_laser_displ_table');
    model.result.table('custom_solidmech_multisweep_seg4_laser_displ_table').set('tablebuffersize','1000000');
    model.result.numerical('custom_solidmech_multisweep_seg4_laser_displ').set('table','custom_solidmech_multisweep_seg4_laser_displ_table');

    if exist('output_base_filename','var') % if base filename was provided
      model.result.table('custom_solidmech_multisweep_seg4_laser_displ_table').set('storetable','inmodelandonfile');
      model.result.table('custom_solidmech_multisweep_seg4_laser_displ_table').set('filename',sprintf('%s_laser_dispspec_seg4.txt',output_base_filename));
       
    end
       
    model.result.numerical('custom_solidmech_multisweep_seg4_laser_displ').run;
    model.result.numerical('custom_solidmech_multisweep_seg4_laser_displ').setResult;


    
    % Now do the velocity output
    CreateOrReplace(model.result.numerical,'custom_solidmech_multisweep_seg4_laser_vel','EvalPoint');
    model.result.numerical('custom_solidmech_multisweep_seg4_laser_vel').label('custom_solidmech_multisweep_seg4_laser_vel');
    model.result.numerical('custom_solidmech_multisweep_seg4_laser_vel').set('data','custom_solidmech_multisweep_seg4_laser');
    
    model.result.numerical('custom_solidmech_multisweep_seg4_laser_vel').setIndex('expr',model.probe('solidmech_multisweep_laser').feature('solidmech_multisweep_laser_vel').getString('expr'),0);


    CreateOrReplace(model.result.table,'custom_solidmech_multisweep_seg4_laser_vel_table','Table');
    model.result.table('custom_solidmech_multisweep_seg4_laser_vel_table').label('custom_solidmech_multisweep_seg4_laser_vel_table');
    model.result.table('custom_solidmech_multisweep_seg4_laser_vel_table').set('tablebuffersize','1000000');
    model.result.numerical('custom_solidmech_multisweep_seg4_laser_vel').set('table','custom_solidmech_multisweep_seg4_laser_vel_table');


    if exist('output_base_filename','var') % if base filename was provided
      model.result.table('custom_solidmech_multisweep_seg4_laser_vel_table').set('storetable','inmodelandonfile');
      model.result.table('custom_solidmech_multisweep_seg4_laser_vel_table').set('filename',sprintf('%s_laser_velspec_seg4.txt',output_base_filename));       
    end
    
    model.result.numerical('custom_solidmech_multisweep_seg4_laser_vel').run;
    model.result.numerical('custom_solidmech_multisweep_seg4_laser_vel').setResult;


    % Create laser plots
    CreateOrReplace(model.result,'custom_solidmech_multisweep_seg4_laser_dispabs_plot','PlotGroup1D');
    model.result('custom_solidmech_multisweep_seg4_laser_dispabs_plot').label('custom_solidmech_multisweep_seg4_laser_dispabs_plot');
    model.result('custom_solidmech_multisweep_seg4_laser_dispabs_plot').set('data','custom_solidmech_multisweep_seg4_laser');
    model.result('custom_solidmech_multisweep_seg4_laser_dispabs_plot').create('custom_solidmech_multisweep_seg4_laser_disp_abs','PointGraph');
    model.result('custom_solidmech_multisweep_seg4_laser_dispabs_plot').feature('custom_solidmech_multisweep_seg4_laser_disp_abs').label('custom_solidmech_multisweep_seg4_laser_disp_abs');
    model.result('custom_solidmech_multisweep_seg4_laser_dispabs_plot').feature('custom_solidmech_multisweep_seg4_laser_disp_abs').set('expr',sprintf('abs(%s)',to_string(model.probe('solidmech_multisweep_laser').feature('solidmech_multisweep_laser_displ').getString('expr'))));
    model.result('custom_solidmech_multisweep_seg4_laser_dispabs_plot').set('xlog', true);
    model.result('custom_solidmech_multisweep_seg4_laser_dispabs_plot').set('ylog', true);
    model.result('custom_solidmech_multisweep_seg4_laser_dispabs_plot').run;


    CreateOrReplace(model.result,'custom_solidmech_multisweep_seg4_laser_dispangle_plot','PlotGroup1D');
    model.result('custom_solidmech_multisweep_seg4_laser_dispangle_plot').label('custom_solidmech_multisweep_seg4_laser_dispangle_plot');
    model.result('custom_solidmech_multisweep_seg4_laser_dispangle_plot').set('data','custom_solidmech_multisweep_seg4_laser');
    model.result('custom_solidmech_multisweep_seg4_laser_dispangle_plot').create('custom_solidmech_multisweep_seg4_laser_disp_angle','PointGraph');
    model.result('custom_solidmech_multisweep_seg4_laser_dispangle_plot').feature('custom_solidmech_multisweep_seg4_laser_disp_angle').label('custom_solidmech_multisweep_seg4_laser_disp_angle');
    model.result('custom_solidmech_multisweep_seg4_laser_dispangle_plot').feature('custom_solidmech_multisweep_seg4_laser_disp_angle').set('expr',sprintf('imag(log(%s))',to_string(model.probe('solidmech_multisweep_laser').feature('solidmech_multisweep_laser_displ').getString('expr'))));
    model.result('custom_solidmech_multisweep_seg4_laser_dispangle_plot').set('xlog', true);
    model.result('custom_solidmech_multisweep_seg4_laser_dispangle_plot').set('ylog', false);
    model.result('custom_solidmech_multisweep_seg4_laser_dispangle_plot').run;


    CreateOrReplace(model.result,'custom_solidmech_multisweep_seg4_laser_velabs_plot','PlotGroup1D');
    model.result('custom_solidmech_multisweep_seg4_laser_velabs_plot').label('custom_solidmech_multisweep_seg4_laser_velabs_plot');
    model.result('custom_solidmech_multisweep_seg4_laser_velabs_plot').set('data','custom_solidmech_multisweep_seg4_laser');
    model.result('custom_solidmech_multisweep_seg4_laser_velabs_plot').create('custom_solidmech_multisweep_seg4_laser_vel_abs','PointGraph');
    model.result('custom_solidmech_multisweep_seg4_laser_velabs_plot').feature('custom_solidmech_multisweep_seg4_laser_vel_abs').label('custom_solidmech_multisweep_seg4_laser_vel_abs');
    model.result('custom_solidmech_multisweep_seg4_laser_velabs_plot').feature('custom_solidmech_multisweep_seg4_laser_vel_abs').set('expr',sprintf('abs(%s)',to_string(model.probe('solidmech_multisweep_laser').feature('solidmech_multisweep_laser_vel').getString('expr'))));
    model.result('custom_solidmech_multisweep_seg4_laser_velabs_plot').set('xlog', true);
    model.result('custom_solidmech_multisweep_seg4_laser_velabs_plot').set('ylog', true);
    model.result('custom_solidmech_multisweep_seg4_laser_velabs_plot').run;


    CreateOrReplace(model.result,'custom_solidmech_multisweep_seg4_laser_velangle_plot','PlotGroup1D');
    model.result('custom_solidmech_multisweep_seg4_laser_velangle_plot').label('custom_solidmech_multisweep_seg4_laser_velangle_plot');
    model.result('custom_solidmech_multisweep_seg4_laser_velangle_plot').set('data','custom_solidmech_multisweep_seg4_laser');
    model.result('custom_solidmech_multisweep_seg4_laser_velangle_plot').create('custom_solidmech_multisweep_seg4_laser_vel_angle','PointGraph');
    model.result('custom_solidmech_multisweep_seg4_laser_velangle_plot').feature('custom_solidmech_multisweep_seg4_laser_vel_angle').label('custom_solidmech_multisweep_seg4_laser_vel_angle');
    model.result('custom_solidmech_multisweep_seg4_laser_velangle_plot').feature('custom_solidmech_multisweep_seg4_laser_vel_angle').set('expr',sprintf('imag(log(%s))',to_string(model.probe('solidmech_multisweep_laser').feature('solidmech_multisweep_laser_vel').getString('expr'))));
    model.result('custom_solidmech_multisweep_seg4_laser_velangle_plot').set('xlog', true);
    model.result('custom_solidmech_multisweep_seg4_laser_velangle_plot').set('ylog', false);
    model.result('custom_solidmech_multisweep_seg4_laser_velangle_plot').run;
    
  end
  
  if string_in_cellstr_array('vibrodynamic_multisweep_xducercontactprobe',cell(model.probe.tags))
    % Manually create data set, derived value, and table to store
    % the probe output. We need to increase the max # of rows in the table!
     
    %CreateOrReplace(model.result.dataset,'custom_solidmech_multisweep_solution','Solution');
    %model.result.dataset('custom_solidmech_multisweep_solution').set('solution','solidmech_multisweep_solution');
    %model.result.dataset('custom_solidmech_multisweep_solution').set('frametype','geometry');

    CreateOrReplace(model.result.dataset,'custom_vibrodynamic_multisweep_seg4_xducercontactprobe','CutPoint3D');
    model.result.dataset('custom_vibrodynamic_multisweep_seg4_xducercontactprobe').label('custom_vibrodynamic_multisweep_seg4_xducercontactprobe');
    model.result.dataset('custom_vibrodynamic_multisweep_seg4_xducercontactprobe').set('data',GetDataSetForSolution(model,'solidmech_multisweep_seg4_solution')); % 'custom_solidmech_timedomain_solution');
    probepoint = model.probe('vibrodynamic_multisweep_xducercontactprobe').getStringMatrix('coords');
    model.result.dataset('custom_vibrodynamic_multisweep_seg4_xducercontactprobe').set('pointx', probepoint(1,1)); % This extracts the coordinates from the laser probe
    model.result.dataset('custom_vibrodynamic_multisweep_seg4_xducercontactprobe').set('pointy', probepoint(1,2)); % This extracts the coordinates from the laser probe
    model.result.dataset('custom_vibrodynamic_multisweep_seg4_xducercontactprobe').set('pointz', probepoint(1,3)); % This extracts the coordinates from the laser probe
    model.result.dataset('custom_vibrodynamic_multisweep_seg4_xducercontactprobe').set('bndsnap','on');
    model.result.dataset('custom_vibrodynamic_multisweep_seg4_xducercontactprobe').run;

    CreateOrReplace(model.result.numerical,'custom_vibrodynamic_multisweep_seg4_xducercontactprobe_displ','EvalPoint');
    model.result.numerical('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_displ').label('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_displ');
    model.result.numerical('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_displ').set('data','custom_vibrodynamic_multisweep_seg4_xducercontactprobe');
    
    model.result.numerical('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_displ').setIndex('expr',model.probe('vibrodynamic_multisweep_xducercontactprobe').feature('vibrodynamic_multisweep_xducercontactprobe_displ').getString('expr'),0);


    CreateOrReplace(model.result.table,'custom_vibrodynamic_multisweep_seg4_xducercontactprobe_displ_table','Table');
    model.result.table('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_displ_table').label('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_displ_table');
    model.result.table('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_displ_table').set('tablebuffersize','1000000');
    model.result.numerical('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_displ').set('table','custom_vibrodynamic_multisweep_seg4_xducercontactprobe_displ_table');

    if exist('output_base_filename','var') % if base filename was provided
      model.result.table('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_displ_table').set('storetable','inmodelandonfile');
      model.result.table('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_displ_table').set('filename',sprintf('%s_xducercontactprobe_dispspec_seg4.txt',output_base_filename));
       
    end
           
    model.result.numerical('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_displ').run;
    model.result.numerical('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_displ').setResult;

     
    % Now do the velocity output
    CreateOrReplace(model.result.numerical,'custom_vibrodynamic_multisweep_seg4_xducercontactprobe_vel','EvalPoint');
    model.result.numerical('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_vel').label('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_vel');
    model.result.numerical('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_vel').set('data','custom_vibrodynamic_multisweep_seg4_xducercontactprobe');
    
    model.result.numerical('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_vel').setIndex('expr',model.probe('vibrodynamic_multisweep_xducercontactprobe').feature('vibrodynamic_multisweep_xducercontactprobe_vel').getString('expr'),0);


    CreateOrReplace(model.result.table,'custom_vibrodynamic_multisweep_seg4_xducercontactprobe_vel_table','Table');
    model.result.table('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_vel_table').label('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_vel_table');
    model.result.table('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_vel_table').set('tablebuffersize','1000000');
    model.result.numerical('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_vel').set('table','custom_vibrodynamic_multisweep_seg4_xducercontactprobe_vel_table');
    
    if exist('output_base_filename','var') % if base filename was provided
      model.result.table('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_vel_table').set('storetable','inmodelandonfile');
      model.result.table('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_vel_table').set('filename',sprintf('%s_xducercontactprobe_velspec_seg4.txt',output_base_filename));
       
    end

    model.result.numerical('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_vel').run;
    model.result.numerical('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_vel').setResult;



    % Create xducercontact plots


    CreateOrReplace(model.result,'custom_vibrodynamic_multisweep_seg4_xducercontactprobe_dispabs_plot','PlotGroup1D');
    model.result('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_dispabs_plot').label('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_dispabs_plot');
    model.result('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_dispabs_plot').set('data','custom_vibrodynamic_multisweep_seg4_xducercontactprobe');
    model.result('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_dispabs_plot').create('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_disp_abs','PointGraph');
    model.result('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_dispabs_plot').feature('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_disp_abs').label('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_disp_abs');
    model.result('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_dispabs_plot').feature('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_disp_abs').set('expr',sprintf('abs(%s)',to_string(model.probe('vibrodynamic_multisweep_xducercontactprobe').feature('vibrodynamic_multisweep_xducercontactprobe_displ').getString('expr'))));
    model.result('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_dispabs_plot').set('xlog', true);
    model.result('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_dispabs_plot').set('ylog', true);
    model.result('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_dispabs_plot').run;


    CreateOrReplace(model.result,'custom_vibrodynamic_multisweep_seg4_xducercontactprobe_dispangle_plot','PlotGroup1D');
    model.result('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_dispangle_plot').label('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_dispangle_plot');
    model.result('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_dispangle_plot').set('data','custom_vibrodynamic_multisweep_seg4_xducercontactprobe');
    model.result('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_dispangle_plot').create('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_disp_angle','PointGraph');
    model.result('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_dispangle_plot').feature('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_disp_angle').label('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_disp_angle');
    model.result('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_dispangle_plot').feature('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_disp_angle').set('expr',sprintf('imag(log(%s))',to_string(model.probe('vibrodynamic_multisweep_xducercontactprobe').feature('vibrodynamic_multisweep_xducercontactprobe_displ').getString('expr'))));
    model.result('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_dispangle_plot').set('xlog', true);
    model.result('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_dispangle_plot').set('ylog', false);
    model.result('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_dispangle_plot').run;


    CreateOrReplace(model.result,'custom_vibrodynamic_multisweep_seg4_xducercontactprobe_velabs_plot','PlotGroup1D');
    model.result('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_velabs_plot').label('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_velabs_plot');
    model.result('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_velabs_plot').set('data','custom_vibrodynamic_multisweep_seg4_xducercontactprobe');
    model.result('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_velabs_plot').create('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_vel_abs','PointGraph');
    model.result('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_velabs_plot').feature('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_vel_abs').label('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_vel_abs');
    model.result('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_velabs_plot').feature('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_vel_abs').set('expr',sprintf('abs(%s)',to_string(model.probe('vibrodynamic_multisweep_xducercontactprobe').feature('vibrodynamic_multisweep_xducercontactprobe_vel').getString('expr'))));
    model.result('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_velabs_plot').set('xlog', true);
    model.result('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_velabs_plot').set('ylog', true);
    model.result('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_velabs_plot').run;


    CreateOrReplace(model.result,'custom_vibrodynamic_multisweep_seg4_xducercontactprobe_velangle_plot','PlotGroup1D');
    model.result('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_velangle_plot').label('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_velangle_plot');
    model.result('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_velangle_plot').set('data','custom_vibrodynamic_multisweep_seg4_xducercontactprobe');
    model.result('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_velangle_plot').create('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_vel_angle','PointGraph');
    model.result('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_velangle_plot').feature('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_vel_angle').label('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_vel_angle');
    model.result('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_velangle_plot').feature('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_vel_angle').set('expr',sprintf('imag(log(%s))',to_string(model.probe('vibrodynamic_multisweep_xducercontactprobe').feature('vibrodynamic_multisweep_xducercontactprobe_vel').getString('expr'))));
    model.result('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_velangle_plot').set('xlog', true);
    model.result('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_velangle_plot').set('ylog', false);
    model.result('custom_vibrodynamic_multisweep_seg4_xducercontactprobe_velangle_plot').run;



  end





end



end
