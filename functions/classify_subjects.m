%% Play with model:
% load
load("trainedModel_MidNN_random_probe.mat")
NUM_SUBJECTS = 15;
types = {'lying', 'honest'};
T_THRESHOLD = 0.245;

excluded_subjects = [6 ,7 ,1, 5, 15];

%%

correct_liars = 0;
false_liars = 0;
correct_truthtellers = 0;
false_truthtellers = 0;

for i = 1:length(types)
    type = types{i};
    for sub = 1:NUM_SUBJECTS

        if ismember(sub, excluded_subjects)
            continue;
        end
    
        % Specify the Excel file and sheet
        filename = ['probe_excel_per_subject/sub', num2str(sub), '_', type, '.xlsx'];
        sheet = 'Sheet1';
        
        % Read the table from the Excel file
        data = readtable(filename, 'Sheet', sheet, 'VariableNamingRule', 'preserve');
        numRows = height(data);
        % Make predictions using the trained model
        [yfit, scores] = trainedModel_MidNN_random_probe.predictFcn(data);
        
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
        disp(['----------------  RESULTS  FOR SUB ' num2str(sub) ' ' type ' ----------------------']);
        disp(['ACCURACY: ' num2str(accuracy) '%.']);
        disp(['Number of Probe Signals: ' num2str(numRows) '.']);
        disp(['Correct Guilty Predictions: ' num2str(correct_target_predictions)]);
        disp(['Correct Honest Predictions: ' num2str(correct_nontarget_predictions)]);
        disp(['False Guilty Predictions: ' num2str(false_target_predictions)]);
        disp(['False Honest Predictions: ' num2str(false_nontarget_predictions)]);

        avg_T_score = mean(scores(:,2));
        disp(['average of prediction values: ' num2str(avg_T_score)]);

        if avg_T_score >= T_THRESHOLD
            disp('subject is classified as: LYING');
            if strcmp(type, 'lying')
                correct_liars = correct_liars + 1;
            else
                false_liars = false_liars + 1;
            end
        else
            disp('subject is classified as: HONEST');
            if strcmp(type, 'honest')
                correct_truthtellers = correct_truthtellers + 1;
            else
                false_truthtellers = false_truthtellers + 1;
            end
        end
    end
    
end 

disp('----------------- SUMMARY -----------------');
disp(num2str((correct_truthtellers + correct_liars)*100/(2*NUM_SUBJECTS-10)));

