constScript;
% load("final_data_4_channels.mat");
%% choose a signal
subject = 3;
session = 4;
rep =14;
type = 'honest_probe';

%% get the signal
signal = getSignal(final_data_4_channels, subject, session, rep, type);
avg_signal = signal(5,:);

%%
%let's plot the signal
figure;
% ax1 = subplot(2,1,1);

% create a vector t for the time ticks
% t = linspace(0, 1598, 1599).';
t = linspace(0, 1.6, 800).';
% correlation = xcorr(signal(1,:), signal(3,:));
plot(t, signal(2, :), "r",'LineWidth',1);
hold on;
% plot(t, signal(2, :), "g",'LineWidth',1);
% hold on;
% plot(t, signal(3, :), "b",'LineWidth',1);
% hold on;
% plot(t, signal(4, :), "m",'LineWidth',1);
hold on;
% plot(t, signal(5, :), "k",'LineWidth',2);
xlabel("Time [sec]");
ylabel("Amplitude [uV]")

% legend("fp1-p3", "avg");
grid on;
grid minor;

% ax2 = subplot(2,1,2);
% plot(t, signal(3, 0.6*fs+1:1*fs) - signal(1,0.6*fs+1:1*fs), "k",'LineWidth',1);
% hold on;
% xlabel("Time [sec]");
% ylabel("Amplitude [uV]")
% legend("P3 - FP1");
% grid on;
% grid minor;
%disp(signal);


%% display probe vs target vs irrelevant


