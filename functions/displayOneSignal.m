constScript;

%% choose a signal
subject = 7;
session = 3;
rep = 6;
type = 'honest_irrelevant';
high = 25;
low = 0.3;
% get the correct signal table
signal = final_data_4_channels.(type){1,subject*session*rep}.tab;
% 
% signal(1,:) = highpass(signal(1,:), low, high);
% signal(1,:) = lowpass(signal(1,:), low, high);
% 
% signal(2,:) = highpass(signal(2,:), low, high);
% signal(2,:) = lowpass(signal(2,:), low, high);
% 
% signal(3,:) = highpass(signal(3,:), low, high);
% signal(3,:) = lowpass(signal(3,:), low, high);
% 
% signal(4,:) = highpass(signal(4,:), low, high);
% signal(4,:) = lowpass(signal(4,:), low, high);
% 
% signal(5,:) = highpass(signal(5,:), low, high);
% signal(5,:) = lowpass(signal(5,:), low, high);

%let's plot the signal
figure;
ax1 = subplot(1,1,1);

% create a vector t for the time ticks
t = linspace(t_start, t_end, length(signal)).';

plot(t, signal(1,:), "r",'LineWidth',1);
hold on;
plot(t, signal(2, :), "b",'LineWidth',1);
hold on;
plot(t, signal(3, :), "g",'LineWidth',1);
hold on;
plot(t, signal(4, :), "m",'LineWidth',1);
hold on;
plot(t, signal(5, :), ":k",'LineWidth',1);
xlabel("time [sec]");
title(type);
legend("FP1", "FP2", "P3", "P4", "avg");
grid on;

%disp(signal);

