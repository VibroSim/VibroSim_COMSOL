%> CREATEMODEL Creates a New Model on Comsol Server with Given Model Tag
%> Will overwrite existing model if the name is the same
%>   [model] = CREATEMODEL() Creates a New Model with Default Tag
%>   [model] = CREATEMODEL(modeltag,componenttag) Creates a New Model with Given Tag
function [M,model,component] = CreateModel(modeltag,componenttag)

    if ~exist('modeltag','var')
      modeltag='Model';
    end

    if ~exist('componenttag','var')
      componenttag='Component';
    end

    % Import Comsol Java Libraries  -- required to call ModelUtil functions
    import com.comsol.model.*
    import com.comsol.model.util.*
    
    % Create Model
    M=ModelWrapper([],modeltag);
    M.node = ModelUtil.create(modeltag);
 
  
    % Create component
    component=ModelWrapper(M,componenttag);
    component.node=M.node.modelNode.create(componenttag);

    addprop(M,'component');
    M.component=component;

    % Always show progress bar
    ModelUtil.showProgress(true);

    model=M.node;

end
