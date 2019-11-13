%> ModelWrapper is  MATLAB object that (usually) wraps COMSOL objects.
%> The COMSOL object is placed in the 'node' property.

%> You can dynamically add properties to instances with
%> addprop(H,'PropertyName')
%> see http://www.mathworks.com/help/matlab/matlab_oop/dynamic-properties--adding-properties-to-an-instance.html#brffvja
%>
%> Because this class is derived from dynamicprops, which is in
%> turn derived from handle, you can pass it around and it will
%> be passed by reference, not by value
classdef ModelWrapper < dynamicprops

  properties
    % universal properties

    %> The tag of this ModelWrapper -- usually also the tag of node
    tag

    %> The wrapped COMSOL object (if present)
    node

    %> This is the numerical index of this object compared to
    %> all other created objects. Used so objects can be sorted
    %> by creation time
    index

    %> This is node's parent COMSOL object. Present so we can call
    %> parent.remove() to delete the object in debug mode so it
    %> can be safely reconstructed.
    parent

    % common properties, so we don't need to create them every time

    %> name of this model data
    name

    %> -- getdomainselection is a function that when called as
    %> getdomainselection(model,geom,this_object) returns
    %> the entities of the object's domain selection
    getdomainselection

    %> this is a BuildLater for the mesh, except for the main
    %> model object, for which this is the main mesh object
    mesh

    %> this is a BuildLater for applying a material to a domain
    applymaterial

    %> a struct where each property name is the physics class and
    boundaryconditions

    %> Cell array of children. Often used by BuildLater
    %> functions
    %> the value is a cell array of struct with .classnames
    %> (cell array of applicable boundary condition class names), .tag (geometry
    %> portion of tag) and buildfunc  (anonymous build function)
    %> buildfunc is called as buildfunc(M,physics,bcobj)
    children

    %buildlaterwithnormal % a function for an incomplete object, to be called
                         % buildlaterwithnormal(model,geom,object,pos,normal)
    %buildlaterwithnormalpos % pos parameter for buildlaterwithnormal
  end

  methods
    %> [object] = ModelWrapper(M,tagname,parent):
    %> M -- ModelWrapper object for top-level model (not currently used)
    %> tagname -- name of object to create and enter into the database
    %> parent (optional) -- if this is provided, it is stored in the object
    %>                      so that if you need to destroy the object later
    %>                      you can call parent.remove(tagname)

    %> object is already created and default superclass constructor
    %> already called
    function [object]=ModelWrapper(M,tagname,parent)

      global WrappedObjectDB;
      global WrappedObjectDBDebug;

      % Set debug mode according to global variable
      if exist('WrappedObjectDBDebug','var') & WrappedObjectDBDebug
	debug=true;
      else
	debug=false;
      end

      % Create global WrappedObjectDB if not present
      if ~exist('WrappedObjectDB','var')
	WrappedObjectDB=struct;
      end

      % Check to see if this has been created already
      if isfield(WrappedObjectDB,tagname)  
        % field already exists
	if ~debug
	  error(sprintf('ModelWrapper: Tag ''%s'' already exists!',tagname));
	else 
          % In debug mode, auto-clear object
	  LogMsg(sprintf('Warning: ModelWrapper clearing object ''%s''!',tagname),1);
	  oldfield=WrappedObjectDB.(tagname);
	  ClearWrappedObjectStruct(oldfield)

	  if isprop(oldfield,'parent') & ~strcmp(class(oldfield.parent),'double')
            % parent specified -- try to remove
	    oldfield.parent.remove(tagname);
	  end
	end
      end
  

      %% Create object from ModelWrapper class
      %% (we don't need to do this now that we are a class constructor)
      %object=ModelWrapper;

      % assign tagname
      object.tag=tagname;

      % set index -- used for sorting so that things can be extracted
      %              in a consistent order
      object.index=length(fieldnames(WrappedObjectDB));
      % {tagname}
      WrappedObjectDB.(tagname)=object;

      % assign parent if provided
      if exist('parent','var')
	object.parent=parent;
      end
      
      
    end
    
    function result = setprop(obj,propname,propvalue)
      obj.(propname)=propvalue;
      result=propvalue;
    

    end

    function result = or(a,b)
      % or(a,b) -- pipe (vertical bar) operator -- used to pass output from one function as input to the next in the pipeline
      % a is the return value from the first function; b is the function to pass it to
      result = b(a);

    end

  end
end
