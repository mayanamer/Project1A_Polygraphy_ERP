%% define the variables to use:
constScript;
data_to_use = final_data_4_channels;
load("average_signals_table.mat");
load("average_features_table.mat");
%% get the signals
table = cell(0.0, 94); 
Fs = fs;

fields = fieldnames(data_to_use);
for i = 1:numel(fields)
    field = fields{i};
    for j =1:size(data_to_use.(field),2)

        % ------- ignore probe signals ---------
        % if (strcmp(data_to_use.(field){1,j}.tag, "honest_probe") || strcmp(data_to_use.(field){1,j}.tag, "lying_probe"))
        %     continue;
        % end
        % if (strcmp(data_to_use.(field){1,j}.tag, "honest_irrelevant") || strcmp(data_to_use.(field){1,j}.tag, "lying_irrelevant")) || data_to_use.(field){1,j}.sub > 1
        %     continue;
        % end
        % ---------------------------------------------------

        signal_name = structGetName(data_to_use.(field){1,j});
        disp(field + " #" + num2str(i) + " ---- " + signal_name);
        table{end+1,1} = signal_name;

        % FP2 ------------------------------------------------
        cropped_signal = data_to_use.(field){1,j}.tab(2,:);
        cropped_signal = cropped_signal(0.6*Fs+1:1*Fs);

        % insert basic features
        feature_vector = extractFeatures(cropped_signal);
        for h = 2:11
            table{end,h} = feature_vector(h-1);
        end

        % compress signal using wavelet analysis and get coefficients
        [compressed, energy_levels] = wvt_compression(cropped_signal);
        for k = 1:numel(energy_levels)
            table{end, k+11} = energy_levels(k);
        end

        % extract same basic features but on compressed signal
        feature_vector = extractFeatures(compressed);
        for t = 17:26
            table{end,t} = feature_vector(t-16);
        end

        
        %-------------- AVG -----------------
        cropped_signal = data_to_use.(field){1,j}.tab(5,:);
        cropped_signal = cropped_signal(0.6*Fs+1:1*Fs);
        
        % insert basic features
        feature_vector = extractFeatures(cropped_signal);
        for h = 27:36
            table{end,h} = feature_vector(h-26);
        end
        
        % compress signal using wavelet analysis and get coefficients
        [compressed, energy_levels] = wvt_compression(cropped_signal);
        for k = 1:numel(energy_levels)
            table{end, k+36} = energy_levels(k);
        end
        
        % extract same basic features but on compressed signal
        feature_vector = extractFeatures(compressed);
        for t = 42:51
            table{end,t} = feature_vector(t-41);
        end

        %-------------- SPATIAL FEATURES -----------------

        % % P3 - FP1 ---------------------------------------
        % cropped_signal = data_to_use.(field){1,j}.tab(3,:) - data_to_use.(field){1,j}.tab(1,:);
        % cropped_signal = cropped_signal(0.6*Fs+1:1*Fs);
        % feature_vector = extractFeatures(cropped_signal);
        % for h = 46:53
        %     table{end,h} = feature_vector(h-45);
        % end
        % 
        % % P4 - FP2 ---------------------------------------
        % cropped_signal = data_to_use.(field){1,j}.tab(4,:) - data_to_use.(field){1,j}.tab(2,:);
        % cropped_signal = cropped_signal(0.6*Fs+1:1*Fs);
        % feature_vector = extractFeatures(cropped_signal);
        % for h = 54:61
        %     table{end,h} = feature_vector(h-53);
        % end
           
        % P3 - FP1 ---------------------------------------
        p3_cropped = data_to_use.(field){1,j}.tab(3,:);
        p3_cropped = p3_cropped(0.6*Fs+1:1*Fs);
        fp1_cropped = data_to_use.(field){1,j}.tab(1,:);
        fp1_cropped = fp1_cropped(0.6*Fs+1:1*Fs);
        correlation = xcorr(p3_cropped, fp1_cropped);
        feature_vector = extractFeatures(correlation);
        for h = 52:61
            table{end,h} = feature_vector(h-51);
        end

        % Find the indices of the minimum and maximum amplitude
        [~, minIndex] = min(correlation);
        [~, maxIndex] = max(correlation);
        
        % Calculate the difference in samples
        table{end,62} = abs(maxIndex - minIndex);

        % P4 - FP2 ---------------------------------------
        p4_cropped = data_to_use.(field){1,j}.tab(4,:);
        p4_cropped = p4_cropped(0.6*Fs+1:1*Fs);
        fp2_cropped = data_to_use.(field){1,j}.tab(2,:);
        fp2_cropped = fp2_cropped(0.6*Fs+1:1*Fs);
        correlation = xcorr(p4_cropped, fp2_cropped);
        feature_vector = extractFeatures(correlation);
        for h = 63:72
            table{end,h} = feature_vector(h-62);
        end

        % Find the indices of the minimum and maximum amplitude
        [~, minIndex] = min(correlation);
        [~, maxIndex] = max(correlation);
        
        % Calculate the difference in samples
        table{end,73} = abs(maxIndex - minIndex);


        % subtract the irrelevant avg of the subject 
        cropped_signal = data_to_use.(field){1,j}.tab(5,:);
        cropped_signal = cropped_signal(0.6*Fs+1:1*Fs);
        sub_num = data_to_use.(field){1,j}.sub;
        % if contains(data_to_use.(field){1,j}.tag, "honest")
        %     sig_irr = cropped_signal - average_signals_table.honest_irrelevant{sub_num,1};
        %     tar_sig = average_signals_table.honest_target{sub_num,1} - cropped_signal;
        % else
        %     sig_irr = cropped_signal - average_signals_table.lying_irrelevant{sub_num,1};
        %     tar_sig = average_signals_table.lying_target{sub_num,1} - cropped_signal;
        % end
        % 
        % % extract features on each signal diff
        % feature_vector = extractFeatures(sig_irr);
        % for h = 62:69
        %     table{end,h} = feature_vector(h-61);
        % end
        % 
        % feature_vector = extractFeatures(tar_sig);
        % for h = 70:77
        %     table{end,h} = feature_vector(h-69);
        % end

        if contains(data_to_use.(field){1,j}.tag, "honest")
            feature_vector = extractFeatures(cropped_signal) - extractFeatures(average_signals_table.honest_irrelevant{sub_num,1});
            for h = 74:83
                table{end,h} = feature_vector(h-73);
            end
            feature_vector = extractFeatures(average_signals_table.honest_target{sub_num,1}) - extractFeatures(cropped_signal);
            for h = 84:93
                table{end,h} = feature_vector(h-83);
            end
        else
            feature_vector = extractFeatures(cropped_signal) - extractFeatures(average_signals_table.lying_irrelevant{sub_num,1});
            for h = 74:83
                table{end,h} = feature_vector(h-73);
            end
            feature_vector = extractFeatures(average_signals_table.lying_target{sub_num,1}) - extractFeatures(cropped_signal);
            for h = 84:93
                table{end,h} = feature_vector(h-83);
            end
        end

        % insert the Tag for the signal
       table{end,94} = structGetTag(data_to_use.(field){1,j});
 
    end
end
%%
T = cell2table(table, 'VariableNames', {'Signal', ...
    'abs_min_Fp2', 'abs_max_Fp2','min_Fp2', 'max_Fp2', 'entropy_Fp2', 'delta_Fp2', 'alpha_Fp2', 'beta_Fp2', 'gamma_Fp2', 'peak2peak_Fp2', ...
    'coeff1_Fp2', 'coeff2_Fp2', 'coeff3_Fp2', 'coeff4_Fp2', 'coeff5_Fp2','abs_minc_Fp2', 'abs_maxc_Fp2','minc_Fp2', 'maxc_Fp2', 'entropyc_Fp2', 'deltac_Fp2', 'alphac_Fp2', 'betac_Fp2', 'gammac_Fp2', 'peak2peakc_Fp2', ...
    'abs_min_avg', 'abs_max_avg','min_avg', 'max_avg', 'entropy_avg', 'delta_avg', 'alpha_avg', 'beta_avg', 'gamma_avg', 'peak2peak_avg', ...
    'coeff1_avg', 'coeff2_avg', 'coeff3_avg', 'coeff4_avg', 'coeff5_avg','abs_minc_avg', 'abs_maxc_avg','minc_avg', 'maxc_avg', 'entropyc_avg', 'deltac_avg', 'alphac_avg', 'betac_avg', 'gammac_avg', 'peak2peakc_avg', ...
    'abs_min_p3-fp1', 'abs_max_p3-fp1','min_p3-fp1', 'max_p3-fp1', 'entropy_p3-fp1', 'delta_p3-fp1', 'alpha_p3-fp1', 'beta_p3-fp1', 'gamma_p3-fp1', 'peak2peak_p3-fp1', 'diff_max_min_p3-fp1', ...
    'abs_min_p4-fp2', 'abs_max_p4-fp2','min_p4-fp2', 'max_p4-fp2', 'entropy_p4-fp2', 'delta_p4-fp2', 'alpha_p4-fp2', 'beta_p4-fp2', 'gamma_p4-fp2', 'peak2peak_p4-fp2', 'diff_max_min_p4-fp2', ...
    'abs_min_sig_irr', 'abs_max_sig_irr','min_sig_irr', 'max_sig_irr', 'entropy_sig_irr', 'delta_sig_irr', 'alpha_sig_irr', 'beta_sig_irr', 'gamma_sig_irr', 'peak2peak_sig_irr', ...
    'abs_min_tar_sig', 'abs_max_tar_sig', 'min_tar_sig', 'max_tar_sig','entropy_tar_sig', 'delta_tar_sig', 'alpha_tar_sig', 'beta_tar_sig', 'gamma_tar_sig', 'peak2peak_tar_sig', ...
    'TAG'});  % Adjust 'VariableNames' for more columns.
disp(T);
% Write the table to an Excel file
filename = 'feature_table_w_corr.xlsx';
writetable(T, filename);

%%
function [name] = structGetName(strt)
    name = "subject" + strt.sub + "_session" + strt.sess + "_rep" + strt.rep + "_" + strt.tag;
   
end

%%
function [tag] = structGetTag(strt)
    if (strcmp(strt.tag, "honest_target") || strcmp(strt.tag, "lying_target")) || (strcmp(strt.tag, "lying_probe"))
        tag = 'T';
    else
        tag = 'NT';
    end
end