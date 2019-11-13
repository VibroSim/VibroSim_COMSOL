%> CalcQFactor calculates the Q factor from the displacement curve.
%> [Qfactor] = CalcQfactor(freqs,displ) calculates the Q factor of the vibration from the frequency response.
%> Q factor is defined as: (resonance frequency)/(bandwidth)
%> bandwidth is the frequency range between which peak amplitude reduces by 3db, or to 0.707 of its value
function [Qfactor] = CalcQfactor(freqbase,displ)


    function [minindex] = argmin(array)
       [minval,minindex]=min(array);
    end


    % find peak value
    [maxval,maxindex]=max(displ)
    resonancefrequency=freqbase(maxindex)
    threedbval=0.707*maxval
    upperbandwidthlimit=argmin(abs(displ(maxindex:length(displ))-threedbval));
    lowerbandwidthlimit=argmin(abs(displ(1:maxindex)-threedbval));
    bandwidth=freqbase(maxindex+upperbandwidthlimit)-freqbase(lowerbandwidthlimit);
    Qfactor=freqbase(maxindex)/bandwidth;
    dampingratio=0.5/Qfactor;
    sprintf('lower freq limit: %g, upper freq limit: %g', freqbase(lowerbandwidthlimit),freqbase(maxindex+upperbandwidthlimit))
    sprintf('bandwidth: %g', bandwidth)
    sprintf('Qfactor: %g', Qfactor)

    close all;
    plot(freqbase,displ,'.');
    hold on;
    % vertical line at lower bw limit
    hy = graph2d.constantline(freqbase(lowerbandwidthlimit), 'Color',[.7 .7 .7]);
    changedependvar(hy,'x');
    % vertical line at upper bw limit
    hy = graph2d.constantline(freqbase(maxindex+upperbandwidthlimit), 'Color',[.7 .7 .7]);
    changedependvar(hy,'x');
    % horizontal line at 0.707th of maximum
    hx = graph2d.constantline(threedbval, 'Color',[.7 .7 .7]);
    ylim([min(displ),max(displ)])

end

