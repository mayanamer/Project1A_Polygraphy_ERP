constScript;
subjects_num = 15;
signal_types = {'lying_target', 'lying_irrelevant', 'honest_target', 'honest_irrelevant'};

% Note - we want the cropped signal to be 0.4 seconds long -> 0.4 * Fs samples (from 0.6s to 1s in the recording)
signal_length = 0.4 * fs;

% Initialize a cell array to store the average signals
average_signals = cell(subjects_num, length(signal_types));
average_signals_features = cell(subjects_num, length(signal_types));

for t = 1:length(signal_types)
    % Loop through each subject
    for i = 1:subjects_num
        sig_type = signal_types{t};
        counter = 0;
        sum_signal = zeros(1, signal_length);
        for member = 1:length(final_data_4_channels.(sig_type))
            if final_data_4_channels.(sig_type){member}.sub == i
                signal = final_data_4_channels.(sig_type){member}.tab(5,:);
                signal = signal(0.6*fs+1:1*fs);
                sum_signal = sum_signal + signal;
                counter = counter + 1;
            end
        end
        
        if counter > 0
            avg_signal = sum_signal / counter;
            % Store the average signal in the cell array
            average_signals{i, t} = avg_signal;
            average_signals_features{i, t} = extractFeatures(avg_signal);
        end
    end
end

% Convert the cell array to a table for better readability
average_signals_table = array2table(average_signals, 'VariableNames', signal_types);
average_features_table = array2table(average_signals_features, 'VariableNames', signal_types);

save("average_signals_table.mat","average_signals_table","-mat");
save("average_features_table.mat","average_features_table","-mat");

