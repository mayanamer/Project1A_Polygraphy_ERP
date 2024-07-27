%% Play with model:
% load
load("trainedModelNarrowNN.mat")

%%

% Specify the Excel file and sheet
filename = 'feature_table_corr_probe4.xlsx';
sheet = 'Sheet1';

% Read the table from the Excel file
data = readtable(filename, 'Sheet', sheet, 'VariableNamingRule', 'preserve');
numRows = height(data);
% Make predictions using the trained model
[yfit, scores] = trainedModelNN_probeT.predictFcn(data);

% Initialize counters for metrics
correct_predictions = 0;
correct_target_predictions = 0;
correct_nontarget_predictions = 0;
false_target_predictions = 0;
false_nontarget_predictions = 0;

% Evaluate predictions
for i = 1:numRows
    predicted_tag = yfit(i); % Extract categorical value
    true_tag = data.TAG{i}; % Extract true tag from data
    
    % Convert categorical to string for comparison
    predicted_tag_str = char(predicted_tag);
    
    % Handle predicted_tag based on its type (assuming it's a string)
    if strcmp(predicted_tag_str, true_tag)
        correct_predictions = correct_predictions + 1;
        if strcmp(true_tag, 'T')
            correct_target_predictions = correct_target_predictions + 1;
        else
            correct_nontarget_predictions = correct_nontarget_predictions + 1;
        end
    end

    if strcmp(true_tag, 'NT') && strcmp(predicted_tag_str, 'T')
        false_target_predictions = false_target_predictions + 1;
    elseif strcmp(true_tag, 'T') && strcmp(predicted_tag_str, 'NT')
        false_nontarget_predictions = false_nontarget_predictions + 1;
    end
end

% Calculate accuracy and display results
accuracy = (correct_predictions / numRows) * 100;
disp('----------------  RESULTS  ----------------------');
disp(['ACCURACY: ' num2str(accuracy) '%.']);
disp(['Number of Probe Signals: ' num2str(numRows) '.']);
disp(['Correct Guilty Predictions: ' num2str(correct_target_predictions)]);
disp(['Correct Honest Predictions: ' num2str(correct_nontarget_predictions)]);
disp(['False Guilty Predictions: ' num2str(false_target_predictions)]);
disp(['False Honest Predictions: ' num2str(false_nontarget_predictions)]);

%%
disp(['avg: ' num2str(mean(scores(1:size(scores, 1)/2,2)))]);

