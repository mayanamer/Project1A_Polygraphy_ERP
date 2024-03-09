% script for running the wavelet analysis on signals
%% define the variables to use:
constScript;
data_to_use = final_data_4_channels;
FEATURE_NUM = 16;
%% get the signals
wvt_table = cell(0.0, FEATURE_NUM+7); 

fields = fieldnames(data_to_use);
for i = 1:numel(fields)
    field = fields{i};
    for j =1:size(data_to_use.(field),2)
        % ------- perform on a small set of signals ---------
        % only 2 subjects for now. delete "if" later
        if data_to_use.(field){1,j}.sub > 2  
            continue;
        elseif data_to_use.(field){1,j}.rep > 30
            continue;
        end
        % ---------------------------------------------------
        cropped_signal = data_to_use.(field){1,j}.tab(5,:);
        cropped_signal = cropped_signal(0.6*500:1*500);
        wvt_table{end+1,1} = structGetName(data_to_use.(field){1,j});
        feature_vector = extractFeaturs(cropped_signal);
        for h = 2:9
            wvt_table{end,h} = feature_vector(h-1);
        end
        [compressed, energy_levels] = wvt_compression(cropped_signal);
        for k = 1:numel(energy_levels)
            wvt_table{end, k+10} = energy_levels(k);
        end

        feature_vector = extractFeaturs(compressed);
        for t = 15:22
            wvt_table{end,t} = feature_vector(t-14);
        end
       wvt_table{end,23} = structGetTag(data_to_use.(field){1,j});
 
    end
end
%%
T = cell2table(wvt_table, 'VariableNames', {'Signal', 'min', 'max', 'entropy', ...
    'delta', 'alpha', 'beta', 'gamma', 'max slope', 'coeff1', 'coeff2',...
    'coeff3', 'coeff4', 'coeff5','minc', 'maxc', 'entropyc', ...
    'deltac', 'alphac', 'betac', 'gammac', 'max slopec', 'TAG'});  % Adjust 'VariableNames' for more columns.
disp(T);
% Write the table to an Excel file
filename = 'wvt_initial.xlsx';
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