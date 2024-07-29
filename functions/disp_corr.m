constScript;
% load("final_data_4_channels.mat");
%% choose a signal
subject = 2;
session = 1;
rep = 6;

%% get the signal
signal_lying_t = getSignal(final_data_4_channels, subject, session, rep, 'lying_target');
signal_lying_t_fp2 = signal_lying_t(2, :);
signal_lying_t_fp2 = signal_lying_t_fp2(:, 0.4*fs+1:1*fs);
signal_lying_t_p4 = signal_lying_t(4, :);
signal_lying_t_p4 = signal_lying_t_p4(:, 0.4*fs+1:1*fs);
signal_lying_t_corr = xcorr(signal_lying_t_fp2, signal_lying_t_p4);

signal_lying_i = getSignal(final_data_4_channels, subject, session, rep, 'lying_irrelevant');
signal_lying_i_fp2 = signal_lying_i(2, :);
signal_lying_i_fp2 = signal_lying_i_fp2(:, 0.4*fs+1:1*fs);
signal_lying_i_p4 = signal_lying_i(4, :);
signal_lying_i_p4 = signal_lying_i_p4(:, 0.4*fs+1:1*fs);
signal_lying_i_corr = xcorr(signal_lying_i_fp2, signal_lying_i_p4);

signal_lying_p = getSignal(final_data_4_channels, subject, session, rep, 'lying_probe');
signal_lying_p_fp2 = signal_lying_p(2, :);
signal_lying_p_fp2 = signal_lying_p_fp2(:, 0.4*fs+1:1*fs);
signal_lying_p_p4 = signal_lying_p(4, :);
signal_lying_p_p4 = signal_lying_p_p4(:, 0.4*fs+1:1*fs);
signal_lying_p_corr = xcorr(signal_lying_p_fp2, signal_lying_p_p4);

signal_honest_t = getSignal(final_data_4_channels, subject, session, rep, 'honest_target');
signal_honest_t_fp2 = signal_honest_t(2, :);
signal_honest_t_fp2 = signal_honest_t_fp2(:, 0.4*fs+1:1*fs);
signal_honest_t_p4 = signal_honest_t(4, :);
signal_honest_t_p4 = signal_honest_t_p4(:, 0.4*fs+1:1*fs);
signal_honest_t_corr = xcorr(signal_honest_t_fp2, signal_honest_t_p4);


signal_honest_i = getSignal(final_data_4_channels, subject, session, rep, 'honest_irrelevant');
signal_honest_i_fp2 = signal_honest_i(2, :);
signal_honest_i_fp2 = signal_honest_i_fp2(:, 0.4*fs+1:1*fs);
signal_honest_i_p4 = signal_honest_i(4, :);
signal_honest_i_p4 = signal_honest_i_p4(:, 0.4*fs+1:1*fs);
signal_honest_i_corr = xcorr(signal_honest_i_fp2, signal_honest_i_p4);


signal_honest_p = getSignal(final_data_4_channels, subject, session, rep, 'honest_probe');
signal_honest_p_fp2 = signal_honest_p(2, :);
signal_honest_p_fp2 = signal_honest_p_fp2(:, 0.4*fs+1:1*fs);
signal_honest_p_p4 = signal_honest_p(4, :);
signal_honest_p_p4 = signal_honest_p_p4(:, 0.4*fs+1:1*fs);
signal_honest_p_corr = xcorr(signal_honest_p_fp2, signal_honest_p_p4);


%%
%let's plot the signal
figure;


% create a vector t for the time ticks
t = linspace(-0.6, 0.6, 599).';

subplot(2,1,1);
plot(t, signal_lying_t_corr, "b",'LineWidth',2);
hold on;
plot(t, signal_lying_i_corr, "g",'LineWidth',2);
hold on;
plot(t, signal_lying_p_corr, "r",'LineWidth',2);
hold on;

xlabel("Time [sec]");
ylabel("Amplitude [uV]")
title("Correlation of FP2 and P4 Guilty (Subject 2 Session 1 Rep 6)")
grid on;
grid minor;
legend('Target', 'Irrelevant', 'Probe');

hold on;
subplot(2,1,2);
plot(t, signal_honest_t_corr, "b",'LineWidth',2);
hold on;
plot(t, signal_honest_i_corr, "g",'LineWidth',2);
hold on;
plot(t, signal_honest_p_corr, "r",'LineWidth',2);
hold on;

xlabel("Time [sec]");
ylabel("Amplitude [uV]")
title("Correlation of FP2 and P4 Honest (Subject 2 Session 1 Rep 6)")
grid on;
grid minor;
legend('Target', 'Irrelevant', 'Probe');
