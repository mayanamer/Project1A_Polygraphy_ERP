constScript;

%% choose a signal
subject = 8;
session = 2;
rep = 10;
type = 'lying_probe';

% get the correct signal table
signal = final_data.(type){1,subject*session*rep}.tab;

signal(1,:) = highpass(signal(1,:), f_low, f_high);
signal(1,:) = lowpass(signal(1,:), f_low, f_high);

signal(2,:) = highpass(signal(2,:), f_low, f_high);
signal(2,:) = lowpass(signal(2,:), f_low, f_high);

signal(3,:) = highpass(signal(3,:), f_low, f_high);
signal(3,:) = lowpass(signal(3,:), f_low, f_high);

signal(4,:) = highpass(signal(4,:), f_low, f_high);
signal(4,:) = lowpass(signal(4,:), f_low, f_high);

signal(5,:) = highpass(signal(5,:), f_low, f_high);
signal(5,:) = lowpass(signal(5,:), f_low, f_high);

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
plot(t, signal(5, :), "k",'LineWidth',2);
xlabel("time [sec]");
title(type);
legend("FP1", "FP2", "P3", "P4", "avg");
grid on;

%disp(signal);