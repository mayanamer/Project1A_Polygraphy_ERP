% feature_comparison_table
% this table will help us eveluate the features 
%% define the variables to use:
data_to_use = final_data_4_channels;
name_of_comparison_table = "feature_extraction_no_ground.xlsx";

%%

FEATURE_NUM = 8;
feat_comp_table = cell(0, FEATURE_NUM+2); 

fields = fieldnames(data_to_use);
for i = 1:numel(fields)
    field = fields{i};
    for j =1:size(data_to_use.(field),2)
        % if final_data.(field){1,j}.sub > 2  % only 2 subjects for now. delete "if" later
        %     continue;
        % elseif final_data.(field){1,j}.rep > 30
        %     continue;
        % end
        cropped_signal = data_to_use.(field){1,j}.tab(5,:);
        cropped_signal = cropped_signal(0.6*500:1*500);
        feature_vector = extractFeaturs(cropped_signal);
        feat_comp_table{end+1,1} = structGetName(data_to_use.(field){1,j});
        for t = 2:(FEATURE_NUM+1)
            feat_comp_table{end,t} = feature_vector(t-1);
           
        end
       feat_comp_table{end,FEATURE_NUM+2} = structGetTag(data_to_use.(field){1,j});
 
    end
end



% Create table
T = cell2table(feat_comp_table, 'VariableNames', {'Signal', 'min', 'max', 'entropy', ...
    'delta', 'alpha', 'beta', 'gamma', 'max slope', 'TAG'});  % Adjust 'VariableNames' for more columns.
disp(T);
% Write the table to an Excel file
filename = name_of_comparison_table;
writetable(T, filename);

%%
function [name] = structGetName(strt)
    name = "subject" + strt.sub + "_session" + strt.sess + "_rep" + strt.rep;
   
end

%%
function [tag] = structGetTag(strt)
    if (strcmp(strt.tag, "honest_target") || strcmp(strt.tag, "lying_target"))
        tag = 'T';
    elseif (strcmp(strt.tag, "lying_probe"))
        tag = 'GP';
    else
        tag = 'else';
    end
end