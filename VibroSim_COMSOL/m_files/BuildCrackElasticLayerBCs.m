function bcobj=BuildCrackElasticLayerBCs(M,geom,physics,crack,bcobj)


 sorted_boundaries=GetCrackBoundaries(M,geom,crack);


% if ~isprop(crack,'elasticlayers')
%   addprop(crack,'elasticlayers');
%   crack.elasticlayers=struct;
% end

% crack.elasticlayers.(physics.tag)={};

bcobj.children={};
for cnt=1:length(sorted_boundaries)
  % Create boundary condition
  bcobj.children{cnt}=ModelWrapper(M,sprintf('%s_ellayer%.3d',bcobj.tag,cnt),physics.node.feature);
  bcobj.children{cnt}.node=physics.node.feature.create(bcobj.children{cnt}.tag,'ThinElasticLayer',2);
  bcobj.children{cnt}.node.label(sprintf('%s_elasticlayer%.3d',bcobj.tag,cnt));
  bcobj.children{cnt}.node.selection.set([ sorted_boundaries(cnt) ] );

  % store selection in case it is needed later...								      
  addprop(bcobj.children{cnt},'boundaryentities');
  bcobj.children{cnt}.boundaryentities=[sorted_boundaries(cnt)];
end						

% ***!!!Should set spring constant per unit area here***!!!

