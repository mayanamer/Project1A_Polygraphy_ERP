%% Play with model:
% load
load("trainedModel_MidNN_random_probe.mat")
NUM_SUBJECTS = 15;
types = {'lying', 'honest'};
T_THRESHOLD = 0.245;

excluded_subjects = [6 ,7 ,1, 5, 15];

%%


results = [];
thresholds = [];

for t = (0.1: 0.01: 0.55)

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

    
            avg_T_score = mean(scores(:,2));
    
            if avg_T_score >= t
                if strcmp(type, 'lying')
                    correct_liars = correct_liars + 1;
                else
                    false_liars = false_liars + 1;
                end
            else
                if strcmp(type, 'honest')
                    correct_truthtellers = correct_truthtellers + 1;
                else
                    false_truthtellers = false_truthtellers + 1;
                end
            end
        end
        
    end 
    
    result = (correct_truthtellers + correct_liars)*100/(2*NUM_SUBJECTS-10);
    results = [results, result];
    thresholds = [thresholds, t];
end



figure;
plot(thresholds, results);
title("Classification Result In Relation to Threshold Value");
xlabel("Threshold");
ylabel("Result [%]");



