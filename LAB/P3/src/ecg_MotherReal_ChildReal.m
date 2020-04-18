

% MEASUREMENT DEVICE CONFIGURATION
view_width = 5;                         % Seconds to visualize
noise_rate = 0.05;                      % Measured signals always come with some ammount of noise

% Child ECG from: Fetal ECG Synthetic Datbase
[samples, sample_frequency, original_ecg]=loadATM('16272m', 1);
samples = samples*4;
resampled_ecg = resample(original_ecg, sample_frequency, sample_frequency*2);
child_ecg = [resampled_ecg, resampled_ecg, resampled_ecg, resampled_ecg, resampled_ecg, resampled_ecg, resampled_ecg, resampled_ecg];
original_ecg = [original_ecg, original_ecg, original_ecg, original_ecg];
child_ecg = child_ecg*0.4;
original_amplitude = max(original_ecg);
child_amplitude = max(child_ecg);

% CALCULATE CHILD BPMS
[child_peaks, child_at_times] = findpeaks(child_ecg,'MinPeakHeight', child_amplitude*0.4);
child_at_times = child_at_times*1/sample_frequency;
child_previous_time = 0;
bpms = zeros(1,size(child_at_times,1));
for i = 1:size(child_at_times,1)
    time_interval = child_at_times(i) - child_previous_time;
    bpms(i) = time_interval*sample_frequency;
    child_previous_time = child_at_times(i);
end

% CALCULATE ORIGINAL BPMS
[original_peaks, original_at_times] = findpeaks(original_ecg,'MinPeakHeight', original_amplitude*0.4);
original_at_times = original_at_times*1/sample_frequency;
original_previous_time = 0;
bpms = zeros(1,size(original_at_times,1));
for i = 1:size(original_at_times,1)
    time_interval = original_at_times(i) - original_previous_time;
    bpms(i) = time_interval*sample_frequency;
    original_previous_time = original_at_times(i);
end
original_bpms = mean(bpms);
child_bpms = original_bpms*2;

% Mother ECG
mother_desired_bpms = 65;
mother_wave_resolution = ceil((sample_frequency/mother_desired_bpms)*60);
mother_ecg = original_ecg*4;%createEcg(mother_wave_resolution, child_amplitude*60, samples);
mother_bpms = original_bpms;%calculateBpms(mother_wave_resolution, sample_frequency);
mother_amplitude = max(mother_ecg);

% COMBINED ECG OF MOTHER + CHILD + NOSE (WOULD HAVE BEEN CAPTURED DURING PREGNANCY)
measured_ecg = mother_ecg + child_ecg + noise_rate*randn(1,samples);

% MOTHER ECG + NOSE (WOULD HAVE BEEN CAPTURED WITHOUT PREGNANCY)
reference_signal = mother_ecg + noise_rate*randn(1,samples);
% LMS adaptative filter to extract child ecg from the combined one
lms = dsp.LMSFilter(30, 'StepSize', 0.01);
[stimated_mother_ecg, stimated_child_ecg] = lms(reference_signal', measured_ecg');
stimated_mother_ecg = stimated_mother_ecg';
stimated_child_ecg = stimated_child_ecg';

mother_error = mean((mother_ecg - stimated_mother_ecg).^2);
child_error = mean((child_ecg - stimated_child_ecg).^2);
disp(strcat('Maternal mean squared error: ', num2str(mother_error)));
disp(strcat('Fetal mean squared error: ', num2str(child_error)));

stimated_child_ecg_filtered = filter(1/2*ones(2,1),1,stimated_child_ecg); % Mean filter
%stimated_child_ecg_filtered = medfilt1(stimated_child_ecg, 50); % Median filter
%stimated_child_ecg_filtered = lowpass(stimated_child_ecg, 0.5); % Lowpass filter
child_error = mean((child_ecg - stimated_child_ecg_filtered).^2);
disp(strcat('Fetal mean squared error: ', num2str(child_error)));


% PLOT RESULTS
% Created ECGS
figure('Name', 'ECG Results');
subplot(3,1,1);
hold on
plotEcg(original_ecg, sample_frequency, view_width, original_amplitude, samples)
plot (original_at_times, original_peaks,'k^','MarkerFaceColor','r')
title(strcat('Maternal Heartbeat Signal ', ' BPMS: ', num2str(mother_bpms)));
hold off

subplot(3,1,2);
hold on
plotEcg(child_ecg, sample_frequency, view_width, child_amplitude, samples)
plot (child_at_times, child_peaks,'k^','MarkerFaceColor','r')
title(strcat('Fetal Heartbeat Signal (resampled) ', ' BPMS: ', num2str(child_bpms)));
hold off

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

