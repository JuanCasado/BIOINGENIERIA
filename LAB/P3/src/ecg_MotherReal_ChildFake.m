
% MEASUREMENT DEVICE CONFIGURATION
view_width = 5;                         % Seconds to visualize
noise_rate = 0.05;                      % Measured signals always come with some ammount of noise

% Mother ECG from: MIT-BIH Long-Term ECG Database
[samples, sample_frequency, mother_ecg]=loadATM('14046m', 1);
samples = min(samples, 29*sample_frequency);
mother_ecg = mother_ecg(1:samples)*10;
mother_amplitude = max(mother_ecg);

% CALCULATE MOTHER BPMS
[peaks, at_times] = findpeaks(mother_ecg,'MinPeakHeight', mother_amplitude*0.4);
at_times = at_times*1/sample_frequency;
previous_time = 0;
bpms = zeros(1,size(at_times,1));
for i = 1:size(at_times,1)
    time_interval = at_times(i) - previous_time;
    bpms(i) = time_interval*sample_frequency;
    previous_time = at_times(i);
end
mother_bpms = mean(bpms);

% CHILD ECG
% Calculte the points of the child ecg wave based on the desired bpms for it
child_desired_bpms = 150;
child_wave_resolution = ceil((sample_frequency/child_desired_bpms)*60);
child_ecg = createEcg(child_wave_resolution, mother_amplitude/15, samples, 3);
child_amplitude = max(child_ecg);
child_bpms = calculateBpms(child_wave_resolution, sample_frequency);

% COMBINED ECG OF MOTHER + CHILD + NOSE (WOULD HAVE BEEN CAPTURED DURING PREGNANCY)
measured_ecg = mother_ecg + child_ecg + noise_rate*randn(1,samples);

% MOTHER ECG + NOSE (WOULD HAVE BEEN CAPTURED WITHOUT PREGNANCY)
reference_signal = mother_ecg + noise_rate*randn(1,samples);
% LMS adaptative filter to extract child ecg from the combined one
lms = dsp.LMSFilter(15, 'StepSize', 0.0007);
[stimated_mother_ecg, stimated_child_ecg] = lms(reference_signal', measured_ecg');
stimated_mother_ecg = stimated_mother_ecg';
stimated_child_ecg = stimated_child_ecg';

mother_error = mean((mother_ecg - stimated_mother_ecg).^2);
child_error = mean((child_ecg - stimated_child_ecg).^2);
disp(strcat('Maternal mean squared error: ', num2str(mother_error)));
disp(strcat('Fetal mean squared error: ', num2str(child_error)));

stimated_child_ecg_filtered = filter(1/3*ones(3,1),1,stimated_child_ecg); % Mean filter
%stimated_child_ecg_filtered = medfilt1(stimated_child_ecg, 2); % Median filter
%stimated_child_ecg_filtered = lowpass(stimated_child_ecg, 0.35); % Lowpass filter
child_error = mean((child_ecg - stimated_child_ecg_filtered).^2);
disp(strcat('Fetal mean squared error: ', num2str(child_error)));

% PLOT RESULTS
% Created ECGS
figure('Name', 'ECG Results');
subplot(3,1,1);
hold on
plotEcg(mother_ecg, sample_frequency, view_width, mother_amplitude, samples)
plot (at_times, peaks,'k^','MarkerFaceColor','r')
title(strcat('Maternal Heartbeat Signal ', ' BPMS: ', num2str(mother_bpms)));
hold off

subplot(3,1,2);
plotEcg(child_ecg, sample_frequency, view_width, child_amplitude, samples)
title(strcat('Fetal Heartbeat Signal ', ' BPMS: ', num2str(child_bpms)));

subplot(3,1,3);
plotEcg(measured_ecg, sample_frequency, view_width, max(measured_ecg), samples)
title('Measured Signal');

% Filter Child ECG from Mother's
figure('Name', 'Filter Fetal ECG');
subplot(3,1,1);
plotEcg(reference_signal, sample_frequency, view_width, max(reference_signal), samples)
title('Reference Signal (Maternal ECG)');

subplot(3,1,2);
hold on
plotEcg(reference_signal, sample_frequency, view_width, max(reference_signal), samples)
plotEcg(stimated_child_ecg, sample_frequency, view_width, max(reference_signal), samples)
grid;
legend('Reference Signal', 'Error Signal');
title('Convergence of Adaptative Nose Canceller');
hold off

subplot(3,1,3);
plotEcg(stimated_child_ecg, sample_frequency, view_width, max(stimated_child_ecg), samples)
title('Steady-State Error Signal (Fetal ECG)');

% Compare Filtered ECG to created
figure('Name', 'Compare Filtered to created ECGs');
subplot(3,1,1);
hold on
plotEcg(mother_ecg, sample_frequency, view_width, mother_amplitude, samples)
plotEcg(stimated_mother_ecg, sample_frequency, view_width, mother_amplitude, samples)
grid;
legend('Mother ECG', 'Mother ECG from filter');
title('Comparation between Maternal ECG and the one obtained by the filter');
hold off

subplot(3,1,2);
hold on
plotEcg(child_ecg, sample_frequency, view_width, child_amplitude, samples)
plotEcg(stimated_child_ecg, sample_frequency, view_width, child_amplitude, samples)
grid;
legend('Fetal ECG', 'Fetal ECG from filter');
title('Comparation between Fetal ECG and the one obtained by the filter');
hold off

subplot(3,1,3);
hold on
plotEcg(child_ecg, sample_frequency, view_width, child_amplitude, samples)
plotEcg(stimated_child_ecg_filtered, sample_frequency, view_width, child_amplitude, samples)
grid;
legend('Fetal ECG', 'Fetal ECG from filter (processed)');
title('Comparation between Fetal ECG and the one obtained by the filter (processed)');
hold off
