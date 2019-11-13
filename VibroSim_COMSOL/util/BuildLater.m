%> This class is intended to represent wrapped models that
%> are not instantiated immediately on creation, but need
%. to be built at some later time.

%> This is a common need, because often you want to define things
%> together, but one of the things must be built much later in
%> the model instantiation process than the other. For example,
%> it often makes sense to integrate the specification of some
%> boundary conditions with the geometry construction. Unfortunately,
%> boundary conditions cannot be set until much later, after
%> the physics nodes have been selected and create. Similar
%> situations occur with meshing, material selection, and with
%> autodetermining orientations through surface-normal extraction.
%>
%> The way all this is accomplished is by instantiating BuildLater
%> objects, which provide an immediate lasting references to
%> objects that don't exist yet. The BuildLater objects
%> also store the callable object to be used to create
%> the object when the time comes.
%>
%> The BuildLater object is given one or more class names,
%> that are placed in its 'buildlaterclasses' cell array
%> of strings. When it is time to build a certain class
%> of objects, use FindBuildLater() to extract all of the
%> buildlater objects matching a particular class.
%> Then you can call the buildfcn() method with appropriate
%> arguments.
%>
%> ALWAYS BE SURE TO SET THE is_built PROPERTY AFTER
%> CALLING BUILDFCN!!!
%>
%> NOTE: The buildfcn should almost always set the .parent
%> property to what would otherwise be the 3rd argument to
%> ModelWrapper(), so that the created COMSOL Objects can
%> be properly destroyed.
classdef BuildLater < ModelWrapper

  properties
    % implicitly inherits all properties of ModelWrapper

    %> cell array of strings representing the 'class'es
    %> of BuildLater object that this object satisifes.
    %> These classes represent the different opportunities
    %> and calling conventions for BuildLater objects
    %> to be built.
    buildlaterclasses

    %> true, or false. The routine that searches out and
    %> builds the objects should set this flag once it
    %> has built the object.
    is_built

    %> the function to call to build this object. The
    %> required arguments depend on context
    %> The buildfcn usually needs to manually set
    %> the .parent element so in debug mode we have
    %> a way to destroy the wrapped COMSOL object
    buildfcn

    %children   % a cell array that may be populated by the build function
               % if it turns out that more than one object must be built.
               % if so, the node parameter (defined by ModelWrapper)
               % may be blank ( [] ).
               % NOTE: 'children' is now a property of ModelWrapper (superclass)

  end

  methods
    %> function object=BuildLater(M,tag,buildlaterclasses,buildfcn)
    %>
    %> Create a BuildLater object that represents something
    %> that still needs to be built.
    %>
    %> Parameters
    %> ----------
    %> M:                 ModelWrapper for top level model
    %> tag:               Desired tag
    %> buildlaterclasses: String or cell array of strings representing
    %>                    classification(s) of this BuildLater object.
    %> buildfcn:          Function to call to build the object.
    %>                    Parameters vary by buildlaterclass
    function object=BuildLater(M,tag,buildlaterclasses,buildfcn)

      % Call superclass
      object=object@ModelWrapper(M,tag);

      if isa(buildlaterclasses,'char') | isa(buildlaterclasses,'string')
	% single class entry
	object.buildlaterclasses={buildlaterclasses};
      else
	% presumed to be multiple class entry
	object.buildlaterclasses=buildlaterclasses;
      end

      object.is_built=false;
      object.buildfcn=buildfcn;
      object.children={};
    end
  end
end
