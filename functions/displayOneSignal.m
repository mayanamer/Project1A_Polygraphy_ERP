constScript;

%% choose a signal
subject = 5;
session = 2;
rep = 10;
type = 'lying_probe';

% get the correct signal table
signal = final_data.(type){1,subject*session*rep}.tab;

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
plot(t, signal(4, :), "y",'LineWidth',1);
xlabel("time [sec]");
title(type);
legend("FP1", "FP2", "P3", "P4");
grid on;

%disp(signal);