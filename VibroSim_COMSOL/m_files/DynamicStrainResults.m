function M_or_Model = DynamicStrainResults(M_or_Model,physicstag,modeshapefilename)
% Create results nodes for dynamic strain calculation
%
% Parameters:
% M_or_Model:          ModelWrapper 'M' or COMSOL model node 'model'
% physicstag:          Tag for the physics solved for. Usually
%                      solidmech_harmonic or solidmech_harmonicper.
%                      assumes the solution to run is [ physicstag '_solution' ].
% modeshapefilename:   file to write the mode shape image

if isa(M_or_Model,'ModelWrapper')
   model = M_or_Model.node;
else
   model = M_or_Model;
end


% Diagnostic plot
CreateOrReplace(model.result,'vibro_dynamicstrain_plot','PlotGroup3D');
model.result('vibro_dynamicstrain_plot').label('vibro_dynamicstrain_plot');
model.result('vibro_dynamicstrain_plot').set('data', GetDataSetForSolution(model,[ physicstag '_solution' ]));
model.result('vibro_dynamicstrain_plot').create('vibro_dynamicstrain_plot_surface', 'Surface');
model.result('vibro_dynamicstrain_plot').feature('vibro_dynamicstrain_plot_surface').label('vibro_dynamicstrain_plot_surface');
model.result('vibro_dynamicstrain_plot').feature('vibro_dynamicstrain_plot_surface').create('vibro_dynamicstrain_plot_surface_deform', 'Deform');
%model.result('vibro_dynamicstrain_plot').setIndex('looplevel', to_string(closestfreqidx), 0);
model.result('vibro_dynamicstrain_plot').feature('vibro_dynamicstrain_plot_surface').feature('vibro_dynamicstrain_plot_surface_deform').label('vibro_dynamicstrain_plot_surface_displacement');
model.result('vibro_dynamicstrain_plot').feature('vibro_dynamicstrain_plot_surface').set('expr', [ physicstag '.sx' ]);
model.result('vibro_dynamicstrain_plot').feature('vibro_dynamicstrain_plot_surface').set('descr', 'Stress tensor, X-component');
model.result('vibro_dynamicstrain_plot').run

% Save diagnostic plot to image file

CreateOrReplace(model.result.export,'vibro_dynamicstrain_plot_image','vibro_dynamicstrain_plot','Image3D');
model.result.export('vibro_dynamicstrain_plot_image').set('unit', 'px');
model.result.export('vibro_dynamicstrain_plot_image').set('height', '600');
model.result.export('vibro_dynamicstrain_plot_image').set('width', '800');
model.result.export('vibro_dynamicstrain_plot_image').set('lockratio', 'off');
model.result.export('vibro_dynamicstrain_plot_image').set('resolution', '96');
%model.result.export('vibro_dynamicstrain_plot_image').set('size', 'manual');
model.result.export('vibro_dynamicstrain_plot_image').set('antialias', 'on');
model.result.export('vibro_dynamicstrain_plot_image').set('title', 'on');
model.result.export('vibro_dynamicstrain_plot_image').set('legend', 'on');
model.result.export('vibro_dynamicstrain_plot_image').set('logo', 'on');
model.result.export('vibro_dynamicstrain_plot_image').set('options', 'off');
model.result.export('vibro_dynamicstrain_plot_image').set('customcolor', [1 1 1]);
model.result.export('vibro_dynamicstrain_plot_image').set('background', 'color');
model.result.export('vibro_dynamicstrain_plot_image').set('qualitylevel', '92');
model.result.export('vibro_dynamicstrain_plot_image').set('qualityactive', 'off');
model.result.export('vibro_dynamicstrain_plot_image').set('imagetype', 'png');
model.result.export('vibro_dynamicstrain_plot_image').set('axes', 'on');
model.result.export('vibro_dynamicstrain_plot_image').set('pngfilename', modeshapefilename);
model.result.export('vibro_dynamicstrain_plot_image').set('fontsize', '14');
model.result.export('vibro_dynamicstrain_plot_image').set('options', 'on');
model.result.export('vibro_dynamicstrain_plot_image').set('logo', 'off');
model.result.export('vibro_dynamicstrain_plot_image').run;
