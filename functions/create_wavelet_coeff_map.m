
% load feature extraction toolbox folder
addpath("../EEG-Feature-Extraction-Toolbox-main");

%% BAND POWER ANALYSIS

subject_list = {'subject1_session4', 'subject3_session3', ...
    'subject12_session3', 'subject9_session2', 'subject14_session5', ...
    'subject10_session2', 'subject2_session1', 'subject2_session5', ...
    'subject10_session1', 'subject2_session2', 'subject3_session5', ...
    'subject5_session1', 'subject5_session2', 'subject5_session5', ...
    'subject4_session1', 'subject4_session2', 'subject4_session3', ...
    'subject6_session1', 'subject4_session4', 'subject13_session3'};

honest_probe_path = '../data_table_form/honest_probe.mat';
guilty_probe_path = '../data_table_form/lying_probe.mat';

list = getVarNames(guilty_probe_path);

probe_feat_wt_coeff = getWaveletCoefficientsMat(list, honest_probe_path, guilty_probe_path, 10);

save("probe_feat_wt_coeff.mat", "probe_feat_wt_coeff");



%%
% get wavelet coefficients vector for all subjects

function wt_coeff_mat = getWaveletCoefficientsMat(var_names, honest_path, guilty_path, channel)
    num_signals = numel(var_names);
    wt_coeff_mat = zeros(num_signals*2*5, 1);
    
   
    % guilty results

    for i = 1:num_signals
        var_name = var_names{:, i};
        load(guilty_path, var_name);
        signal = eval(var_name);
        signal = avg_with_channels(signal, 1.6, 0.002, [channel]);
        signal = signal(:, 0.6*500:0.9*500);
        wt_coeff_mat(5*(i-1)+1:5*i,1) = wvt_coeff(signal).';
    end


    % honest results

    for i = 1:num_signals
        var_name = var_names{:, i};
        load(honest_path, var_name);
        signal = eval(var_name);
        signal = avg_with_channels(signal, 1.6, 0.002, [channel]);
        signal = signal(1, 0.6*500:0.9*500);
        wt_coeff_mat(5*(i-1+num_signals)+1:5*(i+num_signals),1) = wvt_coeff(signal).';
    end

end



%%
function [mean_signal, is_relevant] = avg_of_segments(signal, segment_len, sample_rate)

    numSegments = size(signal,2);
    sum_signal = sum(signal, 2);
    mean_signal = (sum_signal / numSegments).';
    is_relevant = true;
    
end
%%

function [mean_signal_channels, is_signal_good] = avg_with_channels(signal_w_all_channels, segment_len, sample_rate, channels)

    sum_of_mean_signals = zeros(1, segment_len/sample_rate);
    num_of_channels_used = length(channels);
    is_signal_good = true;
    for i = 1:numel(channels)
        % Access the current element using the loop index
        ch_num = channels(i);
        
        % Perform operations on the element
        signal_one_channel = signal_w_all_channels(:,:, ch_num);
        [mean_signal, is_relevant] = avg_of_segments(signal_one_channel, segment_len, sample_rate);
        if (is_relevant)
            sum_of_mean_signals = sum_of_mean_signals + mean_signal;
        else
            num_of_channels_used = num_of_channels_used - 1;
        end
    end
    
    if (num_of_channels_used > 0)
        mean_signal_channels = sum_of_mean_signals/length(channels);
    else
        is_signal_good = false;
        mean_signal_channels = zeros(1, segment_len/sample_rate);
    end

end
