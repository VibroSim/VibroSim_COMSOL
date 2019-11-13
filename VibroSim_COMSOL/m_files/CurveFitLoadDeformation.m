%> CURVEFITLOADDEFORMATION fits a polynomial to the load deformation data found in the file filename
function[coeffs]=CurveFitLoadDeformation(filename,degree,thresholdload)

    data=load(filename);
    appliedload=data(:,1);
    deformation=data(:,2);
    appliedload_truncated=appliedload(abs(appliedload) > abs(thresholdload));
    deformation_truncated=deformation(abs(appliedload) > abs(thresholdload));
    coeffs = polyfit(deformation_truncated,appliedload_truncated,degree);
    reconstructed_load=coeffs(1)*deformation_truncated.^4+coeffs(2)*deformation_truncated.^3+coeffs(3)*deformation_truncated.^2+coeffs(4)*deformation_truncated+coeffs(5)*ones(size(deformation_truncated),1);

    %figure;
    %plot(deformation,appliedload,'b.');
    %hold on;
    %plot(deformation_truncated,reconstructed_load,'r');
    %xlabel('Deformation(m)');
    %ylabel('Load(N)');
end
    
