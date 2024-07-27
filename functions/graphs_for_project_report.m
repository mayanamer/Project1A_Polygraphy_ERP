% load("final_data.mat");
% load("final_data.mat");
constScript;
%% display EEG general graph 
% get one session and display all the 12 electrode signals

%% choose a signal
subject = 2;
session = 2;
rep = 2;
type = 'honest_irrelevant';

%% get the signal

%%%%%% all signals in one graph
% signal = final_data.(type){1,subject*session*rep}.tab;
% % signal = signal(0.6*500:0.9*500);
% %let's plot the signal
% figure;
% ax1 = subplot(1,1,1);
% 
% % create a vector t for the time ticks
% t = linspace(0, 1.6, length(signal)).';
% 
% for i = 1:12
%     plot(t, signal(i,:), "k",'LineWidth',1);
%     hold on;
% end
% 
% xlabel("time [sec]");
% title("12 EEG ELECTRODES");
% grid on;


%%%%%%%%%%%%%% every signal in a different subplot
signal = final_data.(type){1,subject*session*rep}.tab;
% signal = signal(0.6*500:0.9*500);
%let's plot the signal
figure;

% create a vector t for the time ticks
t = linspace(0, 1.6, length(signal)).';

% Loop to create 12 subplots and plot each signal on a separate axis
for i = 1:12
    ax = subplot(12, 1, i); % Create a subplot in the i-th position of a 12x1 grid
    plot(t, signal(i,:), 'k', 'LineWidth', 1);
    xlabel('time [sec]');
    % ylabel(['Electrode ' num2str(i)]);
    grid on;
    
    % Only add title to the first subplot
    if i == 1
        title('12 EEG ELECTRODES');
    end
    
    % Optional: remove x-axis labels for all but the last subplot
    if i ~= 12
        set(ax, 'XTickLabel', []);
    end
end

%% display concatenated raw data

signal_path = "..\honest\subject1\session1\target\target.txt";
raw_signal = load(signal_path);
raw_signal = raw_signal.';
Fs = 500; % Example: 500 Hz
        
numRows = size(raw_signal, 1);

t = (0:numRows-1);
% Plot the signal
figure;
plot(t, raw_signal(:,4), 'k', 'LineWidth', 1);
xlabel('sample');
ylabel('Amplitude');
title('Raw Signal of Honest Target');
grid on;
hold on;

% Draw vertical lines every 800 points
xlinePositions = 800:800:numRows; % Positions to draw vertical lines
for i = 1:length(xlinePositions)
    xline(t(xlinePositions(i)), 'r--'); % Draw red dashed vertical lines
end


%% display average for subject

subject = 3;

signal_types = {'lying_target', 'lying_probe', 'lying_irrelevant'};
signal_colors = {'k', 'r', 'b'};
figure;

for type = 1:3
    sig_type = signal_types{type};
    counter = 0;
    sum_signal = zeros(800);
    for member = 1:length(final_data_4_channels.(sig_type))
        if final_data_4_channels.(sig_type){member}.sub == subject
            sum_signal = sum_signal + final_data_4_channels.(sig_type){member}.tab(5,:);
            counter = counter + 1;
        end
    end
    avg_signal = sum_signal/counter;
    % Plot the signal
    subplot(3, 1, type);
    t = linspace(-0.4, 1.2, length(avg_signal)).';
    
    plot(t, avg_signal.', signal_colors{type}, 'LineWidth', 1);
    xlabel('Time [sec]');
    ylabel('Amplitude [uV]');
    title(['subject ' num2str(subject) ' ' sig_type ' (# signals: ' num2str(counter) ')'], 'Interpreter', 'none');
    grid on;
    xline(0, 'r--', 'LineWidth', 2);
    hold on;
end

hold off;


%% display average for all subjects and all signals in a box plot

% Initialize the vectors
fp1 = zeros(15, 1);
fp2 = zeros(15, 1);
p3 = zeros(15, 1);
p4 = zeros(15, 1);

figure;

signal_types = {'lying_target', 'lying_probe', 'lying_irrelevant'};

for t = 1:3
    % Loop through each subject
    for i = 1:15
        sig_type = signal_types{t};
        counter = 0;
        sum_signal_FP1 = zeros(1, 800); % Initialize as row vectors
        sum_signal_FP2 = zeros(1, 800);
        sum_signal_P3 = zeros(1, 800);
        sum_signal_P4 = zeros(1, 800);
        for member = 1:length(final_data_4_channels.(sig_type))
            if final_data_4_channels.(sig_type){member}.sub == i
                sum_signal_FP1 = sum_signal_FP1 + final_data_4_channels.(sig_type){member}.tab(1,:);
                sum_signal_FP2 = sum_signal_FP2 + final_data_4_channels.(sig_type){member}.tab(2,:);
                sum_signal_P3 = sum_signal_P3 + final_data_4_channels.(sig_type){member}.tab(3,:);
                sum_signal_P4 = sum_signal_P4 + final_data_4_channels.(sig_type){member}.tab(4,:);
                counter = counter + 1;
            end
        end
        
        if counter > 0
            avg_signal_FP1 = sum_signal_FP1 / counter;
            avg_signal_FP2 = sum_signal_FP2 / counter;
            avg_signal_P3 = sum_signal_P3 / counter;
            avg_signal_P4 = sum_signal_P4 / counter;
    
            fp1(i) = mean(avg_signal_FP1);
            fp2(i) = mean(avg_signal_FP2);
            p3(i) = mean(avg_signal_P3);
            p4(i) = mean(avg_signal_P4);
        end
    end

    % Combine the vectors into a single column vector with a grouping variable
    data = [fp1; fp2; p3; p4];
    group = [repmat({'FP1'}, 15, 1); repmat({'FP2'}, 15, 1); repmat({'P3'}, 15, 1); repmat({'P4'}, 15, 1)];
    
    % Create the box plot
    subplot(1, 3, t);
    boxplot(data, group, 'Symbol', '');
    title(['Average Per Channel for 15 Subjects - ' sig_type], 'Interpreter', 'none');
    grid on;
    ylabel('Signal Mean Value');

    % Set the y-axis limits

    ylim([-8,8]);
    hold on;

end

hold off;

%% display average for ALLLLLL signals

% Initialize variables to store average signals
n_samples = (1 - 0.4) * fs;  % Number of samples after cropping
avg_signals_l = zeros(n_samples, 3);  % Three signals for lying types
avg_signals_h = zeros(n_samples, 3);  % Three signals for honest types

% Process lying signals
signal_types = {'lying_target', 'lying_probe', 'lying_irrelevant'};
signal_colors = {'k', 'r', 'b'};

figure;
t = linspace(0, 0.8, n_samples).';  % Adjust time vector based on cropping range

% Plotting lying signals
subplot(2, 1, 1);  % Create subplot for lying signals
hold on;

for type = 1:3
    sig_type = signal_types{type};
    counter = 0;
    sum_signal = zeros(n_samples, 1); % Initialize as column vector
    for member = 1:length(final_data_4_channels.(sig_type))
        cropped_sig = final_data_4_channels.(sig_type){member}.tab(5,:);
        cropped_sig = cropped_sig(0.4*fs+1:1*fs);  % Adjust cropping range
        sum_signal = sum_signal + cropped_sig.';
        counter = counter + 1;
    end
    avg_signals_l(:, type) = sum_signal / counter; % Average signal for this type
    
    % Plot the signal
    plot(t, avg_signals_l(:, type), signal_colors{type}, 'LineWidth', 1);
end

hold off;

% Customize subplot properties for lying signals
xlabel('Time [sec]');
ylabel('Amplitude [uV]');
grid on;
title('Lying Signals');
legend('lying\_target', 'lying\_probe', 'lying\_irrelevant');

% Process honest signals
signal_types = {'honest_target', 'honest_probe', 'honest_irrelevant'};
signal_colors = {'k', 'r', 'b'};

% Plotting honest signals
subplot(2, 1, 2);  % Create subplot for honest signals
hold on;

for type = 1:3
    sig_type = signal_types{type};
    counter = 0;
    sum_signal = zeros(n_samples, 1); % Initialize as column vector
    for member = 1:length(final_data_4_channels.(sig_type))
        cropped_sig = final_data_4_channels.(sig_type){member}.tab(5,:);
        cropped_sig = cropped_sig(0.4*fs+1:1*fs);  % Adjust cropping range
        sum_signal = sum_signal + cropped_sig.';
        counter = counter + 1;
    end
    avg_signals_h(:, type) = sum_signal / counter; % Average signal for this type
    
    % Plot the signal
    plot(t, avg_signals_h(:, type), signal_colors{type}, 'LineWidth', 1);
end

hold off;

% Customize subplot properties for honest signals
xlabel('Time [sec]');
ylabel('Amplitude [uV]');
grid on;
title('Honest Signals');
legend('honest\_target', 'honest\_probe', 'honest\_irrelevant');


%% display un-averaged single signal 

% which signal should we take?
subject = 2;
session = 2;
rep = 2;


% Initialize variables to store average signals
n_samples = (1 - 0.4) * fs;  % Number of samples after cropping
avg_signals_l = zeros(n_samples, 3);  % Three signals for lying types
avg_signals_h = zeros(n_samples, 3);  % Three signals for honest types

% Process lying signals
signal_types = {'lying_target', 'lying_probe', 'lying_irrelevant'};
signal_colors = {'k', 'r', 'b'};

figure;
t = linspace(0, 0.8, n_samples).';  % Adjust time vector based on cropping range

% Plotting lying signals
subplot(2, 1, 1);  % Create subplot for lying signals
hold on;

for type = 1:3
    sig_type = signal_types{type};
    counter = 0;
   
    signal = final_data_4_channels.(sig_type){member}.tab(5,:);
    
    % Plot the signal
    plot(t, avg_signals_l(:, type), signal_colors{type}, 'LineWidth', 1);
end

hold off;

% Customize subplot properties for lying signals
xlabel('Time [sec]');
ylabel('Amplitude [uV]');
grid on;
title('Lying Signals');
legend('lying\_target', 'lying\_probe', 'lying\_irrelevant');

% Process honest signals
signal_types = {'honest_target', 'honest_probe', 'honest_irrelevant'};
signal_colors = {'k', 'r', 'b'};

% Plotting honest signals
subplot(2, 1, 2);  % Create subplot for honest signals
hold on;

for type = 1:3
    sig_type = signal_types{type};
    counter = 0;
    sum_signal = zeros(n_samples, 1); % Initialize as column vector
    for member = 1:length(final_data_4_channels.(sig_type))
        cropped_sig = final_data_4_channels.(sig_type){member}.tab(5,:);
        cropped_sig = cropped_sig(0.4*fs+1:1*fs);  % Adjust cropping range
        sum_signal = sum_signal + cropped_sig.';
        counter = counter + 1;
    end
    avg_signals_h(:, type) = sum_signal / counter; % Average signal for this type
    
    % Plot the signal
    plot(t, avg_signals_h(:, type), signal_colors{type}, 'LineWidth', 1);
end

hold off;

% Customize subplot properties for honest signals
xlabel('Time [sec]');
ylabel('Amplitude [uV]');
grid on;
title('Honest Signals');
legend('honest\_target', 'honest\_probe', 'honest\_irrelevant');


