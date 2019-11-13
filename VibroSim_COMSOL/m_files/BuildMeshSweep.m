%> @breif Mesh a block or similar object using a sweep operation
%> Parameters:
%>  @param M: the class ModelWrapper containing our representation of the model
%>  @param geom: the ModelWrapper containing our representation of the geometry
%>  @param mesh: the ModelWrapper containing our representation of the top level mesh object
%>  @param object: The ModelWrapper containing our block
%>  @param meshobj: The object in which to store the mesh we are creating
%>  @param facemethod: 'FreeTri', 'FreeQuad', or 'Map
%>  @param meshsize:   Meshing size, in the sweep source/target face planes
%>  @param sweepelements': Number of elements in the sweep direction
%>  @param domainselectionfunc: function returning domain entities to be meshed
%>  @param namededgesselectiontag: name of selection corresponding to edges of domain to be meshed
%>  @param sourcefaceselectionfunc: function returning boundary entities corresponding to source face
%>  @param targetfaceselectionfunc: function returning boundary entities corresponding to target face
%>  @param use_distributions (true/false, optional default false): Should we
%>                           Create the edge distributions to bound the element size
%>                           along edges?
%>  (note: object and namededgeselectiontag are not currently used)
%>
%> This uses distributions, with element spacing determined by meshsize,
%> on all edges adjacent to sourceface to feed the selected facemethod,
%> operated on sourceface. A size node is also created to limit the size
%> away from edges. Then that sourceface is swept to targetface.
%> In addition a size object is created as well to bound the maximum size
function meshobj=BuildMeshSweep(M,geom,mesh,object,meshobj,facemethod,meshsize,sweepelements,domainselectionfunc,namededgesselectiontag,sourcefaceselectionfunc,targetfaceselectionfunc,use_distributions)

  % Validate Input

  if ~exist('use_distributions','var')
    use_distributions=false;
  end

  if not(any(ismember({'FreeQuad', 'FreeTri','Map'}, facemethod)))
    error('BuildMeshSweep:COMSOLFaceMethodException', strcat('Face Method "', facemethod, '" is Not Valid'));
  end


  meshobj.parent=mesh.node.feature;  % Store how to destroy the COMSOL node wrapped by our object
  % Note: meshedblk.node not created yet because it must be AFTER the
  % distributions and the size node in the node tree!

  %domain=mphgetselection(M.node.selection(nameddomainselectiontag));
  domain=domainselectionfunc(M,geom,object);


  %sourcefaceselection=mphgetselection(M.node.selection(sourcefacetag));
  sourcefaceselection=sourcefaceselectionfunc(M,geom,object);

  %targetfaceselection=mphgetselection(M.node.selection(targetfacetag));
  targetfaceselection=targetfaceselectionfunc(M,geom,object);
    
  % Create distributions  

  if use_distributions
    % If we didn't want the distributions to be created on internal edges of the face, we
    % could extract namededgesselectiontag and operate only on the intersection. 
    addprop(meshobj,'sourcefacedists');
    addprop(meshobj,'targetfacedists');

    meshobj.sourcefacedists=CreateDistributionsOnEdges(M,geom,[tag '_sourcefacedist'],mesh,sourcefaceselection,@(M,geom,meshobj,edgeid,edgelength) (ceil(edgelength/meshsize)));
    meshobj.targetfacedists=CreateDistributionsOnEdges(M,geom,[tag '_targetfacedist'],mesh,targetfaceselection,@(M,geom,meshobj,edgeid,edgelength) (ceil(edgelength/meshsize)));
  end



  % Create the facemethod on sourceface
  BuildWrappedModel(M,meshobj,mesh.node.feature,facemethod);
  meshobj.node.label(meshobj.tag);
  meshobj.node.selection.set(sourcefaceselection);
  

  % Create the Size object
  % CreateWrappedProperty(M,meshobj,'size',[meshobj.tag '_size'],mesh.node.feature,'Size');
  % meshobj.size.node.label(meshobj.size.tag);

  % meshobj.size.node.set('custom','on');  % custom size, not preset size
  % meshobj.size.node.set('hmaxactive','on'); % limit maximum element size
  % meshobj.size.node.set('hmax',meshsize); % set size limit
  % meshobj.size.node.selection.geom(geom.tag,3); % set to 3-dimensional (domain)
  % meshobj.size.node.selection.set(domain); % apply to our domain
  CreateMeshSizeProperty(M,geom,mesh,meshobj,'size',[meshobj.tag '_size'],[],meshsize,3,domain);


  CreateWrappedProperty(M,meshobj,'sweep',[meshobj.tag '_sweep'],mesh.node.feature,'Sweep');
  meshobj.sweep.node.label(meshobj.sweep.tag);

  meshobj.sweep.node.selection.set(domain);
  meshobj.sweep.node.selection('sourceface').set(sourcefaceselection);
  meshobj.sweep.node.selection('targetface').set(targetfaceselection);      
    
  % Set the number of elements for the sweep
  CreateWrappedProperty(M,meshobj,'sweepdist',[meshobj.tag '_sweepdist'],meshobj.sweep.node.feature,'Distribution');

  meshobj.sweepdist.node.set('numelem',sweepelements);

