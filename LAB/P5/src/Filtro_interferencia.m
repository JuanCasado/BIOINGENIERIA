
load ecg500.dat
sampling_rate = 500;                    % Hertz
sampling_period = 1/sampling_rate;      % Seconds
elapsed_time=sampling_period*(length(ecg500)-1);
time_vector = 0:sampling_period:elapsed_time;

noise_frequency = 23;
noise = sin(2*pi*noise_frequency*time_vector)';
noise_ecg = noise + ecg500;


figure('Name', 'ECG')
subplot(3,1,1);
plot(time_vector, ecg500)
title('Original ECG');
grid on;

subplot(3,1,2);
plot(time_vector, noise)
title('Noise');
grid on;

subplot(3,1,3);
plot(time_vector, noise_ecg)
title('Noise ECG');
grid on;


figure('Name', 'FFT')
subplot(3,1,1);
fftPlot(time_vector,ecg500);
title('Original ECG')
subplot(3,1,2);
fftPlot(time_vector, noise);
title('FFT Noise ECG');
subplot(3,1,3);
fftPlot(time_vector, noise_ecg);
title('FFT Noise');


figure('Name', 'Wavelet Filter');
clean_ecg = lineabase(noise_ecg, 'db7', 4);

figure('Name', 'FFT Filtered ECG');
fftPlot(time_vector,clean_ecg);
