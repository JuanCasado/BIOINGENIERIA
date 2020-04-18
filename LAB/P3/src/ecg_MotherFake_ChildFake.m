
% MEASUREMENT DEVICE CONFIGURATION
samples = 30000;                        % Points in the multy_ecg_wave                     
sample_frequency = 4000;                % Frecuency at which ecg is recorded
view_width = 3;                         % Seconds of ecg to visualize
noise_rate = 0.05;                      % Measured signals always come with some ammount of noise

% ECG CONFIGURATION
mother_wave_resolution = 2700;          % Points in a single ecg wave
mother_amplitude = 3.5;                 % Maximun amplitude of the ecg wave
child_wave_resolution = 1725;           % Points in a single ecg wave
child_amplitude = 0.25;                 % Maximun amplitude of the ecg wave

% MOTHER ECG
mother_ecg = createEcg(mother_wave_resolution, mother_amplitude, samples);
mother_bpms = calculateBpms(mother_wave_resolution, sample_frequency);

% CHILD ECG
child_ecg = createEcg(child_wave_resolution, child_amplitude, samples);
child_bpms = calculateBpms(child_wave_resolution, sample_frequency);

% COMBINED ECG OF MOTHER + CHILD + NOSE (WOULD HAVE BEEN CAPTURED DURING PREGNANCY)
fir_coeficients = [0 1 -0.5 -0.8 1 -0.1 0.2 -0.3 0.6 0.1];
measured_ecg = filter(fir_coeficients, 1, mother_ecg) + child_ecg + noise_rate*randn(1,samples);

% MOTHER ECG + NOSE (WOULD HAVE BEEN CAPTURED WITHOUT PREGNANCY)
reference_signal = mother_ecg + noise_rate*randn(1,samples);
% LMS adaptative filter to extract child ecg from the combined one
lms = dsp.LMSFilter(15, 'StepSize', 0.00007);
[stimated_mother_ecg, stimated_child_ecg] = lms(reference_signal', measured_ecg');
stimated_mother_ecg = stimated_mother_ecg';
stimated_child_ecg = stimated_child_ecg';

mother_error = mean((mother_ecg - stimated_mother_ecg).^2);
child_error = mean((child_ecg - stimated_child_ecg).^2);
disp(strcat('Maternal mean squared error: ', num2str(mother_error)));
disp(strcat('Fetal mean squared error: ', num2str(child_error)));

stimated_child_ecg_filtered = filter(1/50*ones(50,1),1,stimated_child_ecg); % Mean filter
%stimated_child_ecg_filtered = medfilt1(stimated_child_ecg, 50); % Median filter
%stimated_child_ecg_filtered = lowpass(stimated_child_ecg, 0.01); % Lowpass filter
child_error = mean((child_ecg - stimated_child_ecg_filtered).^2);
disp(strcat('Fetal mean squared error: ', num2str(child_error)));

% PLOT RESULTS
% Created ECGS
figure('Name', 'ECG Results');
subplot(3,1,1);
plotEcg(mother_ecg, sample_frequency, view_width, mother_amplitude, samples)
title(strcat('Maternal Heartbeat Signal ', ' BPMS: ', num2str(mother_bpms)));

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



