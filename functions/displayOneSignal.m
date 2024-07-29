constScript;
% load("final_data_4_channels.mat");
%% choose a signal
subject = 2;
session = 1;
rep = 6;
type = 'lying_probe';

%% get the signal
signal = getSignal(final_data_4_channels, subject, session, rep, type);
avg_signal = signal(5,:);

%% display correlation
%let's plot the signal
figure;


% create a vector t for the time ticks
t_corr = linspace(-0.6, 0.6, 599).';
t = linspace(0, 0.6, (1 - 0.4) * fs).';
signal_cropped = signal(2, :);
signal_cropped = signal_cropped(0.4*fs+1:1*fs);

subplot(3,1,1);
plot(t, signal_cropped, "b",'LineWidth',2);
title("FP2 Signal (subject 2 session 1 rep 6 lying probe)", 'FontSize', 18);
xlabel("Time [sec]", 'FontSize', 18);
ylabel("Amplitude [uV]", 'FontSize', 18);
grid on;
grid minor;
hold on;

signal_cropped2 = signal(4, :);
signal_cropped2 = signal_cropped2(0.4*fs+1:1*fs);

subplot(3,1,2);
plot(t, signal_cropped, "k",'LineWidth',2);
title("P4 Signal (subject 2 session 1 rep 6 lying probe)", 'FontSize', 18);
xlabel("Time [sec]", 'FontSize', 18);
ylabel("Amplitude [uV]", 'FontSize', 18);
grid on;
grid minor;
hold on;

subplot(3,1,3);
corr_result = xcorr(signal_cropped, signal_cropped2);
plot(t_corr, corr_result, "r",'LineWidth',2);
title("Correlation Result", 'FontSize', 18);
xlabel("Delay [sec]", 'FontSize', 18);
ylabel("Amplitude [uV]", 'FontSize', 18);

grid on;
grid minor;



%% display referencing per average or without
t = linspace(0, 1.6, 1.6 * fs).';

figure;
plot(t, signal(1,:) - signal(5,:), 'Color', 'r');
hold on;
plot(t, signal(2,:) - signal(5,:), 'Color', 'b');
hold on;
plot(t, signal(3,:) - signal(5,:), 'Color', 'g');
hold on;
plot(t, signal(4,:) - signal(5,:), 'Color', 'm');
hold on;
plot(t, signal(5,:), 'Color', 'k', 'LineWidth', 2);
title('Signal After Subtracting the Average, Lying Probe', 'FontSize', 18);
legend('Fp1', 'Fp2', 'P3', 'P4', 'Average');
xlabel('Time [sec]', 'FontSize', 16);
ylabel('Amplitude [uV]', 'FontSize', 16);
grid on;
grid minor;

