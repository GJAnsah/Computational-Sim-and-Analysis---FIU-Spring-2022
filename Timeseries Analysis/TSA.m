%% BME 6717: Timeseries Analysis

% Data have been collected on two cellular processes that are suspected to
% causally related to one another. The CellProcess.mat dataset contains the 
% relative intracellular concentrations (normalized difference from cell 
% baseline levels (a.u.)) of two molecules: ligands for the Alpha Complex
% and ligands for TRPV1 channels, sampled once per minute. 
% Analyze the Alpha Complex and TRPV1 timeseries to determine how they are 
% related to one another. Estimate the potential for a causal relation
% between the processes generating these ligands, 
% and justify your analysis.
% 
% Suggestion: You may use any analysis methods you wish, but it may be 
% useful to start with the  hypothesis that these are autoregressive 
% processes.

%% IMPORTING DATA

CellProcess = importdata('CellProcess.mat');

Alpha = CellProcess.AlphaComplex;
TRPV1 = CellProcess.TRPV1;
time= CellProcess.Time;

%% VISUALIZATION

figure(1)
plot(time, Alpha, time, TRPV1)
legend('Alpha Complex','TRPV1')
xlabel('Time(min)')
ylabel('Relative Intracellular Concentrations')
title(["Relative Intracellular Concentrations";...
    "of ligands for the Alpha Complex and ligands for TRPV1 channels."])

%% CORRELATION BTWN LIGANDS
corrcoef( Alpha, TRPV1)

%% DETRENDING

%first difference
diff_Alpha = diff(Alpha);
diff_TRPV1 = diff(TRPV1);

%log
log_Alpha = abs(log(Alpha));
log_TRPV1 = abs(log(TRPV1));


figure(2)
subplot(211)
plot(time(2:end), diff_Alpha, time(2:end), diff_TRPV1)
ylabel({'First difference';'Detrended Concentrations'})
legend('Alpha Complex','TRPV1')
title("Detrended Relative Intracellular Concentrations")

subplot(212)
plot(time, log_Alpha, time, log_TRPV1)
legend('Alpha Complex','TRPV1')
ylabel({'Logarithm Detrended';'Concentrations'})
xlabel('time')

%% Comparing Original and Detrended Data
figure(3)
subplot(311)
plot(Alpha, TRPV1,'.')
title('Comparing Original and Detrended Data')
ylabel({'Original ';'TRPV1 Concentrations'})
xlabel("Original Alpha Complex Concentrations")

subplot(312)
plot(log_Alpha, log_TRPV1,'.')
ylabel({'Log detrended ';'TRPV1 Concentrations'})
xlabel("Log detrended Alpha Complex Concentrations")

subplot(313)
plot(diff_Alpha, diff_TRPV1,'.')
ylabel({'diff detrended ';'TRPV1 Concentrations'})
xlabel("diff detrended Alpha Complex Concentrations")


%% Cross Correlation btn data
%original
[acor,lag] = crosscorr(Alpha,TRPV1);
[~,I] = max(abs(acor));
lag(I)
corrcoef( Alpha(-lag(I):349), TRPV1(1:end+lag(I)))
%% 
%first difference
[acor,lag] = crosscorr(diff_Alpha,diff_TRPV1);
[~,I] = max(abs(acor));
lag(I)
corrcoef( Alpha(-lag(I):349), TRPV1(1:end+lag(I)))
%% 

% log
[acor,lag] = crosscorr(log_Alpha,log_TRPV1);
[~,I] = max(abs(acor));
lag(I)
corrcoef( Alpha(-lag(I):349), TRPV1(1:end+lag(I)))

%% REGRESSION MODELLING AND CAUSALITY CHECK

%% does trpv1 granger-cause alpha 
Mdl = regARIMA(2,0,0);
Alpha_Mdl = estimate(Mdl,Alpha');
Alpha_Mdl_T = estimate(Mdl,Alpha','X',TRPV1');

[h,pvalue,stat,cvalue] = gctest(TRPV1',Alpha','NumLags',2,'Test','f');
disp([' reject null ','  pvalue ','   stat ','    cvalue '])
disp([h,pvalue,stat,cvalue])

%% does alpha granger-cause trpv1
Mdl = regARIMA(2,0,0);
TRPV1_Mdl = estimate(Mdl,TRPV1');
TRPV1_Mdl_A = estimate(Mdl,TRPV1','X',Alpha');

[h,pvalue,stat,cvalue] = gctest(Alpha',TRPV1','NumLags',2,'Test','f');
disp([' reject null ','  pvalue ','   stat ','    cvalue '])
disp([h,pvalue,stat,cvalue])