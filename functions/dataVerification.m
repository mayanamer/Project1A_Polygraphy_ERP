%% average of one type all signals for one subject
% the purpose is to show proof of the correctness of the data
constScript;

%% decide which person / type of signal
subject_num = 8;

%% display the avg signal

figure;
hold on;
colors = {"b", "r", "g"};
signal_types = {'target', 'probe', 'irrelevant'};
for j = 1:length(signal_types)
    type = signal_types{j};
    avg_signal = calcAvgSignalPerSub(final_data_4_channels, subject_num, "honest", type);
    
    subplot(2, 1, 1);

    % create a vector t for the time ticks
    t = linspace(t_start, t_end, length(avg_signal)).';
    
    plot(t, avg_signal(1,:), colors{j});
    hold on;
    
    xlabel("time [sec]");
    title("honest" + ", subject " + subject_num);
    grid on;
    

end
legend(signal_types);


for j = 1:length(signal_types)
    type = signal_types{j};
    avg_signal = calcAvgSignalPerSub(final_data_4_channels, subject_num, "lying", type);
    
    subplot(2, 1, 2);

    % create a vector t for the time ticks
    t = linspace(t_start, t_end, length(avg_signal)).';
    
    plot(t, avg_signal(1,:), colors{j});
    hold on;
    
    xlabel("time [sec]");
    title("lying" + ", subject " + subject_num);
    grid on;
    

end
legend(signal_types);
%% this function calculates the average signal of one subject, lying or honest
function [avg_signal] = calcAvgSignalPerSub(data, subject_num, honest_or_lying, signal_type)
    all_relevant_signals = data.(honest_or_lying +"_"+ signal_type);
    
    filtered_signals = {};  % Initialize an empty cell array to store filtered structs
    
    for i = 1:numel(all_relevant_signals)
        % Check if the 'sub' field of the struct matches subject_num
        if all_relevant_signals{1,i}.sub == subject_num
            % If it does, add the struct to the filtered_signals cell array
            filtered_signals{end+1} = all_relevant_signals{1,i};
        end
    end
    
    % create an array that has the avg of the 4 electrodes in each cell
    avg_arr = {};
    for i = 1:numel(filtered_signals)
        avg_arr{i} = filtered_signals{i}.tab(5, :);
    end
    
    % Calculate the maximum length of vectors in avg_arr
    max_length = max(cellfun(@numel, avg_arr));
    
    % Initialize a matrix to store padded vectors
    padded_vectors = NaN(numel(avg_arr), max_length);
    
    % Pad or truncate vectors in avg_arr to have the same length
    for i = 1:numel(avg_arr)
        padded_vectors(i, 1:numel(avg_arr{i})) = avg_arr{i};
    end
    
    % Calculate the mean along the first dimension
    avg_signal = mean(padded_vectors, 1, 'omitnan');
end


