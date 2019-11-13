function [closestfreq,closestfreqidx]=FindClosestFreq(model,geomtag,physicstag,targetfreq,solutiontag)

if ~exist('solutiontag','var')
  solutiontag=[ physicstag '_solution' ];
end

freqs=mphinterp(model,{ 'freq' }, 'Coord',[0,0,0]','dataset', GetDataSetForSolution(model,solutiontag));

[junk,closestfreqidx]=min(abs(freqs-targetfreq));

closestfreq=freqs(closestfreqidx);
