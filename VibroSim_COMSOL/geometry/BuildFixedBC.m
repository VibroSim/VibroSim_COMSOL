function BuildFixedBC(M,geom,ShapeObj,specimen,shape,pos,normalvec,angle,length,width)
%> @brief Apply fixed boundary condition to a specified rectangular or circular region on a flat surface
% Apply fixed boundary condition to a specified rectangular or circular region on a flat surface.
% If you just wanto t apply fixed boundary condition to a particular face, 
% use AddBoundaryCondition() and BuildFaceFixedBC() directly. 

if ~exist('angle','var')
  angle=0;
end




BuildThinContactor(M,geom,ShapeObj,specimen,shape,pos,normalvec,angle,length,width);






AddBoundaryCondition(M,geom,isolator,[ ShapeObj.tag '_fixedbc'], ...
		     {'solidmech_harmonicper','solidmech_harmonic','solidmech_modal','solidmech_timedomain'}, ... % physics
		     {'fixed'}, ... % BC classes
		     @(M,physics,bcobj) ...
		     BuildFaceFixedBC(M,geom,physics,ShapeObj,bcobj,ShapeObj.getcontactfaceselection));

