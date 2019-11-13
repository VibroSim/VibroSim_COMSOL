function estimate = meeker_statmodel_040815_eval(freqvec, centerstrainmagvec, semimajoraxislenvec, closurevec, semimajoraxispos1vec, semimajoraxispos2vec, whvec, percentilevec)

global SDv0
global SDv1
global deviance
global mu_trans_spread
global muv0
global muv1
global rho
global sd_trans_spread
global meeker_statmodel_040815_paramcache
global meeker_statmodel_040815_resultcache

if ~exist('SDv0','var') | length(SDv0) < 1
  % load data in if we haven't already
  fprintf(2,'loading data file!\n');
  % Load in data from draws file  
  fh=fopen('meeker_statmodel_040815_vbt.draws.frame.csv','r');
  titles=fgets(fh);

  % Verify correct column titles
  assert(strcmp(titles,sprintf('"","SDv0","SDv1","deviance","mu.trans.spread","muv0","muv1","rho","sd.trans.spread"\r\n')));

  C=textscan(fh,'%[^,],%f,%f,%f,%f,%f,%f,%f,%f');
  fclose(fh);

  indexstr=C{1};
  SDv0=C{2};
  SDv1=C{3};
  deviance=C{4};
  mu_trans_spread=C{5};
  muv0=C{6};
  muv1=C{7};
  rho=C{8};
  sd_trans_spread=C{9};
end 
% M1 and L0 fixed based on prior estimates for this model
M1=1/0.25e-3;
L0=0.40e-3;

numdraws=length(muv0);
numiter=length(freqvec);

% define results
estimate=zeros(size(freqvec));

% Iterate over vectors passed to us from COMSOL
for iter=1:numiter
  freq=freqvec(iter);
  centerstrainmag=centerstrainmagvec(iter);
  semimajoraxislen=semimajoraxislenvec(iter);
  closure=closurevec(iter);
  semimajoraxispos1=semimajoraxispos1vec(iter);
  semimajoraxispos2=semimajoraxispos2vec(iter);
  wh=whvec(iter);
  percentile=percentilevec(iter);

  % look up this problem in our cache
  paramvec=[ freq centerstrainmag semimajoraxislen closure semimajoraxispos1 semimajoraxispos2 wh percentile ];
  
  matchingcacherows=[];
  if prod(size(meeker_statmodel_040815_paramcache)) ~= 0
    matchingcacherows=find(ismember(meeker_statmodel_040815_paramcache,paramvec,'rows'));
  end
  if length(matchingcacherows) > 0 
    % Use cached result
    fprintf(2,'Using cached result!\n');
    estimate(iter)=meeker_statmodel_040815_resultcache(matchingcacherows(1));
  else
    fprintf(2,'freq=%g, centerstrainmag=%g, semimajoraxislen=%g, closure=%g, semimajoraxispos1=%g, semimajoraxispos2=%g, wh=%g, percentile=%g\n',freq,centerstrainmag,semimajoraxislen,closure,semimajoraxispos1,semimajoraxispos2,wh,percentile);


    log_freq=log(freq);
    NormalizedLogStrain=log(centerstrainmag/50e-6);


    % Primitive unit checking, since COMSOL Matlab interface doesn't currently 
    % do unit checking
    assert(freq > 100)
    assert(abs(centerstrainmag) < 1e-3)
    assert(semimajoraxislen < 0.1);
    % no practical way to check closure units! ... print it instead
    fprintf(2,'Got closure: %f Pa; numiter=%d\n',closure,numiter);
    assert(abs(semimajoraxispos1) < 0.1);
    assert(abs(semimajoraxispos2) < 0.1);
    assert(wh > 0.1e6);
    assert(percentile > 1.0);



    ltip=(semimajoraxislen - ((semimajoraxispos1  + semimajoraxispos2)/2));


    % Thermal power 
    TP=zeros(numdraws,1);

    % ... based on Bill Meeker's R code for evaluating
    % model from draws
 
    % iterate over each draw
    for i=1:numdraws


      % Evaluate draw from spread via transformation:
      % " The transformation is -1/(spread)^3
      %   The -1 is a convention that is used with negative powers so 
      %   that the transformation is increasing (not really necessary, 
      %   but important if one is going to plot the transformed values 
      %   (which I was doing in the q-q plot).

      %   The first five lines of the draws are:

      %   > > vbt.draws.frame[1:5,]
      %        SDv0  SDv1 deviance mu.trans.spread muv0 muv1    rho sd.trans.spread
      %   [1,] 0.395 0.597   110        -2.49      2.74 2.04  0.189       1.57
      %   [2,] 0.600 0.794   102        -2.68      2.90 1.77 -0.187       1.61
      %   [3,] 0.674 0.765   110        -3.62      2.86 1.70 -0.503       1.03
      %   [4,] 0.720 0.740   104        -3.40      2.78 1.78 -0.516       2.02
      %   [5,] 0.861 0.740   102        -3.23      2.61 1.88 -0.243       1.40

      %   By looking at the mu.trans.spread and sd.trans.spread columns, 
      %   you can see that there is a small positive probability that the 
      %   generated normal variety will be positive. If I get such a value, 
      %   I just simulate another one until I get one that is negative, then
      %   do the inverse transformation, yielding a positive spread parameter."
      spread=NaN;
      while isnan(spread)
        trans_spread=mu_trans_spread(i)+sd_trans_spread(i)*randn(1);
        if trans_spread < 0
          spread =  (-trans_spread)^(-1/3);
        end
      end


      % Then we pull out the variances and covariances of v0 and v1
      % and assemble them into a matrix:

      Varv0=SDv0(i)^2;
      Varv1=SDv1(i)^2;
      Cov=rho(i)*sqrt(Varv0*Varv1);
      SigmaMat = [ Varv0 Cov ; Cov Varv1 ];

      % ... Then we take a draw from the specified joint distribution for v0, v1:
      v0v1=mvnrnd([ muv0(i) muv1(i) ], SigmaMat);

      %... Now we take a draw of the "spread" draw to get deviation 
      deviation = randn(1)*spread;

      % ... Finally we evaluate the thermal power, based on all these draws
      log_closure = -log(4*wh/1e6) - abs(closure/(2*wh)); % NOTE: wh/1e6 is divided by 1e6 because closure model was fitted with wh and closure in MPa where as we are operating in base units (Pa)

      logV = v0v1(1) + v0v1(2)*NormalizedLogStrain;
      log_mobility = log(1/(1+exp(-M1*(ltip-L0))));

      TP(i) = exp(logV + log_closure + log_mobility + log_freq + deviation);

    end

    sortedTP=sort(TP);
    estimate(iter)=sortedTP(round(numdraws*percentile/100));
    fprintf(2,'Returning estimate: %f Watts/m^2\n',estimate(iter));
    % add estimate to cache

    entrypos=size(meeker_statmodel_040815_paramcache,1)+1;
    meeker_statmodel_040815_paramcache(entrypos,:)=paramvec;
    meeker_statmodel_040815_resultcache(entrypos,1)=estimate(iter);

  end

end

