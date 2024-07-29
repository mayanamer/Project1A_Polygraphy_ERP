
%% get data from file
load("probe_feat_wt_coeff.mat", "probe_feat_wt_coeff");
data = eval("probe_feat_wt_coeff");


%% lengths of variables:
nDataSets = 2;  % guilty, honest
nVars = 5;      % frequency bands
nVals = length(data)/10;      % how many random sessions did we take? (1 means we took the feature of one signal)


% input data to be a vector containing all feature lists
% col1 = lying probe
% col2 = lying target
% ...
% data = rand(nVals*nVars*nDataSets,1);

freq_bands = {'Coeff1','Coeff2','Coeff3','Coeff4','Coeff5'};



%% box chart

% Create column vector to indicate dataset
dataSet = categorical([ones(nVars*nVals,1); ...
    ones(nVars*nVals,1)*2]);
dataSet = renamecats(dataSet,{'Guilty', 'Honest'});
% Create column vector to indicate the variable
clear var
% var(1:nVals,1) = "Var1";
% var(end+1:end+nVals,1) = "Var2";
% var(end+1:end+nVals,1) = "Var3";
% var(end+1:end+nVals,1) = "Var4";
% var(end+1:end+nVals,1) = "Var5";
vars = ["Var1"; "Var2"; "Var3"; "Var4"; "Var5"];
% var(1:nVals,1) = vars;
% var(end+1:end+nVals,1) = vars;
% var(end+1:end+nVals,1) = vars;
% var(end+1:end+nVals,1) = vars;
% var(end+1:end+nVals,1) = vars;

for i = 1 : 5 : 5*nVals
    var(i:i+4, 1) = vars;
end

Var = categorical([var;var]);
% Create a table
testData = table(data,dataSet,Var);

% Actual visualization code using boxchart
boxchart(testData.dataSet,testData.data,"GroupByColor",testData.Var)
legend(freq_bands,'Location','bestoutside','Orientation','vertical')
title('Wavelet Transform Coefficients in Probe Signals (1200 samples)')
grid on
grid minor





%% only coeff 5

nDataSets = 2;  % guilty, honest
nVars = 5;      % frequency bands
nVals = length(data)/10;      % how many random sessions did we take? (1 means we took the feature of one signal)

% Select only the data for 'Coeff5'
coeffIndex = 5; % Index for 'Coeff5'
coeffData = data(coeffIndex:nVars:end);

% Create column vector to indicate dataset
dataSet = categorical([ones(nVals,1); ones(nVals,1)*2]);
dataSet = renamecats(dataSet,{'Guilty', 'Honest'});

% Create column vector to indicate the variable (only 'Coeff5')
Var = repmat(categorical({'Coeff5'}), [2*nVals, 1]);

% Create a table
testData = table(coeffData, dataSet, Var, 'VariableNames', {'Data', 'DataSet', 'Var'});

% Actual visualization code using boxchart
boxchart(testData.DataSet, testData.Data, "GroupByColor", testData.Var);
legend({'Coeff5'}, 'Location', 'bestoutside', 'Orientation', 'vertical');
title('Wavelet Transform Coefficients in Probe Signals (1200 samples)');
grid on;
grid minor;

