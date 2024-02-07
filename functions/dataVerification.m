%% average of one type all signals for one subject
% the purpose is to show proof of the correctness of the data
constScript;
%% decide which person / type of signal
subject_num = 6;
honest_or_lying = 'lying';
signal_type = 'probe';

%% get the signal and the average
all_relevant_signals = final_data.(honest_or_lying +"_"+ signal_type);

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
    sum_vector = filtered_signals{1,i}.tab(electrodes.enum.Fp1.index(),:) + ...
                 filtered_signals{1,i}.tab(electrodes.enum.Fp2.index(),:) + ...
                 filtered_signals{1,i}.tab(electrodes.enum.P3.index(),:) + ...
                 filtered_signals{1,i}.tab(electrodes.enum.P4.index(),:);

    avg_arr{i} = sum_vector/4;
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

%% display the avg signal

figure;
ax1 = subplot(1,1,1);

% create a vector t for the time ticks
t = linspace(t_start, t_end, length(avg_signal)).';

plot(t, avg_signal(1,:), "b",'LineWidth',1);
hold on;

xlabel("time [sec]");
title(honest_or_lying + " " + signal_type);
grid on;

%disp(signal);

