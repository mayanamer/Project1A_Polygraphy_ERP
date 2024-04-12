% script for running the wavelet analysis on signals
%% define the variables to use:
constScript;
data_to_use = final_data_4_channels;
% Write the table to an Excel file
file_name = 'feat_table_include_spatial_feats.xlsx';

%%
% Read the table from the file
table = readtable(file_name);

% Add an empty column at the 124th index
table = addvars(table, cell(size(table, 1), 1), 'After', 123); % Add an empty column after the 123rd column


fields = fieldnames(data_to_use);
for i = 1:numel(fields)
    field = fields{i};
    for j = 1:size(data_to_use.(field),2)
        
        % Perform on a small set of signals
        % Only 2 subjects for now. Delete "if" later
        % if data_to_use.(field){1,j}.sub > 1  
        %     continue;
        % elseif data_to_use.(field){1,j}.rep > 1
        %     continue;
        % end
        
        signal_name = structGetName(data_to_use.(field){1,j});
        disp(" ---- " + signal_name);

        % Insert the Tag for the signal
        tag = structGetTag(data_to_use.(field){1,j});
        
        % Fill the new column at index 124 with the tag value
        table{j, 124} = {tag};
    end
end

%%
T = cell2table(table, 'VariableNames', {'Signal', 'min_Fp1', 'max_Fp1', 'entropy_Fp1', 'delta_Fp1', 'alpha_Fp1', 'beta_Fp1', 'gamma_Fp1', 'max_slope_Fp1', ...
    'coeff1_Fp1', 'coeff2_Fp1', 'coeff3_Fp1', 'coeff4_Fp1', 'coeff5_Fp1','minc_Fp1', 'maxc_Fp1', 'entropyc_Fp1', 'deltac_Fp1', 'alphac_Fp1', 'betac_Fp1', 'gammac_Fp1', 'max slopec_Fp1', ...
    'min_Fp2', 'max_Fp2', 'entropy_Fp2', 'delta_Fp2', 'alpha_Fp2', 'beta_Fp2', 'gamma_Fp2', 'max_slope_Fp2', ...
    'coeff1_Fp2', 'coeff2_Fp2', 'coeff3_Fp2', 'coeff4_Fp2', 'coeff5_Fp2','minc_Fp2', 'maxc_Fp2', 'entropyc_Fp2', 'deltac_Fp2', 'alphac_Fp2', 'betac_Fp2', 'gammac_Fp2', 'max slopec_Fp2', ...
    'min_P3', 'max_P3', 'entropy_P3', 'delta_P3', 'alpha_P3', 'beta_P3', 'gamma_P3', 'max_slope_P3', ...
    'coeff1_P3', 'coeff2_P3', 'coeff3_P3', 'coeff4_P3', 'coeff5_P3','minc_P3', 'maxc_P3', 'entropyc_P3', 'deltac_P3', 'alphac_P3', 'betac_P3', 'gammac_P3', 'max slopec_P3', ...
    'min_P4', 'max_P4', 'entropy_P4', 'delta_P4', 'alpha_P4', 'beta_P4', 'gamma_P4', 'max_slope_P4', ...
    'coeff1_P4', 'coeff2_P4', 'coeff3_P4', 'coeff4_P4', 'coeff5_P4','minc_P4', 'maxc_P4', 'entropyc_P4', 'deltac_P4', 'alphac_P4', 'betac_P4', 'gammac_P4', 'max slopec_P4', ...
    'min_avg', 'max_avg', 'entropy_avg', 'delta_avg', 'alpha_avg', 'beta_avg', 'gamma_avg', 'max_slope_avg', ...
    'coeff1_avg', 'coeff2_avg', 'coeff3_avg', 'coeff4_avg', 'coeff5_avg','minc_avg', 'maxc_avg', 'entropyc_avg', 'deltac_avg', 'alphac_avg', 'betac_avg', 'gammac_avg', 'max slopec_avg', ...
    'min_p3-fp1', 'max_p3-fp1', 'entropy_p3-fp1', 'delta_p3-fp1', 'alpha_p3-fp1', 'beta_p3-fp1', 'gamma_p3-fp1', 'max_slope_p3-fp1', ...
    'min_p4-fp2', 'max_p4-fp2', 'entropy_p4-fp2', 'delta_p4-fp2', 'alpha_p4-fp2', 'beta_p4-fp2', 'gamma_p4-fp2', 'max_slope_p4-fp2', ...
    'TAG', '2nd_TAG'});  % Adjust 'VariableNames' for more columns.
disp(T);
% Write the table to an Excel file
filename = 'feat_table_2_and_3_tags.xlsx';
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
        tag = 'IRR';
    end
end