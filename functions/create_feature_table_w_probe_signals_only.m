%% define the variables to use:
constScript;
load("final_data_4_channels.mat");
data_to_use = final_data_4_channels;
load("average_signals_table.mat");
%% get the signals
table = cell(0.0, 76); 
Fs = fs;

fields = fieldnames(data_to_use);
for i = 1:numel(fields)
    field = fields{i};
    for j =1:size(data_to_use.(field),2)

        % ------- perform on a small set of signals ---------
        % % only 2 subjects for now. delete "if" later
        % if data_to_use.(field){1,j}.sub > 1  
        %     continue;
        % elseif data_to_use.(field){1,j}.rep > 1
        %     continue;
        % end
        % ---------------------------------------------------
        
        % take only probe signals:
        if ~strcmp(data_to_use.(field){1,j}.tag, "honest_probe") && ~strcmp(data_to_use.(field){1,j}.tag, "lying_probe") 
            continue;
        end

        signal_name = structGetName(data_to_use.(field){1,j});
        disp(field + " #" + num2str(i) + " ---- " + signal_name);
        table{end+1,1} = signal_name;

        % FP2 ------------------------------------------------
        cropped_signal = data_to_use.(field){1,j}.tab(2,:);
        cropped_signal = cropped_signal(0.6*Fs+1:1*Fs);

        % insert basic features
        feature_vector = extractFeatures(cropped_signal);
        for h = 2:9
            table{end,h} = feature_vector(h-1);
        end

        % compress signal using wavelet analysis and get coefficients
        [compressed, energy_levels] = wvt_compression(cropped_signal);
        for k = 1:numel(energy_levels)
            table{end, k+9} = energy_levels(k);
        end

        % extract same basic features but on compressed signal
        feature_vector = extractFeatures(compressed);
        for t = 15:22
            table{end,t} = feature_vector(t-14);
        end

        
        %-------------- AVG -----------------
        cropped_signal = data_to_use.(field){1,j}.tab(5,:);
        cropped_signal = cropped_signal(0.6*Fs+1:1*Fs);
        
        % insert basic features
        feature_vector = extractFeatures(cropped_signal);
        for h = 23:30
            table{end,h} = feature_vector(h-22);
        end
        
        % compress signal using wavelet analysis and get coefficients
        [compressed, energy_levels] = wvt_compression(cropped_signal);
        for k = 1:numel(energy_levels)
            table{end, k+30} = energy_levels(k);
        end
        
        % extract same basic features but on compressed signal
        feature_vector = extractFeatures(compressed);
        for t = 36:43
            table{end,t} = feature_vector(t-35);
        end

        %-------------- SPATIAL FEATURES -----------------

        % P3 - FP1 ---------------------------------------
        cropped_signal = data_to_use.(field){1,j}.tab(3,:) - data_to_use.(field){1,j}.tab(1,:);
        cropped_signal = cropped_signal(0.6*Fs+1:1*Fs);
        feature_vector = extractFeatures(cropped_signal);
        for h = 44:51
            table{end,h} = feature_vector(h-43);
        end

        % P4 - FP2 ---------------------------------------
        cropped_signal = data_to_use.(field){1,j}.tab(4,:) - data_to_use.(field){1,j}.tab(2,:);
        cropped_signal = cropped_signal(0.6*Fs+1:1*Fs);
        feature_vector = extractFeatures(cropped_signal);
        for h = 52:59
            table{end,h} = feature_vector(h-51);
        end


        % subtract the irrelevant avg of the subject 
        cropped_signal = data_to_use.(field){1,j}.tab(5,:);
        cropped_signal = cropped_signal(0.6*Fs+1:1*Fs);
        sub_num = data_to_use.(field){1,j}.sub;
        if contains(data_to_use.(field){1,j}.tag, "honest")
            sig_irr = cropped_signal - average_signals_table.honest_irrelevant{sub_num,1};
            tar_sig = average_signals_table.honest_target{sub_num,1} - cropped_signal;
        else
            sig_irr = cropped_signal - average_signals_table.lying_irrelevant{sub_num,1};
            tar_sig = average_signals_table.lying_target{sub_num,1} - cropped_signal;
        end

        % extract features on each signal diff
        feature_vector = extractFeatures(sig_irr);
        for h = 60:67
            table{end,h} = feature_vector(h-59);
        end

        feature_vector = extractFeatures(tar_sig);
        for h = 68:75
            table{end,h} = feature_vector(h-67);
        end

        % insert the Tag for the signal
       table{end,76} = structGetTag(data_to_use.(field){1,j});
 
    end
end
%%
T = cell2table(table, 'VariableNames', {'Signal', ...
    'min_Fp2', 'max_Fp2', 'entropy_Fp2', 'delta_Fp2', 'alpha_Fp2', 'beta_Fp2', 'gamma_Fp2', 'peak2peak_Fp2', ...
    'coeff1_Fp2', 'coeff2_Fp2', 'coeff3_Fp2', 'coeff4_Fp2', 'coeff5_Fp2','minc_Fp2', 'maxc_Fp2', 'entropyc_Fp2', 'deltac_Fp2', 'alphac_Fp2', 'betac_Fp2', 'gammac_Fp2', 'peak2peakc_Fp2', ...
    'min_avg', 'max_avg', 'entropy_avg', 'delta_avg', 'alpha_avg', 'beta_avg', 'gamma_avg', 'peak2peak_avg', ...
    'coeff1_avg', 'coeff2_avg', 'coeff3_avg', 'coeff4_avg', 'coeff5_avg','minc_avg', 'maxc_avg', 'entropyc_avg', 'deltac_avg', 'alphac_avg', 'betac_avg', 'gammac_avg', 'peak2peakc_avg', ...
    'min_p3-fp1', 'max_p3-fp1', 'entropy_p3-fp1', 'delta_p3-fp1', 'alpha_p3-fp1', 'beta_p3-fp1', 'gamma_p3-fp1', 'peak2peak_p3-fp1', ...
    'min_p4-fp2', 'max_p4-fp2', 'entropy_p4-fp2', 'delta_p4-fp2', 'alpha_p4-fp2', 'beta_p4-fp2', 'gamma_p4-fp2', 'peak2peak_p4-fp2', ...
    'min_sig_irr', 'max_sig_irr', 'entropy_sig_irr', 'delta_sig_irr', 'alpha_sig_irr', 'beta_sig_irr', 'gamma_sig_irr', 'peak2peak_sig_irr', ...
    'min_tar_sig', 'max_tar_sig', 'entropy_tar_sig', 'delta_tar_sig', 'alpha_tar_sig', 'beta_tar_sig', 'gamma_tar_sig', 'peak2peak_tar_sig', ...
    'TAG'});  % Adjust 'VariableNames' for more columns.
disp(T);
% Write the table to an Excel file
filename = 'feat_table_probe_only.xlsx';
writetable(T, filename);

%%
function [name] = structGetName(strt)
    name = "subject" + strt.sub + "_session" + strt.sess + "_rep" + strt.rep;
   
end

%%
function [tag] = structGetTag(strt)
    if strcmp(strt.tag, "honest_probe")
        tag = 'Honest';
    else
        tag = 'Lying';
    end
end